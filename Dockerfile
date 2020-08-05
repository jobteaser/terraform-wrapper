FROM golang:1.14-buster as builder
RUN apt-get update && apt-get install -y \
    libpcsclite-dev \
    --no-install-recommends
RUN go get -u github.com/kreuzwerker/awsu

FROM python:3.8-slim

# Adding awsu binary
COPY --from=builder /go/bin/awsu /usr/local/bin/awsu

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-utils \
    software-properties-common \
    openssh-client \
    git \
    vim \
    libpcsclite-dev \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Make a user and use it
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
  && chown -R user:user $HOME \
  && usermod -a -G audio,video user
USER user
WORKDIR /app

# Adding app content
ADD --chown=user:user . /app/

# Installing requirements
RUN pip install -r requirements.txt

# Adding app to PATH
ENV PATH=/app/bin:$PATH
WORKDIR $HOME/repo
ENTRYPOINT ["/app/bin/tfwrapper"]
