#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把这台机器上「Claude Code 的习惯」打包 / 合并到另一台机器。

    claude-pack                      # 打成 ~/Desktop/claude-habits-<host>-<日期>.tar.gz
    claude-pack -o /path/x.tar.gz    # 指定输出
    claude-pack --list               # 只看会打包什么，不产出文件

    claude-merge x.tar.gz            # 合并进本机（已存在的先备份成 .bak-<时间戳>）
    claude-merge x.tar.gz --dry-run  # 只看会动哪些文件
    claude-merge x.tar.gz --force    # 同名单文件不问直接覆盖（仍然备份）

设计取舍
--------
· **清单只写一份**（下面的 ITEMS），pack 和 merge 共用 —— 两边各写一份迟早会漂。
· **只用标准库**（tarfile / json / shutil），换机器不用先装东西。
· **合并不是覆盖**：目录按文件粒度合入（同名的以包里的为准，本机多出来的保留）；
  JSON 深度合并；其它单文件先备份再替换。
· **跨用户名安全**：清单里凡是带绝对路径的键（memory 的项目目录名、mcpServers 的项目键）
  都会把打包机器的 HOME 换成本机 HOME。

⛔ 故意不打包的（在 SKIP 里，改之前先想清楚）
· `~/.claude.json` 整份 —— 混着 OAuth 账号、机器 ID、全部项目会话历史。只抽 mcpServers。
· `projects/`（会话记录）、`sessions/`、`history.jsonl`、`shell-snapshots/`、
  `paste-cache/`、`file-history/` —— 本机运行痕迹，换机器没意义且很大。
· `plugins/` —— 从 marketplace 装的，新机器重装更干净。只导出启用清单。
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import shutil
import socket
import tarfile
import tempfile

HOME = os.path.expanduser("~")
CLAUDE = os.path.join(HOME, ".claude")
MANIFEST = "manifest.json"

# ── 清单：(包内路径, 本机绝对路径, 类型) ──────────────────────────────────
# 类型 dir = 目录按文件合并；json = JSON 深度合并；file = 备份后替换
ITEMS = [
    ("home/CLAUDE.md",          os.path.join(CLAUDE, "CLAUDE.md"),          "file"),
    ("home/settings.json",      os.path.join(CLAUDE, "settings.json"),      "json"),
    ("home/settings.local.json", os.path.join(CLAUDE, "settings.local.json"), "json"),
    ("home/keybindings.json",   os.path.join(CLAUDE, "keybindings.json"),   "json"),
    ("home/skills",             os.path.join(CLAUDE, "skills"),             "dir"),
    ("home/commands",           os.path.join(CLAUDE, "commands"),           "dir"),
    ("home/agents",             os.path.join(CLAUDE, "agents"),             "dir"),
    ("home/output-styles",      os.path.join(CLAUDE, "output-styles"),      "dir"),
    ("home/templates",          os.path.join(CLAUDE, "templates"),          "dir"),
    # ~/.claude/scripts 往往是指向 ~/.lingti/claude/scripts 的软链；
    # settings.json 里的 hook 和 statusLine 写死了 $HOME/.claude/scripts/…，
    # 不跟过去的话新机器每次 Edit/Write 都会报钩子失败。打包时跟随软链取实体。
    ("home/scripts",            os.path.join(CLAUDE, "scripts"),            "dir"),
]

# 项目级 .claude 下这几个子目录才算「习惯」，其余（settings.local.json 之类）不打
PROJECT_SUBDIRS = ("commands", "skills", "agents")
PROJECT_ROOTS = [os.path.join(HOME, "Projects"), os.path.join(HOME, "Desktop", "files")]
PROJECT_SCAN_DEPTH = 3


DANGLING: list[tuple[str, str]] = []   # (软链路径, 它指向的地方)


def _ts() -> str:
    return dt.datetime.now().strftime("%Y%m%d-%H%M%S")


