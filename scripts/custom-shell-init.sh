#!/usr/bin/env bash

# Ignore errors.
set -e

# Echo a alias to a bin file and adds execution permission to that bin.
echo -e "#!/bin/bash\ncomposer require drupal/admin_toolbar && drush si -y --db-url=mysql://drupal:drupal@mysql/drupal --account-pass=admin && drush en admin_toolbar -y && drush cr" > /usr/local/bin/dsi
chmod +x /usr/local/bin/dsi

echo -e "#!/bin/bash\ndrush -y si social --db-url=mysql://drupal:drupal@mysql/drupal --account-pass=admin social_module_configure_form.select_all='TRUE' install_configure_form.update_status_module='array(FALSE,FALSE)' --site-name='Open Social'; drush cset swiftmailer.transport transport 'smtp' -y; drush cset swiftmailer.transport smtp_host 'localhost' -y; drush cset swiftmailer.transport smtp_port 1025 -y; drush en social_demo -y; drush cc drush; drush sda file user group topic event event_enrollment post comment like; drush pmu social_demo -y; drush cc drush; drush image-flush --all; drush cron; drush sapi-rt; drush ev 'node_access_rebuild()'; drush en -y config_update config_update_ui devel devel_generate dblog views_ui field_ui contextual" > /usr/local/bin/dsisocial
chmod +x /usr/local/bin/dsisocial
