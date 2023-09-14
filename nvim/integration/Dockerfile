FROM alpine:3.18

RUN apk add --no-cache \
    build-base\
    curl \
    git \
    go \
    fzf \
    neovim \
    neovim-doc \
    openssh \
    ripgrep

WORKDIR /root/go/github.com/cockroachdb

# clone whichever project written in go, so all go features
# may be tested in this container
RUN git clone https://github.com/cockroachdb/pebble.git
WORKDIR /root/go/github.com/cockroachdb/pebble