def _add(tar: tarfile.TarFile, src: str, arc: str) -> None:
    """把 src 加进包里，**跟随软链取实体内容**，断链跳过并记下来。

    ⚠️ `tarfile` 默认 `dereference=False`，软链会被原样存成软链 ——
    这台机器上 `~/.claude/skills/*` 和 `~/.claude/scripts` 恰好大量是软链，
    存成软链搬到另一台就是一堆指向不存在路径的坏链（还带着旧用户名）。
    所以 tar 是用 `tarfile.open(..., dereference=True)` 开的（那是构造参数，
    `add()` 上没有这个 kwarg，写在 add 上会直接 TypeError）。
    """
    if os.path.islink(src) and not os.path.exists(src):
        DANGLING.append((src, os.readlink(src)))
        return
    if os.path.isdir(src):
        tar.add(src, arcname=arc, recursive=False)
        for name in sorted(os.listdir(src)):
            _add(tar, os.path.join(src, name), f"{arc}/{name}")
    else:
        tar.add(src, arcname=arc)


def _rel_home(path: str, home: str) -> str:
    """绝对路径 → 相对 HOME 的路径；不在 HOME 下就原样返回（打包时会跳过）。"""
    return os.path.relpath(path, home) if path.startswith(home + os.sep) else path


# ── 收集 ────────────────────────────────────────────────────────────────
def find_project_dirs() -> list[str]:
    """扫出装着真正「习惯」的项目级 .claude 目录。

    ⚠️ 这是最容易丢的一类：像 ~/Projects/lingti-game 这种只是装着几个子仓库的
    外壳目录**本身不是 git 仓库**，里面的 .claude/commands 没有任何版本控制，
    只存在于本机。
    """
    found = []
    for root in PROJECT_ROOTS:
        if not os.path.isdir(root):
            continue
        for cur, dirs, _ in os.walk(root):
            depth = cur[len(root):].count(os.sep)
            if depth >= PROJECT_SCAN_DEPTH:
                dirs[:] = []
                continue
            dirs[:] = [d for d in dirs if d not in (".git", "node_modules", "vendor", ".venv")]
            cd = os.path.join(cur, ".claude")
            if os.path.isdir(cd) and any(
                os.path.isdir(os.path.join(cd, s)) for s in PROJECT_SUBDIRS
            ):
                found.append(cd)
    return sorted(found)


def find_memory_dirs() -> list[str]:
    base = os.path.join(CLAUDE, "projects")
    if not os.path.isdir(base):
        return []
    dirs = (os.path.join(base, p, "memory") for p in os.listdir(base))
    # 空的 memory/ 目录跳过 —— 那是开过但没写过记忆的项目，打进去只是噪音
    return sorted(d for d in dirs if os.path.isdir(d) and os.listdir(d))


def extract_mcp() -> dict:
    p = os.path.join(HOME, ".claude.json")
    if not os.path.exists(p):
        return {}
    try:
        d = json.load(open(p))
    except Exception:
        return {}
    return {
        "global": d.get("mcpServers") or {},
        "byProject": {
            k: v["mcpServers"]
            for k, v in (d.get("projects") or {}).items()
            if v.get("mcpServers")
        },
    }


def enabled_plugins() -> list[str]:
    p = os.path.join(CLAUDE, "settings.json")
    if not os.path.exists(p):
        return []
    try:
        s = json.load(open(p))
    except Exception:
        return []
    return sorted(k for k, v in (s.get("enabledPlugins") or {}).items() if v)


def inventory() -> dict:
    """把要打包的东西列出来（pack 和 --list 共用）。"""
    items = [(a, b, t) for a, b, t in ITEMS if os.path.exists(b)]
    projects = [
        (f"projects/{_rel_home(os.path.dirname(cd), HOME).replace(os.sep, '__')}/{sub}",
         os.path.join(cd, sub),
         os.path.join(_rel_home(os.path.dirname(cd), HOME), ".claude", sub))
        for cd in find_project_dirs()
        for sub in PROJECT_SUBDIRS
        if os.path.isdir(os.path.join(cd, sub))
    ]
    memories = [
        (f"memory/{os.path.basename(os.path.dirname(m))}", m,
         _rel_home(m, HOME))
        for m in find_memory_dirs()
    ]
    return {"items": items, "projects": projects, "memories": memories,
            "mcp": extract_mcp(), "plugins": enabled_plugins()}


