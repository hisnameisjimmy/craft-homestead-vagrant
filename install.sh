#!/bin/bash

##
##  This install script handles everything that this project needs for the
##  local machine. Homestead handles everything on the Vagrant box
##

## Colours for prettier output + to distinguish this script's output:
color='\033[1;36m';   # Light cyan
NC='\033[0m';     # No color

## Function to prompt for user response:
prompt () {
    while true; do
      echo;
        read -p "$1" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

## output in colour:
echo_color() {
  echo -e "${color}$1${NC}";
}

## Check if vagrant is installed:
if [ ! -f "/opt/vagrant/bin/vagrant" ]; then
  echo_color "Vagrant not found.";
  exit;
fi

if ! prompt "Do you wish to install the craft dev environment? [yn] "; then
  echo_color 'Ok. Install cancelled.';
  exit;
fi

## Create a .env file, if it's not present:
if [ ! -f ".env" ]; then
  cp .env.example .env
fi

## Install composer:
echo_color "
## Installing Composer";
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

## Install homestead:
echo_color "
## Installing Homestead";
php composer.phar require laravel/homestead --dev

## If there isn't a yaml file, make one:
if [ ! -f "Homestead.yaml" ]; then
    ## Generating yaml and vagrantfile:
    echo_color "
    ## Generating yaml file for Homestead";
    php vendor/bin/homestead make
fi

## If Craft isn't present:
if [ ! -d "app/craft" ]; then
  ## Install it!
  bash makeItCraft.sh
fi

## Install node modules:
echo_color "
## npm install";
npm install;

## Set up Craft stuff:
echo_color "
## Setting up Craft...";

## Activate the htaccess (rename 'htaccess' --> '.htaccess'):
if [ -f "app/public/htaccess" ]; then
  echo "## Activating htaccess...";
  mv app/public/htaccess app/public/.htaccess;
fi

## Replace the default templates + config:
CRAFT_SRC="app/src/craft";

if [ -d $CRAFT_SRC ] && prompt "Replace Craft's default templates + config with this project's templates? (only do this on a fresh, new project) [yn] "; then
  echo "Replacing Craft files... (copying from ${CRAFT_SRC})";

  ## Remove existing templates, if present:
  [ -d "app/craft/templates" ] && rm -r app/craft/templates;

  ## Copy everything from app/src/craft to the app/craft directory,
  ## overwriting existing files:
  cp -R $CRAFT_SRC app;
fi

## Run Gulp, to do initial compile of CSS, Javascript, etc:
echo_color "
## gulp";
gulp;

## Create the storage/runtime directory for Craft
## (to prevent a PHP error on first visit to craft-dev.local)
DIR="app/craft/storage/runtime";
if [ ! -f $DIR/.gitignore ]; then
  mkdir -p $DIR/{cache,compiled_templates,logs};
  touch "$DIR/.gitignore";
  touch "$DIR/logs/craft.log";
fi

# Create an assets directory:
if [ ! -d app/public/assets ]; then mkdir -p app/public/assets; fi;

echo_color "
## Finished!
##
## 'vagrant up' to start the server.
## 'gulp watch' to watch Sass + JS for changes.
##
## If this is a new install, make sure to modify your /etc/hosts file with data in the readme
##
## You'll also need to install Craft at http://craft-dev.local/admin/install";
