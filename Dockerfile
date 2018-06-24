FROM ddugovic/sbt

RUN useradd -ms /bin/bash lichess \
    && apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y apt-transport-https \
    # Add the MongoDB source.
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 \
    && echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" \
        | tee /etc/apt/sources.list.d/mongodb-org-3.6.list \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash -E - \
    && apt-get update \
    && apt-get install -y \
        git-all \
        locales \
        mongodb-org \
        nginx \
        nodejs \
        parallel \
        sudo \
    # Disable sudo login.
    && echo "lichess ALL = NOPASSWD : ALL" >> /etc/sudoers \
    # Set locale.
    && locale-gen en_US.UTF-8 \
    # Update node.
    && npm install -g n \
    && n stable \
    && npm install -g yarn \
    && yarn global add gulp-cli \
    # Download svgcleaner 0.9.5 instead of installing it and its dependencies from scratch
    && wget -qO- https://github.com/RazrFalcon/svgcleaner/releases/download/v0.9.5/svgcleaner_linux_x86_64_0.9.5.tar.gz | tar -zx \
    && mv svgcleaner /usr/bin/svgcleaner \
    # Create the MongoDB database directory.
    && mkdir /data \
    && mkdir /data/db \
    # Remove now unneeded dependencies.
    && apt-get purge -y \
        curl \
        git-all \
        nodejs \
    && apt-get autoremove -y \
    && apt-get clean

Add .profile /home/lichess/.profile
ADD run.sh /home/lichess/run.sh
ADD nginx.conf /etc/nginx/nginx.conf

# Use UTF-8 encoding.
ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

# Run as a non-privileged user.
USER lichess

EXPOSE 80

WORKDIR /home/lichess

ENTRYPOINT ./run.sh
