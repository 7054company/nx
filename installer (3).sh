#!/bin/sh
PKG_URL='https://data.easyconfig.net/licsys';R='\e[01;91m';G='\e[01;92m';Y='\e[01;93m';N='\e[0m';SUCCESS_CODE=0;APT_PKG_CODE=1;YUM_PKG_CODE=1;CURL_PKG_CODE=1;WGET_PKG_CODE=1;isPackageAvailable(){ which $1>/dev/null 2>&1;return $?;};packageInstaller(){ if [ $1 -eq $SUCCESS_CODE ];then echo -e $G$3 'is already installed'$N;else echo -e $Y'Installing' $3 '...'$N;sudo $2 install $3 -y;fi;};startInstallPackages(){ packageInstaller $1 $3 wget;packageInstaller $2 $3 curl;};checkPackageManager(){ if [ $APT_PKG_CODE -eq $SUCCESS_CODE ];then startInstallPackages $WGET_PKG_CODE $CURL_PKG_CODE apt-get;elif [ $YUM_PKG_CODE -eq $SUCCESS_CODE ];then startInstallPackages $WGET_PKG_CODE $CURL_PKG_CODE yum;CENTOS_VER=$(rpm --eval '%{centos_ver}');CENTOS_TARGET="8";if [ $CENTOS_VER -eq $CENTOS_TARGET ];then sudo yum install -y compat-openssl10;else sudo yum install -y ca-certificates;fi;else echo $R'Unsupported Oprating System!'$N;echo 'This system cannot run on the OS you are using!';fi;};id="$(id)";id="${id#*=}";id="${id%%\(*}";id="${id%% *}";if [ "$id" != "0" ]&&[ "$id" != "root" ];then echo -e $R'Please Run This Script As ROOT.'$N;exit 1;fi;isPackageAvailable apt;APT_PKG_CODE=$?;isPackageAvailable yum;YUM_PKG_CODE=$?;isPackageAvailable wget;WGET_PKG_CODE=$?;isPackageAvailable curl;CURL_PKG_CODE=$?;echo "Checking if curl and wget is installed...";sleep 0.4;checkPackageManager $APT_PKG_CODE $YUM_PKG_CODE;sleep 0.4;echo -e $Y"Dependencies Fullfilled!"$N;echo "Prepearing to install licsys...";echo "Downloading Files...";wget --inet4-only -q -O /usr/bin/licsys $PKG_URL;retval=$?;if [ $retval -ne 0 ];then echo -e $R"\nFailed To Download Licsys Packege!"$N;echo "Contact Support To get it fixed.";exit 1;fi;echo "Setting Up Permissions...";chmod +x /usr/bin/licsys;echo "Finishing UP...";licsys sys install;licsys sys update>/dev/null 2>&1