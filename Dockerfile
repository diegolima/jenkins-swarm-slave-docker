FROM diegolima/jenkins-swarm-slave:3.9

MAINTAINER Diego Lima <diego@diegolima.org>

USER root
RUN export CLOUD_SDK_REPO="cloud-sdk-$(grep VERSION= /etc/os-release|sed 's/.*(\(.*\)).*/\1/')" \
      && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
      && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install -y apt-transport-https && rm -rf /var/lib/apt/lists/*

RUN export AZ_REPO="$(grep VERSION= /etc/os-release|sed 's/.*(\(.*\)).*/\1/')" \
      && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee -a /etc/apt/sources.list.d/azure-cli.list

RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893 \
    && apt-get update \
    && apt-get install -y \
      azure-cli \
      python3 \
      python-pip \
      google-cloud-sdk \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && pip install awscli

RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
    && unzip -od /usr/bin /tmp/terraform.zip \
    && rm -f /tmp/terraform.zip

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(grep VERSION= /etc/os-release|sed 's/.*(\(.*\)).*/\1/') stable" | tee /etc/apt/sources.list.d/docker-ce.list \
    && apt-get update \
    && apt-get install -y docker-ce \
    && rm -rf /var/lib/apt/lists/*

USER jenkins-slave