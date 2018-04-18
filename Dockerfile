FROM diegolima/jenkins-swarm-slave:3.9

MAINTAINER Diego Lima <diego@diegolima.org>

USER root
RUN export CLOUD_SDK_REPO="cloud-sdk-$(grep VERSION= /etc/os-release|sed 's/.*(\(.*\)).*/\1/')" \
      && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
      && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update \
    && apt-get install -y \
      awscli \
      google-cloud-sdk \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
    && unzip -od /usr/bin /tmp/terraform.zip \
    && rm -f /tmp/terraform.zip

USER jenkins-slave