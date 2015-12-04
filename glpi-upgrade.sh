#!/bin/bash
#
# Written by Yvan Manon (Tekmans) <tekmans@no-log.org>
#


URL=$1
TARGZ=${URL##*/}
iERSION=${TARGZ%.tar*}

if [ -z "$1" ]
  then
    echo ""
    echo "$(tput setaf 1)===== L'url de téléchargement de glpi est manquante$(tput sgr 0)"
    echo ""
    echo "===== Allez sur https://github.com/glpi-project/glpi/releases"
    echo "===== Exemple : ./glpi-upgrade.sh https://github.com/glpi-project/glpi/releases/download/0.90/glpi-0.90.tar.gz"
    echo ""
    exit
fi
echo "$(tput setaf 2)===== Mise à jour de GLPI $(tput sgr 0)"
echo ""

echo "===== Donwloading GLPI "$VERSION
[ ! -f /tmp/$TARGZ ] && wget $1 -O /tmp/$TARGZ && tar vxf /tmp/$TARGZ -C /opt/ || tar xf /tmp/$TARGZ -C /opt/
[ $? -eq 0 ] && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)"|| echo "$(tput setaf 1)[ FAILED ] $(tput sgr 0)"

echo "===== Copy config directory"
cp -rf /etc/glpi/config/config_db.php /opt/glpi/config
[ $? -eq 0 ] && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)"|| echo "$(tput setaf 1)[ FAILED ] $(tput sgr 0)"

echo "===== Delete file directory"
rm -rf /opt/glpi/files
[ $? -eq 0 ] && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)"|| echo "$(tput setaf 1)[ FAILED ] $(tput sgr 0)"

echo "===== Link the new GLPI files directory"
ln -s /var/lib/glpi/files /opt/glpi/files
[ $? -eq 0 ] && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)"|| echo "$(tput setaf 1)[ FAILED ] $(tput sgr 0)"

echo "===== Check if the apache conf.d is /opt/glpi"
grep -q -e "^Alias /glpi /usr/share/glpi$"  /etc/apache2/conf.d/glpi
[ $? -eq 0 ] && sed 's/\/usr\/share\/glpi/\/opt\/glpi/g' -i /etc/apache2/conf.d/glpi && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)" || echo "$(tput setaf 2)[ Already done ] $(tput sgr 0)"

echo "===== Create needed directories"
[ ! -f /opt/glpi/files/_rss ] && mkdir /opt/glpi/files/_rss 2> /dev/null && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)" || echo "$(tput setaf 2)[ Already done ] $(tput sgr 0)"
[ ! -f /opt/glpi/files/_pictures ] && mkdir /opt/glpi/files/_pictures 2> /dev/null && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)" || echo "$(tput setaf 2)[ Already done ] $(tput sgr 0)"

echo "===== Set acls"
chown -R www-data:www-data /opt/glpi
chown -R www-data:www-data /var/lib/glpi/files/_rss
chown -R www-data:www-data /var/lib/glpi/files/_pictures
chmod -R 755 /opt/glpi/config/
[ $? -eq 0 ] && echo "$(tput setaf 2)[ OK ] $(tput sgr 0)"|| echo "$(tput setaf 1)[ FAILED ] $(tput sgr 0)"


echo "===== Restarting Apache"
service apache2 restart
echo""
echo "==================================================================================="
echo "=====    To end the upgrade go to http://ipserver/glpi                        ====="
echo "=====    For security reasons, please remove file: install/install.php        ====="
echo "=====    Plugins to upgrade                                                   ====="
echo "==================================================================================="
echo""
mysql glpi -N -e "select directory from glpi_plugins;"


        
