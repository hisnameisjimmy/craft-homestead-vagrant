#!/bin/sh

# Craft requires that we have mcrypt installed, and that on 
# MySQL 7.5+ that we change GROUPBY behavior
# Read about craft requirements here: https://craftcms.com/docs/requirements
# Read about GROUPBY behavior here: https://craftcms.stackexchange.com/questions/12084/getting-this-sql-error-group-by-incompatible-with-sql-mode-only-full-group-by/12106

## Colours for prettier output + to distinguish this script's output:
color='\033[1;36m';   # Light cyan
NC='\033[0m';     # No color

## output in colour:
echo_color() {
  echo -e "${color}$1${NC}";
}

if [ ! -f /usr/local/extra_homestead_software_installed ]; then
    echo_color "
    ## Installing mcrypt...";

    # Update packages and install mcrypt
    sudo apt-get update -y
    sudo apt-get install mcrypt php7.0-mcrypt php7.1-mcrypt -y

    echo_color "
    ## Configuring MySQL's my.cnf";
    # Edit my.cnf to make Craft work with MySQL 5.75+
    echo "[mysqld]" | sudo tee --append /etc/mysql/my.cnf
    echo "sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" | sudo tee --append /etc/mysql/my.cnf
    sudo service mysql restart

    # remember that the extra software is installed
    sudo touch /usr/local/extra_homestead_software_installed

    echo_color "
    ##
    ## Finished installing mcrypt and configuring MySQL for Craft!
    ##";
else    
    echo_color "
    ##
    ## mcrypt and my.cnf already configured!
    ##";
fi