# ── pack ────────────────────────────────────────────────────────────────
def cmd_pack(args) -> int:
    inv = inventory()
    if args.list:
        for _, src, _ in inv["items"] + inv["projects"] + inv["memories"]:
            _scan_dangling(src)
        _print_inventory(inv)
        _report_dangling()
        return 0

    out = args.out or os.path.join(
        HOME, "Desktop", f"claude-habits-{socket.gethostname().split('.')[0]}-{_ts()}.tar.gz")
    os.makedirs(os.path.dirname(out), exist_ok=True)

    manifest = {
        "created_at": dt.datetime.now().isoformat(timespec="seconds"),
        "source_home": HOME,
        "source_host": socket.gethostname(),
        "items": [{"arc": a, "dest": _rel_home(b, HOME), "kind": t} for a, b, t in inv["items"]],
        "projects": [{"arc": a, "dest": d} for a, _, d in inv["projects"]],
        "memories": [{"arc": a, "dest": d} for a, _, d in inv["memories"]],
        "mcp": inv["mcp"],
        "plugins": inv["plugins"],
    }

    with tempfile.TemporaryDirectory() as tmp:
        json.dump(manifest, open(os.path.join(tmp, MANIFEST), "w"),
                  ensure_ascii=False, indent=2)
        with tarfile.open(out, "w:gz", dereference=True) as tar:  # 软链存实体内容
            tar.add(os.path.join(tmp, MANIFEST), arcname=MANIFEST)
            for arc, src, _ in inv["items"] + inv["projects"] + inv["memories"]:
                _add(tar, src, arc)

    _print_inventory(inv)
    _report_dangling()
    print(f"\n✅ {out}  ({os.path.getsize(out) / 1024:.0f} KB)")
    print(f"   另一台机器上：claude-merge {os.path.basename(out)}")
    return 0


def _scan_dangling(path: str) -> None:
    if os.path.islink(path) and not os.path.exists(path):
        DANGLING.append((path, os.readlink(path)))
        return
    if os.path.isdir(path):
        for n in sorted(os.listdir(path)):
            _scan_dangling(os.path.join(path, n))


def _report_dangling() -> None:
    if not DANGLING:
        return
    print(f"\n⚠️ 跳过了 {len(DANGLING)} 个断链（软链指向的东西在本机已经不存在）：")
    for p, t in DANGLING:
        print(f"   {os.path.relpath(p, HOME)}  →  {t}")
    print("   这些在本机就已经是坏的，Claude Code 本来也认不出来 —— 不是打包造成的。")


def _print_inventory(inv: dict) -> None:
    print("全局：")
    for arc, src, kind in inv["items"]:
        n = sum(len(f) for _, _, f in os.walk(src)) if os.path.isdir(src) else 1
        print(f"  {arc:<28} {kind:<5} {n} 个文件")
    if inv["projects"]:
        print("项目级（⚠️ 这类常常不在任何 git 里）：")
        for arc, src, dest in inv["projects"]:
            print(f"  {dest:<52} {len(os.listdir(src))} 个")
    if inv["memories"]:
        print("记忆：")
        for arc, src, _ in inv["memories"]:
            print(f"  {arc:<52} {len(os.listdir(src))} 条")
    print(f"MCP：{list(inv['mcp'].get('global') or {})} + 项目级 "
          f"{len(inv['mcp'].get('byProject') or {})} 个")
    print(f"插件清单：{len(inv['plugins'])} 个（不打包二进制，新机器重装）")


# ── merge ───────────────────────────────────────────────────────────────
def deep_merge(base: dict, incoming: dict) -> dict:
    """字典递归合并，incoming 赢；list 直接替换（权限列表这类整体替换更可预期）。"""
    for k, v in incoming.items():
        if isinstance(v, dict) and isinstance(base.get(k), dict):
            deep_merge(base[k], v)
        else:
            base[k] = v
    return base


