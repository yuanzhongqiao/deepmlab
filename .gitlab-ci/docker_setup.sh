#!/bin/sh
#
# Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
# Copyright (C) 2022-2024 - Dassault Systèmes S.E. - Clément DAVID
#
# Helper script to build all Linux images
#

usage="Usage: $(basename "$0") --registry CI_REGISTRY_IMAGE --builder DOCKER_LINUX_BUILDER DOCKER_TAG
Build and push all Docker images to a specific DOCKER_TAG

where:
        --help                            show this help text and exit
    -r, --registry CI_REGISTRY_IMAGE      set the GitLab CI_REGISTRY_IMAGE to push images to
    -b, --builder DOCKER_LINUX_BUILDER    build the DOCKER_LINUX_BUILDER image, like CI_REGISTRY_IMAGE/linux-builder
    -p, --prebuild DOCKER_LINUX_PREBUILD  build the DOCKER_LINUX_PREBUILD image, like CI_REGISTRY_IMAGE/linux-prebuild
    -t, --testers                         build the CI_REGISTRY_IMAGE/{fedora, ubuntu, debian} images
        --retag CI_COMMIT_TAG             create a new tag with existing images
        --skip-push                       skip the push of the images, useful for local testing

Example to push images for mr325:
 docker login registry.gitlab.com/scilab/scilab
 .gitlab-ci/$(basename "$0") --registry registry.gitlab.com/scilab/scilab --builder registry.gitlab.com/scilab/scilab/linux-builder mr325
"

set -e

CI_REGISTRY_IMAGE=""
DOCKER_LINUX_BUILDER=""
DOCKER_LINUX_PREBUILD=""
DOCKER_TAG=""
TESTERS=""
CI_COMMIT_TAG=""
SKIP_PUSH=false
while :
do
  case "$1" in
    -h | --help)
      echo "$usage"
      exit 0
      ;;
    -r | --registry)
      if [ $# -ne 0 ]; then
        if test "$2" = -*; then
          >&2 echo "Error: $1 expect a value"
        fi
        CI_REGISTRY_IMAGE="$2"
      fi
      shift 2
      ;;
    -b | --builder)
      if [ $# -ne 0 ]; then
        if test "$2" = -*; then
          >&2 echo "Error: $1 expect a value"
        fi
        DOCKER_LINUX_BUILDER="$2"
      fi
      shift 2
      ;;
    -p | --prebuild)
      if [ $# -ne 0 ]; then
        if test "$2" = -*; then
          >&2 echo "Error: $1 expect a value"
        fi
        DOCKER_LINUX_PREBUILD="$2"
      fi
      shift 2
      ;;
    -t | --testers)
      TESTERS=testers
      shift 1
      ;;
    --retag)
      if [ $# -ne 0 ]; then
        if test "$2" = -*; then
          >&2 echo "Error: $1 expect a value"
        fi
        CI_COMMIT_TAG="$2"
      fi
      shift 2
      ;;
    --skip-push)
      SKIP_PUSH=true
      shift 1
      ;;
    --) # End of all options
      shift
      break
      ;;
    -*)
      >&2 echo "Error: Unknown option: $1"
      exit 1 
      ;;
    *)  # No more options
      DOCKER_TAG="$1"
      break
      ;;
  esac
done

# check mandatory arguments
if test ! -n "${DOCKER_TAG}"; then
  >&2 echo "Error: undefined DOCKER_TAG argument"
  exit 1
fi

# build the linux builder image
if test -n "${DOCKER_LINUX_BUILDER}"; then
  docker build -t "${DOCKER_LINUX_BUILDER}:${DOCKER_TAG}" --build-arg DISTRO=ubuntu:22.04 - <.gitlab-ci/Dockerfile.linux
  "${SKIP_PUSH}" || docker push "${DOCKER_LINUX_BUILDER}:${DOCKER_TAG}"
fi

# build the linux dependencies image
if test -n "${DOCKER_LINUX_PREBUILD}"; then
  docker build -t "${DOCKER_LINUX_PREBUILD}:${DOCKER_TAG}" --build-arg DOCKER_LINUX_BUILDER="$(echo "$DOCKER_LINUX_PREBUILD" | sed s/prebuild/builder/)" --build-arg DOCKER_TAG="${DOCKER_TAG}" - <.gitlab-ci/Dockerfile.linux.prebuild
  "${SKIP_PUSH}" || docker push "${DOCKER_LINUX_PREBUILD}:${DOCKER_TAG}"
fi

