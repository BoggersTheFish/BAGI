#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REDOX="${ROOT}/redox"
COOK="${REDOX}/cookbook/recipes"
if [[ ! -d "${REDOX}/.git" ]]; then
  echo "Run scripts/clone-redox.sh first."
  exit 1
fi
mkdir -p "${COOK}"
for r in bos-ts-kernel bos-ts-shell bos-ts-orbital; do
  echo "Copying recipe ${r}..."
  rm -rf "${COOK}/${r}"
  cp -a "${ROOT}/recipes/${r}" "${COOK}/"
done

echo "Syncing bos-ts-kernel into bos-ts-orbital recipe (path dep, no rsync)..."
rm -rf "${COOK}/bos-ts-orbital/source/bos-ts-kernel"
mkdir -p "${COOK}/bos-ts-orbital/source/bos-ts-kernel"
cp -R "${ROOT}/crates/bos-ts-kernel/." "${COOK}/bos-ts-orbital/source/bos-ts-kernel/"
echo "Syncing bos-ts-orbital sources..."
rm -rf "${COOK}/bos-ts-orbital/source/src"
mkdir -p "${COOK}/bos-ts-orbital/source/src"
cp -R "${ROOT}/crates/bos-ts-orbital/src/." "${COOK}/bos-ts-orbital/source/src/"

echo "Recipes installed under ${COOK}. Optional: sync bos-ts-kernel recipe with:"
echo "  rm -rf ${COOK}/bos-ts-kernel/source && mkdir -p ${COOK}/bos-ts-kernel/source && cp -R ${ROOT}/crates/bos-ts-kernel/. ${COOK}/bos-ts-kernel/source/"