class Merger:
    def __init__(self, dry: bool, force: bool):
        self.dry, self.force, self.ts = dry, force, _ts()
        self.acted, self.skipped = [], []

    def _say(self, what: str, path: str, note: str = "") -> None:
        tag = "· 将会" if self.dry else "·"
        print(f"{tag} {what:<6} {path}{('  ' + note) if note else ''}")

    def backup(self, path: str) -> None:
        if not os.path.exists(path):
            return
        dst = f"{path}.bak-{self.ts}"
        self._say("备份", os.path.basename(path), f"→ {os.path.basename(dst)}")
        if not self.dry:
            shutil.move(path, dst)

    def merge_dir(self, src: str, dst: str) -> None:
        """按文件合入：同名以包里的为准，本机多出来的保留。"""
        for cur, _, files in os.walk(src):
            rel = os.path.relpath(cur, src)
            target_dir = dst if rel == "." else os.path.join(dst, rel)
            for f in files:
                s, t = os.path.join(cur, f), os.path.join(target_dir, f)
                exists = os.path.exists(t)
                if exists and _same(s, t):
                    self.skipped.append(t)
                    continue
                self._say("覆盖" if exists else "新增",
                          os.path.relpath(t, HOME))
                if not self.dry:
                    os.makedirs(target_dir, exist_ok=True)
                    if exists:
                        shutil.copy2(t, f"{t}.bak-{self.ts}")
                    shutil.copy2(s, t)
                self.acted.append(t)

    def merge_json(self, src: str, dst: str) -> None:
        incoming = json.load(open(src))
        if os.path.exists(dst):
            try:
                base = json.load(open(dst))
            except Exception:
                base = {}
            before = json.dumps(base, sort_keys=True)
            merged = deep_merge(json.loads(before), incoming)
            if json.dumps(merged, sort_keys=True) == before:
                self.skipped.append(dst)      # 合了等于没合，就别白备份一份
                return
            self._say("合并", os.path.relpath(dst, HOME), "(JSON 深度合并)")
            if not self.dry:
                shutil.copy2(dst, f"{dst}.bak-{self.ts}")
                json.dump(merged, open(dst, "w"), ensure_ascii=False, indent=2)
        else:
            self._say("新增", os.path.relpath(dst, HOME))
            if not self.dry:
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                shutil.copy2(src, dst)
        self.acted.append(dst)

    def merge_file(self, src: str, dst: str) -> None:
        if os.path.exists(dst) and _same(src, dst):
            self.skipped.append(dst)
            return
        if os.path.exists(dst) and not self.force:
            # 单文件没法自动合并（CLAUDE.md 这类），默认不动，把包里的放到旁边让人来判
            side = f"{dst}.incoming-{self.ts}"
            self._say("并列", os.path.relpath(side, HOME), "← 本机已有，请自行取舍（--force 可直接覆盖）")
            if not self.dry:
                shutil.copy2(src, side)
            self.acted.append(side)
            return
        if os.path.exists(dst):
            self.backup(dst)
        self._say("写入", os.path.relpath(dst, HOME))
        if not self.dry:
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copy2(src, dst)
        self.acted.append(dst)


def _same(a: str, b: str) -> bool:
    try:
        return open(a, "rb").read() == open(b, "rb").read()
    except Exception:
        return False


