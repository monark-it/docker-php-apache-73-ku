# Juste like the ci
FROM php:7.3-apache

#Install System Packages
RUN apt-get update && apt install -y libzip-dev unzip zlib1g-dev libicu-dev libsqlite3-dev sqlite3 libpng-dev libjpeg-dev libfreetype6-dev git wget gnupg libmagickwand-dev

#Install PHP Extensions
RUN docker-php-ext-install pdo_sqlite pdo_mysql zip pcntl intl gd

RUN pecl install apcu xdebug imagick
RUN docker-php-ext-enable apcu xdebug imagick


# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable

# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 2.19
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR

# Download and install Chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH
ENV PANTHER_CHROME_DRIVER_BINARY /chromedriver

RUN ls /chromedriver

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN apt-get install -y ghostscript

RUN a2enmod proxy_fcgi ssl rewrite

USER www-data

EXPOSE 80
EXPOSE 8000

CMD ["apache2-foreground" ]
