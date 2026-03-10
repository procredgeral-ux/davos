// Linux Server Script

#!/bin/sh


##Function Definition
#Download, extract .tar.gz and clean function
download_and_extract () { 
if [ ! -d master ]; then
	if [ ! -f master.tar.gz ]; then
			echo "No local master.tar.gz found, downloading with curl."
			curl -O -L https://github.com/user/repo/archive/master.tar.gz
	fi
	if [ ! -f master.tar.gz ]; then
		echo "curl failed to download master.tar.gz, trying wget."
		wget https://github.com/user/repo/archive/master.tar.gz
			if [ ! -f master.tar.gz ]; then
					echo "wget failed as well. Aborting!"
					exit 1
			fi
	fi
	echo "master.tar.gz found!"
	echo "Extracting master.tar.gz to /tmp."
	tar -xzf master.tar.gz -C /tmp
	echo "Removing master.tar.gz."
	rm master.tar.gz
	echo "Entering temporary directory."
	cd /tmp || exit 1
	echo "Organising and cleaning up the extracted files."
	rm Server-master/src/Start.bat
	rm Server-master/.gitignore
fi
}

#Install Function
server_install() {
	echo "INSTALLING"
	if [ "$2" = "" ]; then
			echo "Please specify the directory in which you would like to install."
			exit 1
	fi
	
	echo "The server will be installed inside $2/server."
	echo "Do you wish to continue? (Y/N)"
	read -r yn
	case $yn in
			[Yy]* ) ;;
			 * ) exit 1;;
	esac
	
	if [ ! -d "$2" ]; then
			echo "$2 doesn't exist or is otherwise not accessible. Make sure you use absolute paths."
			exit 1
	fi
	
	if [[ ! "$2" = /* ]]
	then
	   echo "$2 isn't an absolute path! This is required for proper installation."
	   exit 1
	fi
	
	if grep "Arch Linux" /etc/*-release > /dev/null; then
		echo "You are running Arch Linux."
		echo "Do you wish to continue? (Y/N)"
		read -r yn
		case $yn in
			[Yy]* ) ;;
			* ) exit 1;;
		esac
	fi
	download_and_extract
	echo "Copying the generated server folder to $2."
	cp -RTf Server-master "$2"/server
	echo "Removing temporary files"
	rm -R Server-master
	
	echo "Creating server user and group if they don't exist"
	if ! getent group "server" >/dev/null; then
		groupadd -r server
	fi
	if ! getent passwd "server" >/dev/null; then
		useradd -r -M -N -g server -d "$2"/server -s /usr/bin/nologin -c 'Game Server' server
	fi
	
	echo "Installing ws module"
	rm -R /root/.npm
	cd "$2"/server || exit 1
	npm install ws
	
	echo "Symlinking gameserver.ini to /etc/server"
	ln -s "$2"/server/gameserver.ini /etc/server
	
	echo "Setting proper permissions"
	chown -R server:server "$2"/server
	chmod -R 755 "$2"/server
	
	echo "Finished installing! :D"
}

#Update Function
server_update() {
	echo "UPDATING"
	if [ "$2" = "" ]; then
			echo "Please specify your existing installation."
			exit 1
	fi
	
	echo "The server inside $2/server will be updated."
	echo "Do you wish to continue? (Y/N)"
	read -r yn
	case $yn in
			[Yy]* ) ;;
			 * ) exit 1;;
	esac
	
	if [ ! -f "$2/server/src/index.js" ]; then
			echo "$2/server/src/index.js either way doesn't exist or isn't accesible. Are you sure this is an installation?"
			exit 1
	fi
	
	if [[ ! "$2" = /* ]]
	then
	   echo "$2 isn't an absolute path! This is required for proper installation."
	   exit 1
	fi
	
	download_and_extract
	echo "Do you wish to install a fresh gamserver.ini? (Y/N)"
	read -r yn
	case $yn in
			[Yy]* ) ;;
			 * ) rm Server-master/gameserver.ini;;
	esac
	echo "Copying the generated server folder to $2."
	cp -RTf Server-master "$2"/server
	echo "Removing temporary files"
	rm -R Server-master
	
	echo "Updating ws module"
	rm -R /root/.npm
	cd "$2"/server || exit 1
	npm install ws
	
	echo "Setting proper permissions"
	chown -R server:server "$2"/server
	chmod -R 755 "$2"/server
	
	echo "Finished updating! :D"
}

#Uninstall Function
server_uninstall() {
	echo "UNINSTALLING"
	if [ "$2" = "" ]; then
			echo "Please specify the directory in which the server is installed."
			exit 1
	fi
	
	if [ ! -f "$2/server/src/index.js" ]; then
			echo "$2/server/src/index.js either way doesn't exist or isn't accesible. Are you sure this is an installation?"
			exit 1
	fi
	
	echo "The ENTIRE $2/server folder will be DELETED."
	echo "Do you wish to continue? (Y/N)"
	read -r yn
	case $yn in
			[Yy]* ) ;;
			* ) exit 1;;
	esac
	
	echo "Removing server user and group"
	if getent passwd "server" >/dev/null; then
		userdel server > /dev/null
	fi
	if getent group "server" >/dev/null; then
		groupdel server >/dev/null
	fi
	
	echo "Unlinking /etc/server"
	unlink /etc/server
	
	echo "Removing ws module"
	cd "$2"/server || exit 1
	npm uninstall ws
	
	echo "Removing the ENTIRE Server folder"
	rm -R "$2"/server
	echo "Finished uninstalling!"
}

echo "SERVER INSTALL, UPDATE AND UNINSTALL SCRIPT"
echo "Make sure you have: nodejs, npm, tar and wget/curl (for automatic downloads) installed!"
echo "However, you may also download and extract master.tar.gz manually."
echo "Place it in the same directory as the installer and name the extracted folder Server-master."
echo "----------------------------------------------------------------------------------------------------"
echo 'IMPORTANT: Use the following command to start the server in interactive mode for improved security:'
echo 'sudo -u server -H /bin/sh -c "cd; /bin/node src/index.js"'
if [ ! "$(id -u)" = 0 ]; then
		echo "This script must be run as root" 1>&2
		exit 1
fi


case "$1" in
	install)
		server_install $1 $2
		;;
	update)
		server_update $1 $2
		;;
	uninstall)
		server_uninstall $1 $2
		;;
	"")
		echo "Blank sub-command. Please specify if you want to install, update or uninstall."
		exit 1
		;;
	*)
		echo "Invalid sub-command. Please specify if you want to install, update or uninstall."
		exit 1
		;;
esac

#If I havn't exited abnormally yet, exit normally normally now
exit 0
