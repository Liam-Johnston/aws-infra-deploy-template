FROM hashicorp/terraform:1.0.1 as tf

RUN apk add --update --no-cache \
        make \
        bash \
        python3 \
        py3-pip \
        docker-cli \
        docker-compose \
        jq && \
    pip3 install --upgrade pip && \
    pip3 install \
        google \
        google-api-python-client \
        google-auth \
        awscli


# set default home directory for root.
ENV HOME /home/terraform
