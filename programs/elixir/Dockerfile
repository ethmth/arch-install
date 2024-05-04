FROM debian:bookworm

RUN \
  apt-get update && \
  apt-get --no-install-recommends -y install \
    python3 \
    python3-pip \
    python3-falcon \
    python3-jinja2 \
    python3-bsddb3 \
    python3-pytest \
    python3-pygments- \
    pipx \
    perl \
    git \
    apache2 \
    libapache2-mod-wsgi-py3 \
    libjansson4 \
    libyaml-0-2 \
    wget \
    unzip

RUN \
  wget https://bootlin.com/pub/elixir/universal-ctags_0+git20200526-0ubuntu1_amd64.deb

RUN \
  dpkg -i universal-ctags_0+git20200526-0ubuntu1_amd64.deb

RUN \
  wget https://bootlin.com/pub/elixir/Pygments-2.6.1.elixir-py3-none-any.whl

RUN \
  pip3 install ./Pygments-2.6.1.elixir-py3-none-any.whl --break-system-packages

RUN \
  git config --global user.email 'elixir@dummy.com' && \
  git config --global user.name 'elixir'

RUN \
  git clone https://github.com/bootlin/elixir.git /usr/local/elixir/

RUN \
  mkdir -p /srv/elixir-data

COPY ./repos /opt/repos
COPY ./zip_repos.sh /opt/zip_repos.sh
RUN bash /opt/zip_repos.sh

COPY ./clone_repos.sh /opt/clone_repos.sh
COPY ./git_repos.txt /opt/git_repos.txt
RUN bash /opt/clone_repos.sh /opt/git_repos.txt

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

RUN \
  echo -e "\nHttpProtocolOptions Unsafe" >> /etc/apache2/apache.conf && \
  a2enmod cgi rewrite

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]