# INCEPTION 

![Alt text](img/image1.png)


## Project Overview

![Alt text](img/image4.png)
This project consists in having you set up a small infrastructure composed of different
services under specific rules. The whole project has to be done in a virtual machine. You
have to use `docker compose`. </br>

Each Docker image must have the same name as its corresponding service.
Each service has to run in a dedicated container.
For performance matters, the containers must be built either from the penultimate stable
version of `Alpine or Debian`. The choice is yours.
You also have to write your own <b>Dockerfiles</b>, one per service. The Dockerfiles must
be called in your `docker-compose.yml` by your Makefile.
It means you have to build yourself the Docker images of your project. It is then forbidden to pull ready-made Docker images, as well as using services such as DockerHub
(Alpine/Debian being excluded from this rule). </br>

You then have to set up: </br>
• A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.</br>
• A Docker container that contains WordPress + php-fpm (it must be installed and
configured) only without nginx. </br>
• A Docker container that contains MariaDB only without nginx.</br>
• A volume that contains your WordPress database.</br>
• A second volume that contains your WordPress website files.</br>
• A docker-network that establishes the connection between your containers.</br>

>Your containers have to restart in case of a crash.</br>

• In your WordPress database, there must be two users, one of them being the administrator. The administrator’s username can’t contain admin/Admin or administrator/Administrator (e.g., admin, administrator, Administrator, admin-123, and
so forth).</br>

>To make things simpler, you have to configure your domain name so it points to your
local IP address.</br>
This domain name must be login.42.fr. Again, you have to use your own login.
For example, if your login is wil, wil.42.fr will redirect to the IP address pointing to
wil’s website. </br>

Here is an example diagram of the expected result:
![Alt text](img/image.png)

Below is an example of the expected directory structure:</br>
![Alt text](img/image3.png)

## Getting Started

What is Docker? I will not address the question here, you can read the article I wrote before.</br>
https://medium.com/p/419d5c9edb70
<br>

To briefly talk about the project, you are asked to set up a Wordpress site via Docker. However, you need to use Nginx and MariaDB services.</br>

This article also includes the bonus part of the project, so this page is worth 125 Points.</br>

In the project, you are asked to use Alpine or Debian as the operating system. I will use Debian. You can download.</br>
I will not explain the installation part of the system, you can install it with the settings you want via VirtualBox, it does not require any special settings.</br>

After turning on the system, you first need to open the terminal and enter sudo.</br>

The system update and Make and Docker installation are given below. <code><pre>apt-get update && apt-get install make docker.io docker-compose</pre></code>

## 📂 Creating Necessary Directories
You should go to the directory of your choice and create the srcs/requirements directories and subdirectories.
<code><pre>mkdir -p srcs/requirements{wordpress,mariadb,nginx}/{tools,conf}</pre></code>

The directory should be like this:</br>
![Alt text](img/image2.png)

## 📝 Environment - Environment Variable
Let's create a hidden file named env in the srcs directory.
<code><pre>touch .env</pre></code>

.env file is used to define environment variables that can be injected into Docker containers defined within a docker-compose.yml file. This allows for a centralized and easily manageable way to set configuration values for Dockerized applications.</br>

Arrange and write the following commands into the file according to your needs.</br>

IMPORTANT NOTE: Do not include this file when uploading your project to repo 42. Otherwise you get <b>-42</b>.</br>
<pre>
    <code>
        DOMAIN_NAME=enes.42.fr
        MYSQL_HOSTNAME=mariadb
        MYSQL_DATABASE=wordpress
        MYSQL_USER=mghalmi
        MYSQL_PASSWORD=1234
        MYSQL_ROOT_PASSWORD=root1234
    </code>
</pre>

## 📌 Mandatory Part
### WordPress
![Alt text](img/image5.png)
>WordPress is a popular open-source content management system (CMS) used for creating and managing websites and blogs. It provides a user-friendly interface for building and editing web pages, making it accessible to users with varying levels of technical expertise. WordPress offers a wide range of themes and plugins that extend its functionality, allowing users to customize their websites to suit their needs.</br>

First, let's set up the Dockerfile in this file. Let's create a file called Dockerfile in the wordpress/ directory.</br>

