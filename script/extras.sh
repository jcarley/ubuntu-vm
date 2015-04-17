#!/usr/bin/env bash

fancy_echo() {
  printf "\n%b\n" "$1"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

fancy_echo "Updating system packages ..."
  if command -v aptitude >/dev/null; then
    fancy_echo "Using aptitude ..."
  else
    fancy_echo "Installing aptitude ..."
    sudo apt-get install -y aptitude
  fi

  sudo aptitude update

fancy_echo "Installing curl, for making web requests ..."
  sudo aptitude install -y curl

fancy_echo "Installing vim, for editing files on the server ..."
  sudo aptitude install -y vim

fancy_echo "Installing git, for source control management ..."
  sudo aptitude install -y git

fancy_echo "Installing Redis, a good key-value database ..."
  sudo aptitude install -y redis-server

fancy_echo "Installing node, to render the rails asset pipeline ..."
  sudo aptitude install -y nodejs

fancy_echo "Installing openjdk 7, to run java based applications ..."
  sudo aptitude install -y openjdk-7-jdk openjdk-7-jre-headless

