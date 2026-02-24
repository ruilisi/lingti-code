#!/usr/bin/env zx

import { resolveInstance, getPods } from "./lib/resolve-instance.mjs";

$.shell = "/usr/local/bin/zsh";
$.prefix += "source ~/.lingti/zsh/k8s.zsh;";
$.verbose = false;

const usage = `kdown - Download a file from all pods of a Kubernetes instance

Usage:
  kdown <instance|chart.yaml> <remote_path> <local_dir>
  kdown stellar-v4-server /usr/src/app/log/production.log ./logs
  kdown charts/stellar-go-v3.yaml /usr/src/app/log/production.log ./logs

Arguments:
  instance      app.kubernetes.io/instance label value (or path to YAML chart)
  remote_path   File path inside each pod
  local_dir     Local directory to save files to`;

if (argv.h || argv.help || argv._.length < 3) {
  console.info(usage);
  process.exit(argv.h || argv.help ? 0 : 1);
}

const [rawInstance, remotePath, localDir] = argv._;
const instance = await resolveInstance(rawInstance);

await fs.ensureDir(localDir);

const pods = await getPods(instance);

const basename = path.basename(remotePath);
console.info(`Downloading ${remotePath} from ${pods.length} pod(s): ${pods.join(", ")}`);

$.verbose = true;
for (const pod of pods) {
  await $`kubectl cp ${pod}:${remotePath} ${localDir}/${pod}_${basename} --retries=10`;
}
