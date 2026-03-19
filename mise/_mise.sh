#!/bin/sh

set -eu

which mise >/dev/null 2>&1 && mise use --global python@latest
which mise >/dev/null 2>&1 && mise use --global golang@latest
which mise >/dev/null 2>&1 && mise use --global node@latest

echo "Install mise plugins is Done!"
