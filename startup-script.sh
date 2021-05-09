#...................................................................................................#
#                                                                                                   #
#  @License Starts                                                                                  #
#                                                                                                   #
#  Copyright © 2015 - present. MongoExpUser.  All Rights Reserved.                                  #
#                                                                                                   #
#  License: MIT - https://github.com/MongoExpUser/UNEPO-Stack-on-AWS-Lightsail/blob/main/README.md  #
#                                                                                                   #
#  @License Ends                                                                                    #
#                                                                                                   #
#...................................................................................................#
#  startup-script.sh (lauch/start-up script) - performs the following actions:                      #
#  1) Installs additional Ubuntu packages                                                           #
#  2) Installs and configures Node.js v16.x and Express v5.0.0-alpha.8 web server framework         #
#     Installs other node.js packages and set firewall rules for web server                         #
#  3) Installs postgresql server and set firewall rules for postgresql server                       #
#...................................................................................................#


#!/bin/bash

# define all common variable(s)
base_dir="base"
server_dir="server"
client_dir="client"
enable_web_server=true
enable_postgresql_server=true

create_dir_and_install_missing_packages () {
  # create relevant directories
  cd /home/
  sudo mkdir $base_dir
  cd $base_dir
  sudo mkdir $server_dir
  sudo mkdir $client_dir
      
  # update system
  sudo apt-get update
  echo -e "Y"
  sudo apt-get upgrade
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get dist-upgrade
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
      
  #install additional missing packages
  sudo apt-get install sshpass
  sudo apt install cmdtest
  echo -e "Y"
  sudo apt-get install spamassassin
  echo -e "Y"
  sudo apt-get install snap
  sudo apt-get install nmap
  echo -e "Y"
  sudo apt-get install net-tools
  sudo apt-get install aptitude
  echo -e "Y"
  sudo apt-get install build-essential
  echo -e "Y"
  sudo apt-get install gcc
  
  
  #install certbot for letsencrypt' ssl certificate renewal
  sudo apt install certbot python3-certbot-apache
  echo -e "Y"
  echo -e "Y"
  
  # clean
  sudo apt autoclean
  echo -e "Y"
  echo -e "Y"
  sudo apt autoremove
  echo -e "Y"
  echo -e "Y"
}

install_and_configure_nodejs_web_server () {
  cd /home/
  cd $base_dir
  
  if [ $enable_web_server = true ]
  then
    # install node.js
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    echo -e "\n"
    sudo apt-get install -y nodejs
    echo -e "\n"
        
    # create node.js' package.json file
    sudo echo ' {
      "name": "Nodejs-Expressjs",
      "version": "1.0",
      "description": "A web server, based on the Node.js-Express.js (NE) stack",
      "license": "MIT",
      "main": "./app.js",
      "email": "info@domain.com",
      "author": "Copyright © 2015 - present. MongoExpUser.  All Rights Reserved.",
      "dependencies"    :
      {
        "express"       : "*"
      },
      "devDependencies": {},
      "keywords": [
        "Node.js",
        "Express.js",
        "PostgreSQL\""
      ]
    }' > package.json
        
    # install express.js (the web server framework) and other node.js packages
    sudo npm i express@5.0.0-alpha.8
    sudo npm i -g npm
    sudo npm i bcryptjs
    sudo npm i bcrypt-nodejs
    sudo npm i bindings
    sudo npm i bluebird
    sudo npm i body-parser
    sudo npm i command-exists
    sudo npm i compression
    sudo npm i connect-flash
    sudo npm i cookie-parser
    sudo npm i express-session
    sudo npm i formidable
    sudo npm i html-minifier
    sudo npm i level
    sudo npm i memored
    sudo npm i mime
    sudo npm i mkdirp
    sudo npm i postgres
    sudo npm i ocsp
    sudo npm i postgres
    sudo npm i python-shell
    sudo npm i serve-favicon
    sudo npm i serve-index
    sudo npm i uglify-js2
    sudo npm i uglify-js@2.2.0
    sudo npm i uglifycss
    sudo npm i uuid
    sudo npm i vhost
    
    #enable firewall
    sudo ufw enable
    echo -e "Y"
    
    # set firewall rules for ssh (port 22) and web-server (80 & 443)
    echo -e "Y"
    sudo ufw allow 22
    sudo ufw allow 80
    sudo ufw allow 443
              
    # clean
    sudo apt autoclean
    sudo apt autoremove
  fi
}

install_postgresql_server () {
  if [ $enable_postgresql_server = true ]
  then
    # install postgresql latest version
    sudo apt-get update
    echo -e "Y"
    # for specific version, include the version number e.g 'postgresql-9', postgresql-10', postgresql-11', etc.
    sudo apt-get install -y postgresql
    echo -e "Y"
    echo -e "Y"
    
    # set firewall rules for postgresql server
    echo -e "Y"
    sudo ufw allow 5432
    
    # clean
    sudo apt autoclean
    sudo apt autoremove
    
    
    # by default, postgresql auto starts after installation
    
    # To START or Re-START or STOP PostgreSQL or Check Status of PostgreSQL, use these commands:
    # sudo systemctl start postgresql
    # sudo systemctl restart postgresql
    # sudo systemctl stop postgresql
    # sudo systemctl status postgresql
    
    # To list current active postgresql units, use this command
    # sudo systemctl list-units | grep postgresql
    
    # FOR PRODUCTION deployment, ensures:
    # a) role(s)/user(s) with relevant level of permissions are created
    #    see: https://www.postgresql.org/docs/current/user-manag.html
    # b) other security settings are enabled in the configuration file (/etc/postgresql/version/main/postgresql.conf) - version could be 9.6, 12.6, etc.
    
  fi
}


main () {
  # execute all functions sequentially
  create_dir_and_install_missing_packages
  install_and_configure_nodejs_web_server
  install_postgresql_server
}

# invoke main
main