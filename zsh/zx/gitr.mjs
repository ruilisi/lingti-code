#!/usr/bin/env zx

$.verbose = false;

const usage = `gitr - Run a git command across all repos in current directory

Usage:
  gitr <git-args...>
  gitr status
  gitr pull --rebase

Arguments:
  git-args    Any arguments passed to git in each subdirectory`;

if (argv.h || argv.help || argv._.length < 1) {
  console.info(usage);
  process.exit(argv.h || argv.help ? 0 : 1);
}

const gitArgs = process.argv.slice(3);
const entries = await fs.readdir(".", { withFileTypes: true });

for (const entry of entries) {
  if (!entry.isDirectory()) continue;
  const gitDir = path.join(entry.name, ".git");
  if (!await fs.pathExists(gitDir)) continue;

  console.info(chalk.green(entry.name));
  $.verbose = true;
  await $`git -C ${entry.name} ${gitArgs}`.nothrow();
  $.verbose = false;
}
