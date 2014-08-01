#!/bin/sh

local MYSQL_HOME="/data"

create_volume() {
	local result=0

	if [[ ! -d $MYSQL_HOME/mysql ]]; then
		echo "=> No MySQL volume detected in $MYSQL_HOME"
		echo "=> Creating initial data..."
		mysql_install_db --user=mysql --rpm > /dev/null 2>&1
		echo "=> Done!"
		result=1
	fi

	return $result
}

manual_boot() {
	# start server temporarily
	mysqld_safe > /dev/null 2>&1 &

	local result=1
	while [ $result -ne 0 ]; do
		echo "=> Waiting for MySQL to become available"
		sleep 5
		mysql -uroot -e "status" > /dev/null 2>&1
		result=$?
	done
}

manual_stop() {
	mysqladmin -uroot shutdown
}

set_admin_account() {
	# use provided password or generate a random one
	local PASS=${MYSQL_PASS:-$(pwgen -s 16 1)}
	local _type=$( [ ${MYSQL_PASS} ] && echo "defined" || echo "generated" )

	echo "=> Creating MySQL 'admin' user using a ${_type} password"
	manual_boot

	# create user and grant privileges
	mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
	mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

	echo "=> Done!"

	# TODO: show connection information
	echo "======================================================================"
	echo "  Use the following information to connect to this MySQL server:"
	echo ""
	echo "    mysql -h<host> -p<port> -uadmin -p$PASS"
	echo ""

	if [ ${_type} == "generated" ]; then
		echo "  !!! IMPORTANT !!!"
		echo ""
		echo "  For security reasons, it is recommended you change the above"
		echo "  password as soon as possible!"
		echo ""
	fi

	echo "  Please note that 'root' user is only allowed to local connections."
	echo "======================================================================"

	manual_stop
}

shutdown() {
	echo "=> Shutdown requested, stopping MySQL..."
	manual_stop

	exit 0
}

start() {
	create_volume

	if [ $? -ne 0 ]; then
		set_admin_account
	fi

	trap shutdown SIGTERM SIGINT

	echo "=> Starting MySQL..."
	mysqld_safe &

	wait
}

start
