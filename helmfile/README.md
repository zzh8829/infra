# Helmfile

This folder contains system level helmfiles

## Deps

brew install helmfile
helm init --client-only --upgrade
helm plugin install https://github.com/databus23/helm-diff
helm plugin install https://github.com/rimusz/helm-tiller

## Install

helmfile apply

