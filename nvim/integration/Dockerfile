# vim: ts=4 sw=4 et
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
    apt-get update 
    apt-get upgrade -y
    apt-get install -y \
        bash \
        build-essential \
        curl \
        fd-find \
        fzf \
        git \
        openssh-client \
        ripgrep \
        unzip
EOF

# build and install neovim
RUN <<EOF
    apt-get install -y \
        cmake \
        gettext \
        libtool-bin
    git clone --depth=1 --branch=v0.9.1 https://github.com/neovim/neovim
    cd neovim
    make -j CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build
    cpack -G DEB
    dpkg -i nvim-linux64.deb
    cd ../..
    rm -rf neovim
EOF

# install golanci-lint
RUN <<EOF
    curl -Ls https://github.com/golangci/golangci-lint/releases/download/v1.54.2/golangci-lint-1.54.2-linux-arm64.deb --output golangci-lint.deb
    dpkg -i golangci-lint.deb
    rm golangci-lint.deb
EOF

RUN <<EOF
    apt-get install -y nodejs npm
EOF

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
RUN <<EOF
    set -x
    TAR=go1.21.4.${TARGETOS}-${TARGETARCH}${TARGETVARIANT}.tar.gz
    curl -sLO https://go.dev/dl/${TAR}
    rm -rf /usr/local/go 
    tar -C /usr/local -xzf ${TAR}
    rm -f ${TAR}
EOF

ENV PATH="$PATH:/usr/local/go/bin"

# clone whichever project written in go, so all go features
# may be tested in this container
WORKDIR /root/go/casbin
RUN git clone https://github.com/casbin/casbin.git
WORKDIR /root/go/casbin/casbin
RUN go build
