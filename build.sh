#!/bin/bash -e 
if [[ -d docker ]]; then 
  echo "docker exists, cleaning up..." 
  rm -rf docker
fi

project_root=${PWD}
baseRegistry="coolapso/nextcloud-full"

git clone https://github.com/nextcloud/docker.git 
version=$(curl -s https://api.github.com/repos/nextcloud/server/releases/latest | jq -r '.name')

version_check() {
  build_type=$1
  if [[ -z $SKIP_RELEASE_CHECK ]]; then
    if curl -s -S "https://registry.hub.docker.com/v2/repositories/coolapso/nextcloud-full/tags/" | jq '."results"[]["name"]' | grep -q "${version#v}-${build_type}"; then
      echo "Version ${version#v}-${build_type} already published, nothing to do..."
      return 1
    fi
  fi
}


function buildApache() {
  build_type="apache"
  version_check "apache" || return 0
  apache="${baseRegistry}:${build_type}"
  latest="${baseRegistry}:latest"
  versionOnly="${baseRegistry}:${version#v}"
  apacheVersion="${baseRegistry}:${version#v}-${build_type}"

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
  build_type="fpm-alpine" 
  version_check $build_type || return 0
  fpmAlpine="${baseRegistry}:${build_type}"
  fpmAlpineVersion="${baseRegistry}:${version#v}-${build_type}"

  cd $project_root/docker/.examples/dockerfiles/full/fpm-alpine || exit 0
  docker build -t "$fpmAlpine" -t "$fpmAlpineVersion" .

  for tag in $fpmAlpine $fpmAlpineVersion; do
    docker push "$tag"
  done
}

function buildFPM() {
  build_type="fpm"
  version_check $build_type || return 0
  fpm="${baseRegistry}:${build_type}"
  fpmVersion="${baseRegistry}:${version#v}-${build_type}"

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
