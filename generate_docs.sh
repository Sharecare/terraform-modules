#!/bin/bash
set -e

find . -not -path "./.git/*" -mindepth 2 -maxdepth 2 -type d -exec bash -c 'terraform-docs md "{}" > "{}"/README.md;' \;

printf "\n\033[35;1mUpdated the following modules READMEs with terraform-docs\033[0m\n\n"

find . -name "README.md"
