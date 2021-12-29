FROM docker.io/library/ubuntu:20.04

RUN apt-get update && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        curl \
        vim

ARG VERSION=0.11.0

RUN curl -sfL https://github.com/turbot/steampipe/releases/download/v${VERSION}/steampipe_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ steampipe
RUN useradd -m steampipe

WORKDIR /home/steampipe
USER steampipe

# Install turbot/* plugins @latest
RUN steampipe plugin install steampipe && \
    steampipe plugin install $(steampipe query "SELECT name FROM steampipe_registry_plugin WHERE name LIKE 'turbot/%';" --output=csv --header=false)

VOLUME /home/steampipe/.steampipe/config
