FROM       mini/base
MAINTAINER Luis Lavena <luislavena@gmail.com>

ENV MYSQL_VERSION 5.5.46-r0

RUN apk-install mysql=$MYSQL_VERSION mysql-client=$MYSQL_VERSION pwgen

ADD ./config/mysql.cnf /etc/mysql/my.cnf
ADD ./scripts/start.sh /start.sh

VOLUME ["/data"]

EXPOSE 3306

CMD ["/start.sh"]