def cmd_merge(args) -> int:
    if not os.path.exists(args.archive):
        print(f"⛔ 找不到 {args.archive}")
        return 1

    with tempfile.TemporaryDirectory() as tmp:
        with tarfile.open(args.archive, "r:gz") as tar:
            _safe_extract(tar, tmp)
        mf = os.path.join(tmp, MANIFEST)
        if not os.path.exists(mf):
            print("⛔ 包里没有 manifest.json —— 不是 claude-pack 打的包")
            return 1
        m = json.load(open(mf))
        src_home = m.get("source_home", HOME)
        print(f"来源：{m.get('source_host')}  {m.get('created_at')}")
        if src_home != HOME:
            print(f"路径改写：{src_home} → {HOME}")
        print()

        mg = Merger(args.dry_run, args.force)

        for it in m["items"]:
            src = os.path.join(tmp, it["arc"])
            dst = os.path.join(HOME, it["dest"])
            if not os.path.exists(src):
                continue
            {"dir": mg.merge_dir, "json": mg.merge_json, "file": mg.merge_file}[it["kind"]](src, dst)

        for it in m.get("projects", []):
            src = os.path.join(tmp, it["arc"])
            if os.path.exists(src):
                mg.merge_dir(src, os.path.join(HOME, it["dest"]))

        for it in m.get("memories", []):
            src = os.path.join(tmp, it["arc"])
            if os.path.exists(src):
                mg.merge_dir(src, os.path.join(HOME, _remap_memory(it["dest"], src_home)))

        _merge_mcp(m.get("mcp") or {}, src_home, args.dry_run)

    print()
    print(f"{'将会改动' if args.dry_run else '已改动'} {len(mg.acted)} 处，"
          f"跳过 {len(mg.skipped)} 处（内容一样）")
    plugins = m.get("plugins") or []
    if plugins:
        print("\n还差一件脚本代替不了的事 —— 插件要用 /plugin 在新机器上装一遍：")
        for p in plugins:
            print(f"  · {p}")
    print("\n验证：新开一个 Claude Code，敲 / 看自定义命令在不在。")
    return 0


def _remap_memory(dest: str, src_home: str) -> str:
    """记忆目录名里编着项目的绝对路径，**跨用户名必须改写**。

    Claude Code 把 `/Users/alex/Projects/lingti-game` 编成目录名
    `-Users-alex-Projects-lingti-game`。原样搬到 jiefeng 那台机器上，
    目录名里还是 `-Users-alex-…` —— 文件在，但 Claude Code 永远不会去读，
    表现成「记忆全丢了」。所以把编码过的 HOME 前缀一起换掉。
    """
    if src_home == HOME:
        return dest
    return dest.replace(src_home.replace(os.sep, "-"), HOME.replace(os.sep, "-"), 1)


def _safe_extract(tar: tarfile.TarFile, path: str) -> None:
    """挡住 ../ 越界的成员（别人给的包也可能被处理）。"""
    for m in tar.getmembers():
        target = os.path.realpath(os.path.join(path, m.name))
        if not target.startswith(os.path.realpath(path) + os.sep):
            raise RuntimeError(f"包里有越界路径，已中止：{m.name}")
    tar.extractall(path)


def _merge_mcp(mcp: dict, src_home: str, dry: bool) -> None:
    if not mcp:
        return
    p = os.path.join(HOME, ".claude.json")
    try:
        d = json.load(open(p)) if os.path.exists(p) else {}
    except Exception:
        d = {}
    g = mcp.get("global") or {}
    by = mcp.get("byProject") or {}
    print(f"· {'将会' if dry else ''}合并 MCP：{list(g)} + 项目级 {len(by)} 个 → ~/.claude.json")
    if dry:
        return
    shutil.copy2(p, f"{p}.bak-{_ts()}") if os.path.exists(p) else None
    d.setdefault("mcpServers", {}).update(g)
    projs = d.setdefault("projects", {})
    for old, servers in by.items():
        new = old.replace(src_home, HOME) if src_home != HOME else old
        projs.setdefault(new, {}).setdefault("mcpServers", {}).update(servers)
    json.dump(d, open(p, "w"), ensure_ascii=False, indent=2)


def main() -> int:
    ap = argparse.ArgumentParser(prog="claude-sync", description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("pack", help="打包本机的 Claude 习惯")
    p.add_argument("-o", "--out", help="输出 tar.gz 路径")
    p.add_argument("--list", action="store_true", help="只列清单，不产出文件")
    p.set_defaults(func=cmd_pack)

    m = sub.add_parser("merge", help="把包合并进本机")
    m.add_argument("archive")
    m.add_argument("--dry-run", action="store_true", help="只看会动哪些文件")
    m.add_argument("--force", action="store_true", help="单文件冲突时直接覆盖（仍备份）")
    m.set_defaults(func=cmd_merge)

    args = ap.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
