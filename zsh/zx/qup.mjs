#!/usr/bin/env zx

$.verbose = false;

const usage = `qup - Upload file to Qiniu cloud storage

Usage:
  qup <file> [options]
  qup photo.png
  qup photo.png -b mybucket -k custom-key -t

Arguments:
  file          File path to upload

Options:
  -b, --bucket  Bucket name (default: assets)
  -k, --key     Object key (default: filename)
  -t            Prefix key with timestamp`;

if (argv.h || argv.help || argv._.length < 1) {
  console.info(usage);
  process.exit(argv.h || argv.help ? 0 : 1);
}

const filepath = argv._[0];
const bucket = argv.b || argv.bucket || "assets";
let key = argv.k || argv.key || path.basename(filepath);

if (argv.t) {
  const now = new Date();
  const ts = now.toISOString().replace(/[-:]/g, "").replace(/\.\d+Z/, "").replace("T", "T");
  key = `${ts}_${key}`;
}

await $`qshell account`.catch(() => {});
$.verbose = true;
await $`qshell rput ${bucket} ${key} ${filepath}`;
