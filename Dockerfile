FROM ubuntu:20.04
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y tzdata && \
    echo "America/Chicago" > /etc/timezone && \
    rm -f /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    yes | unminimize && \
    apt-get install -y software-properties-common vim curl git bash zip unzip openssh-server locales \
    	mariadb-client redis-tools dumb-init zsh rsync && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen
RUN add-apt-repository ppa:ondrej/php && \
    apt-get install -y php7.4 php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring \
        php7.4-curl php7.4-xml php7.4-bcmath php7.4-soap php7.4-intl
RUN curl -O https://getcomposer.org/download/2.1.5/composer.phar && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    curl -O https://files.magerun.net/n98-magerun2.phar && \
    chmod +x n98-magerun2.phar && mv n98-magerun2.phar /usr/local/bin/n98-magerun2
RUN mkdir /run/sshd && \
    mkdir /var/log/ssh && \
    sed -i "s/#Port 22/Port 222/ig" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/ig" /etc/ssh/sshd_config && \
    echo "alias redis-cli='redis-cli -h redis'" >> /etc/zsh/zprofile && \
    echo "alias mysql='mysql -h mysql'" >> /etc/zsh/zprofile 
COPY ioncube_loader_lin_7.4.so /usr/lib/php/20190902/ioncube_loader_lin_7.4.so
COPY ixed.7.4.lin /usr/lib/php/20190902/ixed.7.4.lin
COPY 00-ioncube.ini /etc/php/7.4/cli/conf.d/00-ioncube.ini
COPY first_run.sh /first_run.sh
ENTRYPOINT ["dumb-init", "/usr/sbin/sshd", "-D", "-E", "/var/log/ssh/sshd.log", "-o", "PermitRootLogin=no"]