<pre>
    <code>
        FROM debian:stable

        RUN apt upadte -y 
        RUN apt upgrade -y
        RUN apt-get update && apt-get -y install \
            wget \
            curl \
            bash \
            php \
            php-cgi \
            php-mysql \
            php-fpm \
            php-pdo \
            php-gd php-cli \
            php-mbstring \
            redis \
            php-redis

        RUN rm -rf /var/lib/apt/lists/* 

        RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \ 
        && chmod +x wp-cli.phar \
        && mv wp-cli.phar /usr/local/bin/wp

        COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

        RUN mkdir /run/php

        COPY ./tools/create_wordpress.sh /usr/local/bin/
        RUN chmod +x /usr/local/bin/create_wordpress.sh
        ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]

        WORKDIR /var/www/html/

        EXPOSE 9000

        CMD ["/usr/sbin/php-fpm7.3", "-F"]

    </code>
</pre>

### 🔑 used commands

- <strong>FROM</strong>: Sets the Docker image to be created based on debian:buster.
- <strong>RUN</strong>: Installs the required packages. (Bash codes are executed)
- <strong>COPY</strong>: Copies file X to target Y within the created container.
- <strong>ENTRYPOINT</strong>: This is the script that will be run when the container is started.
- <strong>WORKDIR</strong>: It is the working directory.
- <strong>EXPOSE</strong>: This container can listen from outside via port 9000.
- <strong>CMD</strong>: This is the command to be run when the container is started.

### ⚙️ explanation

`FROM debian:stable`: Specifies the base image for the Docker container, which is Debian stabel.<br>

`RUN apt update && apt -y install ...`: Runs commands to update the package index and install required packages using apt. This includes packages like wget, curl, bash, and various PHP-related packages needed for running WordPress and its dependencies.</br>

`RUN rm -rf /var/lib/apt/lists/*`: clean up the package lists stored in the /var/lib/apt/lists/ directory. This directory contains cached package lists retrieved by apt during the update process. his helps speed up subsequent package installations.</br>

`RUN curl -O ...`: Downloads the WP-CLI (WordPress Command Line Interface) tool and makes it executable. WP-CLI is used for managing WordPress installations from the command line.</br>

`COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/`: Copies a custom PHP-FPM (FastCGI Process Manager) configuration file (www.conf) to the appropriate directory in the container. This file likely contains settings related to PHP-FPM pool configurations.</br>

`RUN mkdir /run/php`: Creates a directory for PHP-FPM to store its socket files.</br>

`COPY ./tools/create_wordpress.sh /usr/local/bin/`: Copies a shell script (create_wordpress.sh) to /usr/local/bin/ inside the container. This script is used for initializing a WordPress installation.</br>

`RUN chmod +x /usr/local/bin/create_wordpress.sh`: Changes the permissions of the shell script to make it executable.</br>

`ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]`: Sets the entry point for the container to the create_wordpress.sh script. This means that when the container starts, it will execute this script.</br>

`WORKDIR /var/www/html/`: Sets the working directory inside the container to /var/www/html/, where the WordPress files will be placed. this equivalent to <b>cd</b></br>

`EXPOSE 9000`: Exposes port 9000, which is typically used by PHP-FPM.</br>

`CMD ["/usr/sbin/php-fpm7.3", "-F"]`: Specifies the default command to run when the container starts. In this case, it starts PHP-FPM with the -F flag to run it in the foreground.

<hr>

![Alt text](img/image6.png)

Let's go to the <b>/wordpress/conf/</b> directory, create a file named <b>www.conf</b> and write the following commands.

<pre>
    <code>
        [www]
        user = www-data
        group = www-data
        listen = wordpress:9000
        pm = dynamic
        pm.start_servers = 6
        pm.max_children = 25
        pm.min_spare_servers = 2
        pm.max_spare_servers = 10
    </code>
</pre>

### ⚙️ explanation
This is a PHP-FPM (FastCGI Process Manager) configuration file. It contains operating and performance settings.</br>

`[www]`: This specifies the name of the PHP pool configuration block. In this case, it's named "www". which is typically used for serving web requests.</br>

`user = www-data`: This sets the user under which the PHP-FPM processes will run to www-data. This is a common practice for security reasons, as running PHP processes as a less privileged user can help mitigate potential security risks. www-data It's a non-privileged user account </br>

`group = www-data`: Similar to the user directive, this sets the group under which the PHP-FPM processes will run to www-data.</br>

`listen = wordpress:9000`: This defines the address and port on which PHP-FPM will listen for FastCGI requests. In this case, it's set to wordpress:9000, meaning PHP-FPM will listen on the address wordpress and port 9000.

`pm = dynamic`: This sets the PHP process manager to "dynamic", meaning PHP-FPM will dynamically adjust the number of child processes based on the workload.

`pm.start_servers = 6`: This sets the number of PHP-FPM child processes to start when the PHP-FPM service is initially started or restarted to 6.

`pm.max_children = 25`: This sets the maximum number of child processes that PHP-FPM will allow to exist simultaneously to 25.

`pm.min_spare_servers = 2`: This sets the minimum number of spare PHP-FPM child processes that should be kept idle to handle incoming requests to 2.

`pm.max_spare_servers = 10`: This sets the maximum number of spare PHP-FPM child processes that can be kept idle to handle incoming requests to 10.

<hr>

Now let's go to the <b>tools/</b> directory, create a file named <b>create_wordpress.sh</b> and write the following bash code.<br>
These commands download WordPress and edit the wp-config file.
<pre>
    <code>
        #!/bin/sh

        if [ -f ./wp-config.php ]
        then
            echo "Wordpress already downloaded"
        else
            wget http://wordpress.org/latest.tar.gz
            tar xfz latest.tar.gz
            mv wordpress/* .
            rm -rf latest.tar.gz
            rm -rf wordpress

            sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
            sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
            sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
            sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
            cp wp-config-sample.php wp-config.php
        fi

        exec "$@"
    </code>
</pre>

### ⚙️ explanation

`if [ -f ./wp-config.php ]`: checks if the file wp-config.php exists in the current directory. The -f flag test checks if the file exists.<br>

>if the file exists it prints a message saying "Wordpress already downloaded".<br>

>if not : <br>

`wget http://wordpress.org/latest.tar.gz` : download the latest version of WordPress from http://wordpress.org/latest.tar.gz<br>
`tar xfz latest.tar.gz`: extracts the downloaded tarball.<br>
`mv wordpress/* .`: moves all files from the wordpress directory (created by extracting the tarball) to the current directory (.). <br>
`rm -rf latest.tar.gz || rm -rf wordpress`: remove the tar file and the extracted tarball.<br>

`sed -i s/first/second/g`: This command performs an in-place search and replace operation in a file, replacing all occurrences of "first" with "second" in the wp-config-sample.php file with actual values obtained from environment variables (.env).<br>

`fi`: else block is terminated here with fi, marking the end of the conditional execution.<br>


`exec "$@"`: executes any additional command-line arguments passed to the script. This allows users to run additional commands after the WordPress setup is complete. <br>

<hr>
The wordpress/ directory will be as follows:<br>

![Alt text](img/image7.png)