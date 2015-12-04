## GLPI upgrade script ##
Silently upgrade glpi installation (from debian package) with tar package

Grab your url of the GLPI version needed https://github.com/glpi-project/glpi/releases

#### HOWTO ####

`# sh glpi-upgrade.sh https://github.com/glpi-project/glpi/releases/download/X.XX/glpi-X.XX.tar.gz`

To end the upgrade go to http://ipserver/glpi

For security reasons, please remove file: install/install.php

Plugins to upgrade
