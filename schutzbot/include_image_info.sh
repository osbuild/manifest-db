#!/bin/bash
sudo dnf install gh -y

echo "${SCHUTZBOT_LOGIN}" > /tmp/secret.txt
gh auth login --with-token < /tmp/secret.txt

./tools/ci_import --pipeline-id "$CI_PIPELINE_ID" --token  ${GITLAB_TOKEN} --verbose

git checkout $CI_COMMIT_BRANCH

git config --local user.name "SchutzBot"
git config --local user.email "schutzbot@redhat.com"

# only change the last commit and push to github if things were changed
git diff-index --quiet HEAD -- || git add -A && \
    git commit --ammend -m "db: update

Automatic update:
- manifests from latest composer
- image-info from pipeline $CI_PIPELINE_ID" && \
    git push --set-upstream origin $CI_COMMIT_BRANCH && \
    gh pr create --title "db update" --body "automated db update" -r lavocatt
