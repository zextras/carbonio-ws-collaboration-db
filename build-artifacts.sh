#!/bin/bash

# SPDX-FileCopyrightText: 2023 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only

function build-all-artifacts() {
  build-ubuntu-artifact
  build-rocky-8-artifact

  print-banner "success"
}

function build-ubuntu-artifact() {
  docker run \
    --rm --entrypoint "" \
    -v "$(pwd)":/artifacts \
    docker.io/m0rf30/yap-ubuntu-focal /bin/bash -c 'yap build ubuntu /artifacts'
}

function build-rocky-8-artifact() {
  docker run \
    --rm --entrypoint "" \
    -v "$(pwd)":/artifacts \
    docker.io/m0rf30/yap-rocky-8 /bin/bash -c 'yap build rocky-8 /artifacts'
}

function print-banner() {
  string_to_print=$1
  banner_string=""
  if [ ${#string_to_print} -lt 60 ]; then
    start_spaces=$((60 - ${#string_to_print}))
    start_spaces=$((start_spaces / 2))
    index=0
    while [ $index -lt $start_spaces ]; do
      banner_string="$banner_string "
      index=$((index + 1))
    done
    banner_string="$banner_string$string_to_print"
    index=$((index + ${#string_to_print}))
    while [ $index -lt 60 ]; do
      banner_string="$banner_string "
      index=$((index + 1))
    done
  else
    banner_string="$string_to_print"
  fi
  index=0
  border_string=""
  while [ $index -lt 72 ]; do
    border_string="$border_string*"
    index=$((index + 1))
  done
  echo ""
  echo "$border_string"
  echo "****  $banner_string  ****" | tr '[:lower:]' '[:upper:]'
  echo "$border_string"
}

build-all-artifacts
