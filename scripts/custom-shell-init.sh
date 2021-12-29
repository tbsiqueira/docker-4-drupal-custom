#!/usr/bin/env bash

set -e

# Define permission for php-xdebug.log file.
XDEBUG_LOG=/tmp/php-xdebug.log
if test -f "$XDEBUG_LOG"; then
    sudo chmod 777 "$XDEBUG_LOG"
else
    touch "$XDEBUG_LOG"
    sudo chmod 777 "$XDEBUG_LOG"
fi

# Echo a alias to a bin file and adds execution permission to that bin.
echo -e "#!/bin/bash\ncomposer require drupal/admin_toolbar && drush si -y --db-url=mysql://drupal:drupal@mariadb/drupal --account-pass=admin && drush en admin_toolbar -y && drush cr" > /usr/local/bin/dsi
chmod +x /usr/local/bin/dsi

echo -e "#!/bin/bash\ndrush -y si social --db-url=mysql://drupal:drupal@mariadb/drupal --account-pass=admin social_module_configure_form.select_all='TRUE' install_configure_form.update_status_module='array(FALSE,FALSE)' --site-name='Open Social'; drush cset swiftmailer.transport transport 'smtp' -y; drush cset swiftmailer.transport smtp_host 'mailhog' -y; drush cset swiftmailer.transport smtp_port 1025 -y; drush en social_demo -y; drush cc drush; drush sda file user group topic event event_enrollment post comment like; drush pmu social_demo -y; drush cc drush; drush image-flush --all; drush cron; drush sapi-rt; drush ev 'node_access_rebuild()'; drush en -y config_update config_update_ui devel devel_generate dblog views_ui field_ui contextual" > /usr/local/bin/dsisocial
chmod +x /usr/local/bin/dsisocial

echo -e "#!/bin/bash\n/var/www/html/vendor/bin/phpstan analyse --configuration /var/www/html/html/profiles/contrib/social/phpstan.neon --generate-baseline /var/www/html/html/profiles/contrib/social/phpstan-baseline.neon --memory-limit=4G" > /usr/local/bin/stanbaseline
chmod +x /usr/local/bin/stanbaseline

echo -e "#!/bin/bash\n/var/www/html/vendor/bin/phpstan analyse --configuration /var/www/html/html/profiles/contrib/social/phpstan.neon --memory-limit=4G" > /usr/local/bin/stancheck
chmod +x /usr/local/bin/stancheck

echo -e "#!/bin/bash\ncd /var/www/html/html/profiles/contrib/social && sh /var/www/html/scripts/social/check-coding-standards.sh" > /usr/local/bin/cscheck
chmod +x /usr/local/bin/cscheck

echo -e "#!/bin/bash\nsh /var/www/html/scripts/social/run-tests.sh" > /usr/local/bin/unitcheck
chmod +x /usr/local/bin/unitcheck

echo -e "#!/bin/bash\nstancheck && cscheck && unitcheck" > /usr/local/bin/allcheck
chmod +x /usr/local/bin/allcheck
