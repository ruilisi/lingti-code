#!/usr/bin/env zx

$.verbose = false;

const usage = `gitcopy - Format git commits as markdown and copy to clipboard

Usage:
  gitcopy [commit] [-n count]
  gitcopy                     # latest commit
  gitcopy abc1234             # specific commit
  gitcopy -n 3                # last 3 commits
  gitcopy abc1234 -n 5        # 5 commits starting from abc1234

Arguments:
  commit      Commit ref (default: HEAD)

Options:
  -n          Number of commits (default: 1)`;

if (argv.h || argv.help) {
  console.info(usage);
  process.exit(0);
}

const commit = argv._.length > 0 ? argv._[0] : "HEAD";
const n = argv.n || 1;

const prefix = (
  await $`git remote get-url origin`
).stdout
  .trim()
  .replace(/git@github\.com:/, "https://github.com/")
  .replace(/\.git$/, "");

const projectName = prefix.split("/").pop();

const commits = (
  await $`git log ${commit} -n ${n} --stat --pretty=${`\n* [${projectName}](${prefix}/commit/%H) %an: **%s**`}`
).stdout
  .split("\n")
  .map((line) => (line.startsWith("*") || line === "" ? line : `> ${line}`))
  .join("\n");

console.info(commits);

try {
  await $`echo ${commits}`.pipe($`pbcopy`);
} catch {
  // pbcopy not available, output only
}
