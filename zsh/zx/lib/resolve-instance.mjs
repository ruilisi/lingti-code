/**
 * Resolve a Kubernetes instance name. If the input looks like a YAML file,
 * parse it and extract the app.kubernetes.io/instance label value.
 * Otherwise return the input as-is.
 */
export async function resolveInstance(input) {
  if (!input.endsWith(".yaml") && !input.endsWith(".yml")) {
    return input;
  }

  const content = await fs.readFile(input, "utf8");

  // Match app.kubernetes.io/instance in labels or as a Helm-style template value
  const match =
    content.match(/app\.kubernetes\.io\/instance:\s*["']?([^\s"']+)/) ||
    content.match(/fullnameOverride:\s*["']?([^\s"']+)/);

  if (!match) {
    console.error(
      `Could not find app.kubernetes.io/instance label in ${input}`
    );
    process.exit(1);
  }

  const instance = match[1];
  console.info(`Resolved instance from ${input}: ${instance}`);
  return instance;
}

/**
 * List all available k8s instance labels in the current context.
 */
export async function listInstances() {
  const raw = (
    await $`kubectl get pods -o jsonpath="{.items[*].metadata.labels['app\\.kubernetes\\.io/instance']}"`.nothrow()
  ).stdout.trim();
  if (!raw) return [];
  return [...new Set(raw.split(/\s+/).filter(Boolean))].sort();
}

/**
 * Require pods for an instance. If none found, print available instances and exit.
 */
export async function getPods(instance) {
  const pods = (
    await $`kubectl get pods -l app.kubernetes.io/instance=${instance} -o custom-columns=":metadata.name"`
  ).stdout
    .trim()
    .split(/\s+/)
    .filter(Boolean);

  if (pods.length === 0) {
    console.error(chalk.red(`No pods found for instance "${instance}"`));
    const available = await listInstances();
    if (available.length > 0) {
      console.error(chalk.yellow("\nAvailable instances:"));
      available.forEach((i) => console.error(`  ${i}`));
    }
    process.exit(1);
  }

  return pods;
}
