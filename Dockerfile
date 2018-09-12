FROM golang:latest as builder
# Copy the local package files to the container's workspace.
ENV GOBIN /go/bin
RUN export GOBIN=$GOPATH/bin
RUN export PATH=$GOPATH:$GOBIN:$PATH

RUN  apt-get update && apt-get install -y unzip --no-install-recommends && \
    apt-get autoremove -y && apt-get clean -y && \
    curl https://glide.sh/get | sh && \
    apt-get install -y git

RUN mkdir -p /go/src/compose-file
WORKDIR /go/src/compose-file

#COPY glide.yaml ./

#RUN glide install

RUN go get github.com/mattn/go-shellwords && \
    go get github.com/stretchr/testify && \
    go get github.com/xeipuuv/gojsonreference && \
    go get github.com/xeipuuv/gojsonschema && \
    go get gopkg.in/yaml.v2 &&\
    go get github.com/mitchellh/mapstructure &&\
    go get github.com/docker/docker/api &&\
    go get github.com/docker/docker/client &&\
    go get github.com/sirupsen/logrus &&\
    go get github.com/docker/cli/cli &&\
    go get github.com/docker/cli/opts &&\
    go get github.com/docker/go-units &&\
    go get github.com/docker/go-connections/nat &&\
    go get gotest.tools/assert &&\
    go get github.com/google/go-cmp/cmp/cmpopts &&\
    go get github.com/imdario/mergo &&\
    go get gotest.tools/env

COPY . .
RUN rm -r ../github.com/docker/cli/vendor
RUN rm -r ../github.com/docker/cli/cli/compose/schema/schema.go

RUN cp ./schema/schema.go ../github.com/docker/cli/cli/compose/schema/schema.go

RUN     go get github.com/dnephin/filewatcher && \
        cp /go/bin/filewatcher /usr/bin/

RUN     go get github.com/jteeuwen/go-bindata/... && \
        cp /go/bin/go-bindata /usr/bin/


RUN make

