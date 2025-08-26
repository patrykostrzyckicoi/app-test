FROM alpine:3.22

# Install basic tools and dependencies
RUN apk add --no-cache curl unzip bash

# Set desired versions (update as needed, or set to 'latest')
ENV TERRAFORM_VERSION=1.12.2
ENV TERRAGRUNT_VERSION=0.83.2

# Install Terraform
RUN curl -fsSLo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/terraform \
    && rm terraform.zip

# Install Terragrunt
RUN curl -fsSLo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
    && chmod +x /usr/local/bin/terragrunt

# Verify installations
RUN terraform -version && terragrunt -version
