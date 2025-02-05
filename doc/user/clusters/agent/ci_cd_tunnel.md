---
stage: Configure
group: Configure
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#assignments
---

# CI/CD Tunnel **(PREMIUM)**

> - [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/327409) in GitLab 14.1.
> - The pre-configured `KUBECONFIG` was [introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/324275) in GitLab 14.2.

The CI/CD Tunnel enables users to access Kubernetes clusters from GitLab CI/CD jobs even if there is no network
connectivity between GitLab Runner and a cluster. GitLab Runner does not have to be running in the same cluster.

Only CI/CD jobs set in the configuration project can access one of the configured agents.

## Prerequisites

- A running [`kas` instance](index.md#set-up-the-kubernetes-agent-server).
- A [configuration repository](index.md#define-a-configuration-repository) with an Agent config file
  installed (`.gitlab/agents/<agent-name>/config.yaml`).
- An [Agent record](index.md#create-an-agent-record-in-gitlab).
- The Agent [installed in the cluster](index.md#install-the-agent-into-the-cluster).

## Use the CI/CD Tunnel to run Kubernetes commands from GitLab CI/CD

If your project has access to one or more Agent records available, its CI/CD
jobs provide a `KUBECONFIG` variable compatible with `kubectl`.

Also, each Agent has a separate context (`kubecontext`). By default,
there isn't any context selected.

Contexts are named in the following format: `<agent-configuration-project-path>:<agent-name>`.

You can get the list of available contexts by running `kubectl config get-contexts`.

## Example for a `kubectl` command using the CI/CD Tunnel

The following example shows a CI/CD job that runs a `kubectl` command using the CI/CD Tunnel.
You can run any Kubernetes-specific commands similarly, such as `kubectl`, `helm`,
`kpt`, and so on. To do so:

1. Set your Agent's context in the first command with the format `<agent-configuration-project-path>:<agent-name>`.
1. Run Kubernetes commands.

For example:

```yaml
 deploy:
   image:
     name: bitnami/kubectl:latest
     entrypoint: [""]
   script:
   - kubectl config use-context path/to/agent-configuration-project:your-agent-name
   - kubectl get pods
```
