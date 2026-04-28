# Setup a Linux CI on forks

From the reference documentation:

- [Gitlab Runner in a container](https://docs.gitlab.com/runner/install/docker.html)
- [GitLab Runner docker executor](https://docs.gitlab.com/runner/executors/docker.html)

Our Linux CI uses specific docker images to prepare the built environment (`gitlab-runner-helper`),  run a build (`linux-builder`) and execute the tests.
All these images will be used during the pipeline execution.

After having installed `docker` on your machine, you can register your machine and store the configuration on `$HOME/.gitlab-runner` with the command:

```shell
docker run --rm -it \
  -v $HOME/.gitlab-runner:/etc/gitlab-runner:rw \
  gitlab/gitlab-runner:latest register
```

During the registration, you will be asked for pieces of information about your runner. Be sure to enter them from your fork, machine and with tags used by Scilab: `x86_64-linux-gnu, docker, scilab`. The executor should be set to `docker`.

This will generate a `config.toml` file on the configuration directory. To allow This file should be edited by hand to add the following entries in the appropriate `runners.docker` section:

```toml
[[runners]]
  [runners.docker]
    # this is GitLab gitlab-runner-helper, modified to use the scilab user
    helper_image = "registry.gitlab.com/scilab/scilab/gitlab-runner-helper"
    # allow docker-in-docker
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
```

Later and on machine reboot, you have to launch the configured runner as a daemon with the command:

```shell
docker run --rm -d --name gitlab-runner \
  -v $HOME/.gitlab-runner:/etc/gitlab-runner:rw \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest run
```
