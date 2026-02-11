#!/bin/bash -e 
if [[ -d docker ]]; then 
  echo "docker exists, cleaning up..." 
  rm -rf docker
fi

project_root=${PWD}
baseRegistry="coolapso/nextcloud-full"

git clone https://github.com/nextcloud/docker.git 
version=$(curl -s https://api.github.com/repos/nextcloud/server/releases/latest | jq -r '.name')

if [[ -z $SKIP_RELEASE_CHECK ]]; then
  if curl -s -S "https://registry.hub.docker.com/v2/repositories/coolapso/nextcloud-full/tags/" | jq '."results"[]["name"]' | grep -q "${version#v}"; then
    echo "Version already published, nothing to do..."
    exit 0
  fi
fi


function buildApache() {
  apache="${baseRegistry}:apache"
  latest="${baseRegistry}:latest"
  versionOnly="${baseRegistry}:${version#v}"
  apacheVersion="${baseRegistry}:${version#v}-apache"

  # cd docker/.examples/dockerfiles/full/apache || exit 0
  ## Temporarily use this dockerfile, until upstream is fixed
  ## https://github.com/nextcloud/docker/issues/2456
  cd patchedApache || exit 0
  docker build -t "$apache" -t "$latest" -t "$versionOnly" -t "$apacheVersion" .

  for tag in $versionOnly $apache $latest $apacheVersion; do
    docker push "$tag"
  done
}

function buildFpmAlpine() {
  fpmAlpine="${baseRegistry}:fpm-alpine"
  fpmAlpineVersion="${baseRegistry}:${version#v}-fpm-alpine"

  cd $project_root/docker/.examples/dockerfiles/full/fpm-alpine || exit 0
  docker build -t "$fpmAlpine" -t "$fpmAlpineVersion" .

  for tag in $fpmAlpine $fpmAlpineVersion; do
    docker push "$tag"
  done
}

function buildFPM() {
  fpm="${baseRegistry}:fpm"
  fpmVersion="${baseRegistry}:${version#v}-fpm"

  cd $project_root/docker/.examples/dockerfiles/full/fpm || exit 0
  docker build -t "$fpm" -t "$fpmVersion" .

  for tag in $fpm $fpmVersion; do
    docker push "$tag"
  done

}

function main() {
  buildApache
  buildFpmAlpine
  buildFPM
}

main
