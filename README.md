# docker-4-drupal-custom

This is a custom "ready-to-use" docker stack based on `docker4Drupal`. If you are looking for more information over the original `docker4drupal`, please refer to the section [Docker-based Drupal stack](#docker-based-drupal-stack)

For a quick set-up guide please check the steps below.

## Assumptions

This `docker-4-drupal-custom` config assumes a couple of things:

1. We removed the `docker-compose.override.yml` file because this should be a copy/paste docker stack;
2. When using Xdebug, the `IDE_KEY` is fixed to `phpstorm`, feel free to change it;
3. MacOS as machine OS;
4. There are a lot of more options for this docker stack, but for the purpose of this custom set up we removed them;
5. We are not using mutagen due to permission issues;
6. The following tools are enabled by default:
   1. phpMyAdmin;
   2. Mailhog;

## Installation example

Run the following command to install Drupal Social, and replace `SOCIAL-DIRECTORY` with the directory of your choice.

```
composer create-project goalgorilla/social_template:dev-master SOCIAL-DIRECTORY --no-interaction
```

Copy the entire content of `docker-4-drupal-custom` folder to a `DOCKER-DIRECTORY` of your choice inside the newly cloned Drupal Social directory.

The folder structure should be like this:

```
[SOCIAL-DIRECTORY]
  - [CLONED DRUPAL SOCIAL FOLDERS AND FILES]
  - [DOCKER-DIRECTORY]
     - Makefile ( to execute the docker commands )
     - Other files from this current docker-4-drupal-custom repo
  - [HTML - DRUPAL ACTUAL FILES] 
```

Once you copy the `docker-4-drupal-custom` files to the `DOCKER-DIRECTORY` edit the `.env` file and change the following to your choice:
```
COMPOSE_PROJECT_NAME=[COMPOSE_PROJECT_NAME]
PROJECT_NAME=[PROJECT_NAME]
PROJECT_BASE_URL=[PROJECT_BASE_URL].docker.localhost
PROJECT_PORT=[PROJECT_PORT]
```

For each project, you can set a different value at `.env` this way you can spin up multiple projects at once.

Go to `DOCKER-DIRECTORY` and execute the following:
```
make up
```

After the containers start, it's time to switch to the docker php container shell and install Drupal Social
```
make shell
drush -y site:install social --db-url=mysql://drupal:drupal@mysql:3306/drupal
```

Once the installation finishes, the website is available through the same url that was configured at `.env` file:
```
# Website
http://[PROJECT_BASE_URL].docker.localhost:[PROJEC_PORT]

# phpMyAdmin
http://pma.[PROJECT_BASE_URL].docker.localhost:[PROJEC_PORT]

# Mailhog
http://mailhog.[PROJECT_BASE_URL].docker.localhost:[PROJEC_PORT]
```

## Optional installation command
```
drush -y si social --db-url=mysql://drupal:drupal@mysql/drupal --account-pass=admin social_module_configure_form.select_all='TRUE' install_configure_form.update_status_module='array(FALSE,FALSE)' --site-name='Open Social'; drush cset swiftmailer.transport transport 'smtp' -y; drush cset swiftmailer.transport smtp_host 'localhost' -y; drush cset swiftmailer.transport smtp_port 1025 -y; drush en social_demo -y; drush cc drush; drush sda file user group topic event event_enrollment post comment like; drush pmu social_demo -y; drush cc drush; drush image-flush --all; drush cron; drush sapi-rt; drush ev 'node_access_rebuild()'; drush en -y config_update config_update_ui devel devel_generate dblog views_ui field_ui contextual
```

## Xdebug and PHP Storm

Xdebug should work out of the box from the server, there is only one configuration needed:

1. Preference > Settings > PHP > Servers;
2. Add a new server with name `phpstorm`;
3. Host should be `http://[PROJECT_BASE_URL].docker.localhost`;
4. Port `[PROJECT_PORT]`;
5. Check `Use path mappings`;
6. The root folder of your `SOCIAL-DIRECTORY` should map to `/var/www/html`;
7. Save > Good to go!


## Custom directories

This configuration has two custom directories:

* database-data
  * Storing of permanent database files;
* database-init
  * Holds a `[filename].sql.gz` or a `[filename].sql` that will be imported once the docker spins up, only if there is not a `mysql` folder inside `database-data`;

## Useful links

* Woodby PHP: https://github.com/wodby/php
  * Environment variables: https://github.com/wodby/php#environment-variables

## Makefile commands

| Command                  | Description            |
| ------------------------ | ---------------------- |
| make up                  | Start up containers. |
| make stop                | Stop containers. |
| make start               | Start containers without updating. |
| make prune               | Remove containers and their volumes. |
| make ps                  | List running containers.  |
| make shell               | Access `php` container via shell. |
| make composer            | Executes `composer` command in a specified `COMPOSER_ROOT` directory (default is `/var/www/html`) |
| make drush               | Executes `drush` command in a specified `DRUPAL_ROOT` directory (default is `/var/www/html/html`) |
| make logs [service-name] | View containers logs or view specific service log. |

# Docker-based Drupal stack

## Introduction

Docker4Drupal is a set of docker images optimized for Drupal. Use `docker-compose.yml` file from the [latest stable release](https://github.com/wodby/docker4drupal/releases) to spin up local environment on Linux, Mac OS X and Windows. 

* Read the docs on [**how to use**](https://wodby.com/docs/stacks/drupal/local#usage)
* Ask questions on [Slack](http://slack.wodby.com/)
* Follow [@wodbycloud](https://twitter.com/wodbycloud) for future announcements

## Stack

The Drupal stack consist of the following containers:

| Container       | Versions               | Image                              | ARM64 support | Enabled by default |
| --------------- | ---------------------- | ---------------------------------- | ------------- | ------------------ |
| [Nginx]         | 1.21, 1.20, 1.19       | [wodby/nginx]                      | ✓             | ✓                  |
| [Apache]        | 2.4                    | [wodby/apache]                     | ✓             |                    |
| [Drupal]        | 9, 8, 7                | [wodby/drupal]                     | ✓             | ✓                  |
| [PHP]           | 8.0, 7.4, 7.3          | [wodby/drupal-php]                 | ✓             |                    |
| Crond           |                        | [wodby/drupal-php]                 | ✓             | ✓                  |
| [MariaDB]       | 10.5, 10.4, 10.3, 10.2 | [wodby/mariadb]                    | ✓             | ✓                  |
| [PostgreSQL]    | 13, 12, 11, 10, 9.6    | [wodby/postgres]                   | ✓             |                    |
| [Redis]         | 6, 5                   | [wodby/redis]                      | ✓             |                    |
| [Memcached]     | 1                      | [wodby/memcached]                  |               |                    |
| [Varnish]       | 6.0, 4.1               | [wodby/varnish]                    |               |                    |
| [Node.js]       | 16, 14, 12             | [wodby/node]                       |               |                    |
| [Drupal node]   | 1.0                    | [wodby/drupal-node]                |               |                    |
| [Solr]          | 8, 7, 6, 5             | [wodby/solr]                       |               |                    |
| [Elasticsearch] | 7, 6                   | [wodby/elasticsearch]              |               |                    |
| [Kibana]        | 7, 6                   | [wodby/kibana]                     |               |                    |
| [OpenSMTPD]     | 6.0                    | [wodby/opensmtpd]                  |               |                    |
| [Mailhog]       | latest                 | [mailhog/mailhog]                  |               | ✓                  |
| [AthenaPDF]     | 2.16.0                 | [arachnysdocker/athenapdf-service] |               |                    |
| [Rsyslog]       | latest                 | [wodby/rsyslog]                    |               |                    |
| [Blackfire]     | latest                 | [blackfire/blackfire]              |               |                    |
| [Webgrind]      | 1                      | [wodby/webgrind]                   |               |                    |
| [Xhprof viewer] | latest                 | [wodby/xhprof]                     |               |                    |
| Adminer         | 4.6                    | [wodby/adminer]                    |               |                    |
| phpMyAdmin      | latest                 | [phpmyadmin/phpmyadmin]            |               |                    |
| Selenium chrome | 3.141                  | [selenium/standalone-chrome]       |               |                    |
| Traefik         | latest                 | [_/traefik]                        | ✓             | ✓                  |
 
Supported Drupal versions: 9 / 8 / 7

## Documentation

Full documentation is available at https://wodby.com/docs/stacks/drupal/local.

## Image's tags

Images tags format is `[VERSION]-[STABILITY_TAG]` where:

`[VERSION]` is the _version of an application_ (without patch version) running in a container, e.g. `wodby/nginx:1.15-x.x.x` where Nginx version is `1.15` and `x.x.x` is a stability tag. For some images we include both major and minor version like PHP `7.2`, for others we include only major like Redis `5`. 

`[STABILITY_TAG]` is the _version of an image_ that corresponds to a git tag of the image repository, e.g. `wodby/mariadb:10.2-3.3.8` has MariaDB `10.2` and stability tag [`3.3.8`](https://github.com/wodby/mariadb/releases/tag/3.3.8). New stability tags include patch updates for applications and image's fixes/improvements (new env vars, orchestration actions fixes, etc). Stability tag changes described in the corresponding a git tag description. Stability tags follow [semantic versioning](https://semver.org/).

We highly encourage to use images only with stability tags.

## Maintenance

We regularly update images used in this stack and release them together, see [releases page](https://github.com/wodby/docker4drupal/releases) for full changelog and update instructions. Most of routine updates for images and this project performed by [the bot](https://github.com/wodbot) via scripts located at [wodby/images](https://github.com/wodby/images).

## Beyond local environment

Docker4Drupal is a project designed to help you spin up local environment with docker-compose. If you want to deploy a consistent stack with orchestrations to your own server, check out [Drupal stack](https://wodby.com/stacks/drupal) on Wodby ![](https://www.google.com/s2/favicons?domain=wodby.com).

## Other Docker4x projects

* [docker4php](https://github.com/wodby/docker4php)
* [docker4wordpress](https://github.com/wodby/docker4wordpress)
* [docker4ruby](https://github.com/wodby/docker4ruby)
* [docker4python](https://github.com/wodby/docker4python)

## License

This project is licensed under the MIT open source license.

[Apache]: https://wodby.com/docs/stacks/drupal/containers#apache
[AthenaPDF]: https://wodby.com/docs/stacks/drupal/containers#athenapdf
[Blackfire]: https://wodby.com/docs/stacks/drupal/containers#blackfire
[Drupal node]: https://wodby.com/docs/stacks/drupal/containers#drupal-nodejs
[Drupal]: https://wodby.com/docs/stacks/drupal/containers#php
[Elasticsearch]: https://wodby.com/docs/stacks/elasticsearch
[Kibana]: https://wodby.com/docs/stacks/elasticsearch
[Mailhog]: https://wodby.com/docs/stacks/drupal/containers#mailhog
[MariaDB]: https://wodby.com/docs/stacks/drupal/containers#mariadb
[Memcached]: https://wodby.com/docs/stacks/drupal/containers#memcached
[Nginx]: https://wodby.com/docs/stacks/drupal/containers#nginx
[Node.js]: https://wodby.com/docs/stacks/drupal/containers#nodejs
[OpenSMTPD]: https://wodby.com/docs/stacks/drupal/containers#opensmtpd
[PHP]: https://wodby.com/docs/stacks/drupal/containers#php
[PostgreSQL]: https://wodby.com/docs/stacks/drupal/containers#postgresql
[Redis]: https://wodby.com/docs/stacks/drupal/containers#redis
[Rsyslog]: https://wodby.com/docs/stacks/drupal/containers#rsyslog
[Solr]: https://wodby.com/docs/stacks/drupal/containers#solr
[Varnish]: https://wodby.com/docs/stacks/drupal/containers#varnish
[Webgrind]: https://wodby.com/docs/stacks/drupal/containers#webgrind
[XHProf viewer]: https://wodby.com/docs/stacks/php/containers#xhprof-viewer

[_/traefik]: https://hub.docker.com/_/traefik
[arachnysdocker/athenapdf-service]: https://hub.docker.com/r/arachnysdocker/athenapdf-service
[blackfire/blackfire]: https://hub.docker.com/r/blackfire/blackfire
[mailhog/mailhog]: https://hub.docker.com/r/mailhog/mailhog
[phpmyadmin/phpmyadmin]: https://hub.docker.com/r/phpmyadmin/phpmyadmin
[selenium/standalone-chrome]: https://hub.docker.com/r/selenium/standalone-chrome
[wodby/adminer]: https://hub.docker.com/r/wodby/adminer
[wodby/apache]: https://github.com/wodby/apache
[wodby/drupal-node]: https://github.com/wodby/drupal-node
[wodby/drupal-php]: https://github.com/wodby/drupal-php
[wodby/drupal]: https://github.com/wodby/drupal
[wodby/elasticsearch]: https://github.com/wodby/elasticsearch
[wodby/kibana]: https://github.com/wodby/kibana
[wodby/mariadb]: https://github.com/wodby/mariadb
[wodby/memcached]: https://github.com/wodby/memcached
[wodby/nginx]: https://github.com/wodby/nginx
[wodby/node]: https://github.com/wodby/node
[wodby/opensmtpd]: https://github.com/wodby/opensmtpd
[wodby/postgres]: https://github.com/wodby/postgres
[wodby/redis]: https://github.com/wodby/redis
[wodby/rsyslog]: https://hub.docker.com/r/wodby/rsyslog
[wodby/solr]: https://github.com/wodby/solr
[wodby/varnish]: https://github.com/wodby/varnish
[wodby/webgrind]: https://hub.docker.com/r/wodby/webgrind
[wodby/xhprof]: https://hub.docker.com/r/wodby/xhprof
