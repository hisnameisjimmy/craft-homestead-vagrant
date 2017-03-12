# Homestead Craft

This is a very convenient installer for getting started with local development in craft using Homestead/Vagrant/Composer to setup the environment.

This project is heavily indebted to [Crafty Vagrant](https://github.com/niceandserious/crafty-vagrant). The main difference is I switched everything out to use Homestead, so that the latest technology is available to the end user. It also makes maintaining the project a breeze, since Homestead does all the heavy lifting in terms of updating the environment.

## Pre-requisites
* [Node LTS](https://nodejs.org/en/)
* [Gulp](http://gulpjs.com/)
* [Vagrant](http://www.vagrantup.com/)
* [Virtual Box](https://www.virtualbox.org/)
* rsync (optional, for asset-syncing)

## Installation

1. Clone the repo to your ~/Sites folder

        $ cd ~/Sites
        $ git clone git@github.com:hisnameisjimmy/craft-homestead-vagrant.git

2. Run the command `bash install.sh` from inside the newly created folder - this will install and set up everything necessary (including Craft) in your project directory. If this is a fresh Craft install, answer 'y' to the prompt about replacing Craft's templates + config, otherwise - if this is an existing project - answer 'n'. Generally, if you use this project internally, you'll install the templates initially (they're useful), and then once you start committing to the project, you'll probably want to remove these install commands for other developers who end up working on it.

3. If this is the first time you're setting this up, open your `hosts` file and add the following. If you want a different local domain for your project, read below to altering names.

        192.168.10.10    craft-dev.local

  (the hosts file is usually found at `/etc/hosts` on OSX/Linux; `%SystemRoot%\System32\drivers\etc\hosts` on Windows)

  Once done, clear your local dns cache:

        $  sudo killall -HUP mDNSResponder && dscacheutil -flushcache && sudo apachectl restart

4. Launch vagrant: `vagrant up`
   ...and hopefully (after a short wait while your Vagrant machine is set up) your vagrant installation should be all set.

   The webserver should now be accessible from `http://craft-dev.local/`. If Craft backups are present in `/app/craft/storage/backups`, the most recent one will automatically have been used to populate the database. Otherwise, you can install Craft by going to [http://craft-dev.local/admin/install](http://craft-dev.local/admin/install)

## Altering the Domain associated

By default, everything gets installed to a folder called craft-dev inside your ~/Sites folder, and the domain is http://craft-dev.local. This is just to make things simple for my install script. You can run the files from your Desktop folder, or wherever, just make sure to change the yaml file.

If you want to change it after you've already set things up on your machine, you'll want to run a `vagrant reload` from the project folder after altering the yaml.

Things to change:

* Homestead.yaml
* .env.example (or .env if you've already installed)
* /etc/hosts file on your local machine
* package.json
& /app/craft/app/config/general.php (change .local to whatever extension you'd like)

## Usage

* `gulp watch` when you're ready to start developing: this will watch for changes to Sass, Javascript, or images, and perform appropriate tasks (compiling Sass, bundling javascript, etc)

* While `gulp watch` is running, any browser tabs with your dev site open in will update live (via the magic of [Browsersync](https://www.browsersync.io/)) as you edit styles, templates, etc. If you don't want live updating, `gulp watch:tasks` will perform the same tasks (compiling Sass, etc) without the autorefresh.

* `gulp watch` also generates a custom [Modernizr](https://modernizr.com/) build (at `public/scripts/modernizr.js`) which only tests for features you're actually using in your styles and scripts (and which should therefore be a lot smaller and more performant than loading the whole Modernizr library). Note that this is not updated on every change of CSS or Javascript because that would slow things down too much, so if you add a new feature you'd like to detect you'll either need to stop and restart `gulp watch` or, alternatively, run `gulp modernizr` to update the build.

* This project has a database-provisioning shell script. If you run `gulp db:restore`, the most recent backup in `app\craft\storage\backups` will be restored. (Of course, you'll lose any current state of the database, so only do this when you're happy for that to happen)

* This project uses [Browserify](http://browserify.org/) to keep Javascript modular. If you haven't used Browserify before, there's an example module in the /scripts directory.

## Troubleshooting

* If this is a fresh install of Craft, you may see error pages until you've installed it by visiting  [http://craft-dev.local/admin/install](http://craft-dev.local/admin/install)

* This project will not install properly if the `unzip` command is not available from the command line. On Linux / OSX this is not usually a problem, but for Windows you might need to get an unzip executable file [here](http://stahlworks.com/dev/index.php?tool=zipunzip) and put it somewhere accessible from your PATH.

## Development

If you want to work on this project itself (ie. on the default config / starting templates), three steps are required:

1. Run the install step with a `--dev` flag: eg. `bash install.sh --dev`. This leaves copies of the default template / config files in the `/src` folder (without the `--dev` flag they are deleted from this directory as part of the install process, to avoid the potential confusion of having an unused templates directory kicking around)

2. Add the line `define('CRAFT_TEMPLATES_PATH', "../src/craft/templates");` to the top of Craft's `app/public/index.php` file. This lets you work directly on the source templates alongside a working installation of Craft.

3. gitignore everything inside the `app` directory apart from `app/src` to prevent it being checked into the project itself. ie. add the following lines to `.gitignore`:

        app/*
        !app/src*

## Environment

* [Laravel Homestead](https://laravel.com/docs/5.4/homestead)
* [jQuery](http://jquery.com/)
* [Modernizr](http://modernizr.com/)

## Thanks!

This project's install script uses a modified version of [makeItCraft](https://github.com/mattstauffer/makeItCraft) by [Matt Stauffer](https://mattstauffer.co/). This modified version was created by [Nice and Serious](http://niceandserious.com/).

This project is also based on work by:
* [PerishableDave/puppet-lamp-stack](https://github.com/PerishableDave/puppet-lamp-stack).
* [jas0nkim/my-vagrant-puppet-lamp](https://github.com/jas0nkim/my-vagrant-puppet-lamp).
* [jrodriguezjr/puppet-lamp-stack](https://github.com/jrodriguezjr/puppet-lamp-stack).

Ultimately, I stand on the shoulders of giants. Nice and Serious did a wonderful job with [Crafty Vagrant](https://github.com/niceandserious/crafty-vagrant), and it does so, so much. I am just trying to spread the love with a version of it that uses Homestead, reducing the overhead of maintaining the project and allowing people to use the latest technology faster.

## License

Copyright © 2017 [Jimmy Hooker](http://mrhooker.com). This project is free software, and may be redistributed under the terms specified in the license.
