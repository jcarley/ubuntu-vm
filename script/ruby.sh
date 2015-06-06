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

fancy_echo "Installing open-jdk 7 ..."
  sudo aptitude install openjdk-7-jdk openjdk-7-jre-headless -y

fancy_echo "Installing base ruby build dependencies ..."
  sudo aptitude build-dep -y ruby1.9.3

fancy_echo "Installing libraries for common gem dependencies ..."
  sudo aptitude install -y libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libqtwebkit-dev libreadline-dev

if [[ ! -d "$HOME/.rbenv" ]]; then
  fancy_echo "Installing rbenv, to change Ruby versions ..."
    git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

    if ! grep -qs "rbenv init" $HOME/.bashrc; then
      printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> $HOME/.bashrc
      printf 'eval "$(rbenv init - --no-rehash)"\n' >> $HOME/.bashrc
    fi
fi

if [[ ! -d "$HOME/.rbenv/plugins/rbenv-gem-rehash" ]]; then
  fancy_echo "Installing rbenv-gem-rehash so the shell automatically picks up binaries after installing gems with binaries..."
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git \
      $HOME/.rbenv/plugins/rbenv-gem-rehash
fi

if [[ ! -d "$HOME/.rbenv/plugins/rbenv-vars" ]]; then
  fancy_echo "Installing rbenv-vars so the shell has access to environment variables..."
    git clone https://github.com/sstephenson/rbenv-vars.git \
      $HOME/.rbenv/plugins/rbenv-vars
fi

if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]; then
  fancy_echo "Installing ruby-build, to install Rubies ..."
    git clone https://github.com/sstephenson/ruby-build.git \
      $HOME/.rbenv/plugins/ruby-build
fi

ruby_version="2.2.1"

if [[ ! $(echo $PATH | grep "$HOME/.rbenv/bin") ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

fancy_echo "Installing Ruby $ruby_version ..."
  rbenv install -s "$ruby_version"

fancy_echo "Setting $ruby_version as global default Ruby ..."
  rbenv global "$ruby_version"
  rbenv rehash

fancy_echo "Creating gemrc file ..."
  cat <<GEMRC > $HOME/.gemrc
:verbose: true
:update_sources: true
:backtrace: false
:bulk_threshold: 1000
:benchmark: false
gem: --no-ri --no-rdoc
GEMRC

fancy_echo "Updating to latest Rubygems version ..."
  gem update --system

fancy_echo "Installing Bundler to install project-specific Ruby gems ..."
  gem install bundler

