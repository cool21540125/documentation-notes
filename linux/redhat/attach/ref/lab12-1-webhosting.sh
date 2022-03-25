#!/bin/bash

#variables
vHostname=$1
vTier=$2

httpdConf=/etc/httpd/conf/httpd.conf
vHostconfdir=/etc/httpd/conf.vhosts.d
defvHostconffile=$vHostconfdir/00-default-vhost.conf
vHostconffile=$vHostconfdir/$vHostname.conf
wwwRoot=/srv
defvHostdocroot=$wwwRoot/default/www
vHostdocroot=$wwwRoot/$vHostname/www

#check input
if [ "$vHostname" = '' ] || [ "$vTier" = '' ] ; then
 echo "Usage: $0 VHOSTNAME TIER"
 exit 1
else
 case $vTier in
  1)
   vHostadmin='basic_support@example.com'
   ;;
  2)
   vHostadmin='business_support@example.com'
   ;;
  3)
   vHostadmin='enterprise_support@example.com'
   ;;
  *)
   echo 'Invalid tier specified.'
   exit 1
   ;;
 esac
fi

#create conf directory one time if non-existent
if [ ! -d $vHostconfdir ] ; then
 echo "$vHosctconfdir"
 mkdir -p $vHostconfdir

 if [ $? -ne 0 ] ; then
  echo "ERROR: Failed creating $vHostconfdir."
  exit 1
 fi
fi

#add include one time if missing
grep -q '^IncludeOptional conf\.vhosts\.d/\*\.conf$' $httpdConf
if [ "$?" -ne 0 ] ; then
 #backup file
 cp -a $httpdConf $httpdConf.orig
 echo 'IncludeOptional conf.vhosts.d/*.conf' >> $httpdConf

 if [ "$?" -ne 0 ] ; then
  echo 'Error: Failed adding include directive.'
  exit 1
 fi 
fi

#default vHost configuration
if [ ! -f "$defvHostconffile" ] ; then
 cat << EOF > $defvHostconffile

<VirtualHost _default_:80>
 DocumentRoot $defvHostdocroot
 CustomLog "logs/default-vhost.log" combined
</VirtualHost>

<Directory $defvHostdocroot>
 Require all granted
</Directory>

EOF
fi

if [ ! -d "$defvHostdocroot" ] ; then
 mkdir -p $defvHostdocroot
 restorecon -RF /srv
fi

#check for virtual host conflict
if [ -f $vHostconffile ] ; then
 echo "ERROE: $vHostconffile already exists."
 exit 1
elif [ -d $vHostdocroot ] ; then
 echo "ERROR: $vHostdocroot already exists."
 exit 1
else
 cat << EOF > $vHostconffile

<Directory $vHostdocroot>
 Require all granted
 AllowOverride None
</Directory>

<VirtualHost *:80>
 DocumentRoot $vHostdocroot
 ServerName $vHostname
 ServerAdmin $vHostadmin
 ErrorLog "logs/${vHostname}_error_log"
 CustomLog "logs/${vHostname}_access_log" common
</VirtualHost>

EOF
 
 mkdir -p $vHostdocroot
 restorecon -RF /srv
fi

#check config and reload
if [ $? -eq 0 ] ; then
 systemctl reload httpd &> /dev/null
else
 echo "ERROR: Config error."
 exit 1
fi
