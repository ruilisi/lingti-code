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
