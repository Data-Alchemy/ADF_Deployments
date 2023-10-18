#!/bin/bash

# Script to collect deployment artifacts for ADF CICD pipeline. This script will grab
# all the files generated in a specific commit add them to a staging folder 

set -e



# Remove existing Artifacts directory
rm -rf Artifacts
rm -f release/Artifacts_Manifest.txt

# Copy JSON files to Artifacts directory
git diff --diff-filter=d --name-only HEAD~1 HEAD~0 -- ../code/ > ../release/Artifacts_Manifest.txt
countOfJsonFiles=$(wc -l < ../release/Artifacts_Manifest.txt)

if [ "$countOfJsonFiles" -eq "0" ]; then
  echo "No deployment artifacts found. Nothing to deploy. Exiting script."
  export DEPLOY_ARTIFACTS=0
  exit 0
fi

echo "Number of Deployment Artifacts = $countOfJsonFiles"
echo "---Moving to Staging Directory---"


while read -r line; do
  echo "staging file for release $line"
  parent_dir="$(dirname "$line")"
  mkdir -p "../release/Artifacts/${parent_dir}"
  cp -r "../$line" "../release/Artifacts/${parent_dir}"
done < "../release/Artifacts_Manifest.txt"
export DEPLOY_ARTIFACTS=1