# build linux distribution
if test -n "${TESTERS}"; then

  if test ! -n "${CI_REGISTRY_IMAGE}"; then
    >&2 echo "Error: --registry argument is not set"
    exit 1
  fi

  docker build -t "${CI_REGISTRY_IMAGE}/ubuntu-22.04:${DOCKER_TAG}" --build-arg DISTRO=ubuntu:22.04 - <.gitlab-ci/linux-images/Dockerfile.ubuntu
  docker build -t "${CI_REGISTRY_IMAGE}/ubuntu-24.04:${DOCKER_TAG}" --build-arg DISTRO=ubuntu:24.04 - <.gitlab-ci/linux-images/Dockerfile.ubuntu
  docker build -t "${CI_REGISTRY_IMAGE}/ubuntu-25.04:${DOCKER_TAG}" --build-arg DISTRO=ubuntu:25.04 - <.gitlab-ci/linux-images/Dockerfile.ubuntu
  docker build -t "${CI_REGISTRY_IMAGE}/fedora-42:${DOCKER_TAG}" --build-arg DISTRO=fedora:42 - <.gitlab-ci/linux-images/Dockerfile.fedora
  docker build -t "${CI_REGISTRY_IMAGE}/debian-13:${DOCKER_TAG}" --build-arg DISTRO=debian:13 - <.gitlab-ci/linux-images/Dockerfile.ubuntu
  
  if test "${SKIP_PUSH}" = true; then
    echo "Skipping push of images"
  else
    echo "Pushing images"
    docker push "${CI_REGISTRY_IMAGE}/ubuntu-22.04:${DOCKER_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/ubuntu-24.04:${DOCKER_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/ubuntu-25.04:${DOCKER_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/fedora-42:${DOCKER_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/debian-13:${DOCKER_TAG}"
  fi
fi

if test -n "${CI_COMMIT_TAG}"; then
  if test ! -n "${CI_REGISTRY_IMAGE}"; then
    >&2 echo "Error: --registry argument is not set"
    exit 1
  fi

  echo "Pulling images"
  docker pull "${CI_REGISTRY_IMAGE}/linux-builder:${DOCKER_TAG}"
  docker pull "${CI_REGISTRY_IMAGE}/linux-prebuild:${DOCKER_TAG}"
  docker pull "${CI_REGISTRY_IMAGE}/ubuntu-22.04:${DOCKER_TAG}"
  docker pull "${CI_REGISTRY_IMAGE}/ubuntu-24.04:${DOCKER_TAG}"
  docker pull "${CI_REGISTRY_IMAGE}/ubuntu-25.04:${DOCKER_TAG}"
  docker pull "${CI_REGISTRY_IMAGE}/fedora-42:${DOCKER_TAG}"
  docker pull "${CI_REGISTRY_IMAGE}/debian-13:${DOCKER_TAG}"
  
  echo "Create tag from :${DOCKER_TAG} to :${CI_COMMIT_TAG} in registry ${CI_REGISTRY_IMAGE}"
  docker image tag "${CI_REGISTRY_IMAGE}/linux-builder:${DOCKER_TAG}"  "${CI_REGISTRY_IMAGE}/linux-builder:${CI_COMMIT_TAG}"
  docker image tag "${CI_REGISTRY_IMAGE}/linux-prebuild:${DOCKER_TAG}" "${CI_REGISTRY_IMAGE}/linux-prebuild:${CI_COMMIT_TAG}"
  docker image tag "${CI_REGISTRY_IMAGE}/ubuntu-22.04:${DOCKER_TAG}"   "${CI_REGISTRY_IMAGE}/ubuntu-22.04:${CI_COMMIT_TAG}"
  docker image tag "${CI_REGISTRY_IMAGE}/ubuntu-24.04:${DOCKER_TAG}"   "${CI_REGISTRY_IMAGE}/ubuntu-24.04:${CI_COMMIT_TAG}"
  docker image tag "${CI_REGISTRY_IMAGE}/ubuntu-25.04:${DOCKER_TAG}"   "${CI_REGISTRY_IMAGE}/ubuntu-25.04:${CI_COMMIT_TAG}"
  docker image tag "${CI_REGISTRY_IMAGE}/fedora-42:${DOCKER_TAG}"      "${CI_REGISTRY_IMAGE}/fedora-42:${CI_COMMIT_TAG}"
  docker image tag "${CI_REGISTRY_IMAGE}/debian-13:${DOCKER_TAG}"      "${CI_REGISTRY_IMAGE}/debian-13:${CI_COMMIT_TAG}"
  
  if test "${SKIP_PUSH}" = true; then
    echo "Skipping push of images"
  else
    echo "Pushing images"
    docker push "${CI_REGISTRY_IMAGE}/linux-builder:${CI_COMMIT_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/linux-prebuild:${CI_COMMIT_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/ubuntu-22.04:${CI_COMMIT_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/ubuntu-24.04:${CI_COMMIT_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/ubuntu-25.04:${CI_COMMIT_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/fedora-42:${CI_COMMIT_TAG}"
    docker push "${CI_REGISTRY_IMAGE}/debian-13:${CI_COMMIT_TAG}"
  fi
fi

exit 0
