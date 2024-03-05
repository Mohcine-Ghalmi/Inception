FROM debian:buster
RUN apt update -y
RUN apt install -y mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools /var/www/

RUN service mysql start && mysql -u root -proot1234 < /var/www/initial_db.sql ;
RUN chown -R mysql:mysql /var/lib/mysql;\
    chmod 777 /var/run/mysqld;

CMD ["mysqld"]
