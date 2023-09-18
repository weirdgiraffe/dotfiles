FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    bash \
    build-essential \
    curl \
    fd-find \
    git \
    golang \
    openssh-client \
    ripgrep \
    unzip

# build dependencies for neovim
 RUN apt-get install -y \
    cmake \
    gettext \
    libtool-bin

RUN git clone --depth=1 --branch=v0.8.3 https://github.com/neovim/neovim
RUN cd neovim \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  && cd build \
  && cpack -G DEB \
  && dpkg -i nvim-linux64.deb

RUN curl -Ls https://github.com/golangci/golangci-lint/releases/download/v1.54.2/golangci-lint-1.54.2-linux-arm64.deb --output golangci-lint.deb
RUN ls -la
RUN dpkg -i golangci-lint.deb



WORKDIR /root/go/github.com/cockroachdb

# clone whichever project written in go, so all go features
# may be tested in this container
RUN git clone https://github.com/cockroachdb/pebble.git
WORKDIR /root/go/github.com/cockroachdb/pebble
