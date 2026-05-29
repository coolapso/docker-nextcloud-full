> [!WARNING]  
> I have **stopped** using Nextcloud; therefore, my interest in maintaining this repository has ended.  
> This repository was created with the intention of providing regular builds from the upstream Dockerfiles. While I had intended to continue maintaining it, constant upstream breaking changes are making this more **difficult**, and something I don't really want to deal with anymore.  
> Proper Dockerfiles should be provided by **the** upstream team, which seems to constantly neglect them.

[![Build and Push](https://github.com/coolapso/docker-nextcloud-full/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/coolapso/docker-nextcloud-full/actions/workflows/build.yaml)

# docker-nextcloud-full

[coolapso/nextcloud-full](https://hub.docker.com/r/coolapso/nextcloud-full)

Just a simple pipeline to build a Nextcloud docker image containing all dependencies (full): https://github.com/nextcloud/docker/tree/master/.examples/dockerfiles/full

There is no intention to make any changes to the container, 
It simply pulls the latest version of the repository, and builds the Dockerfiles provided by the Nextcloud team. 

> [!WARNING]  
> because upstream apache docker file is broken, this build is temporarily using a custom dockerfile to build the image, please refer to the folliwing [issue](https://github.com/nextcloud/docker/issues/2456) for more information.

## Usage 

Images are on docker hub: https://hub.docker.com/r/coolapso/nextcloud-full

`docker pull coolapso/nextcloud-full:<tag>`

## Tags

Follows similar tagging and versioning scheme as the official repository.

examples:

`latest`, `apache`, `28.0.0`
`fpm-alpine`, `28.0.0-fpm-alpine`
`fpm`, `28.0.0-fpm`
