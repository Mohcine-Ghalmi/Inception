FROM debian:stable

RUN apt update -y
RUN apt install -y mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools /var/www/

RUN service mariadb start && mysql < /var/www/initial_db.sql && rm -f /var/www/initial_db.sql;

CMD ["mysqld"]
