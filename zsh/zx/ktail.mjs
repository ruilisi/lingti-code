#!/usr/bin/env zx

$.shell = "/usr/local/bin/zsh";
$.prefix += "source ~/.lingti/zsh/k8s.zsh;";
$.verbose = false;

const usage = `ktail - Tail a file across all pods of a Kubernetes instance

Usage:
  ktail <instance> <file>
  ktail stellar-v4-server /usr/src/app/log/production.log

Arguments:
  instance    app.kubernetes.io/instance label value
  file        File path to tail inside each pod`;

if (argv.h || argv.help || argv._.length < 2) {
  console.info(usage);
  process.exit(argv.h || argv.help ? 0 : 1);
}

const [instance, file] = argv._;

const pods = (
  await $`kubectl get pods -l app.kubernetes.io/instance=${instance} -o custom-columns=":metadata.name"`
).stdout
  .trim()
  .split(/\s+/)
  .filter(Boolean);

if (pods.length === 0) {
  console.error(`No pods found for instance "${instance}"`);
  process.exit(1);
}

console.info(`Tailing ${file} on ${pods.length} pod(s): ${pods.join(", ")}`);

$.verbose = true;
await Promise.all(pods.map((pod) => $`kubectl exec -it ${pod} -- tail -f ${file}`));
