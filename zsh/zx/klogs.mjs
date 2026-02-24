#!/usr/bin/env zx

import { resolveInstance, listInstances } from "./lib/resolve-instance.mjs";

$.shell = "/usr/local/bin/zsh";
$.prefix += "source ~/.lingti/zsh/k8s.zsh;";
$.verbose = true;

if (argv.h) {
  console.info(`klogs - Tail Kubernetes pod logs by instance or deployment

Usage:
  klogs -i <instance|chart.yaml> [-n NAMESPACE] [--tail N]
  klogs -d <deployment> [-n NAMESPACE]

Options:
  -i    Instance name or path to a YAML chart file
  -d    Deployment name
  -n    Namespace (default: default)
  --tail  Number of lines (default: 100)
  -h    Show this help`);
  process.exit();
}
const { d, _, n = "default", tail = 100 } = argv;
let { i } = argv;

if (i) {
  i = await resolveInstance(i);
  while (true) {
    await $`kubectl logs -f -n ${n} --tail ${tail} -l app.kubernetes.io/instance=${i} 2>&1 || true; sleep 2`;
  }
} else if (d) {
  await $`kubectl logs -f deployment/${d} --all-containers=true --since=24h --pod-running-timeout=2s 2>&1`;
} else {
  console.error("Error: specify -i <instance> or -d <deployment>");
  const available = await listInstances();
  if (available.length > 0) {
    console.error(chalk.yellow("\nAvailable instances:"));
    available.forEach((inst) => console.error(`  ${inst}`));
  }
  process.exit(1);
}
