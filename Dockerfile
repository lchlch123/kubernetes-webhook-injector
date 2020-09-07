# Build the manager binary
FROM golang:latest as builder

# Copy in the go src
WORKDIR /go/src/github.com/AliyunContainerService/kubernetes-webhook-injector
COPY ./ /go/src/github.com/AliyunContainerService/kubernetes-webhook-injector
# Build
RUN go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/ && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make

# Copy the controller-manager into a thin image
FROM alpine:3.12.0
RUN apk add bash openssl curl
WORKDIR /root/
COPY --from=builder /go/src/github.com/AliyunContainerService/kubernetes-webhook-injector/bin/kubernetes-webhook-injector .
COPY hack/gencerts.sh .

ENTRYPOINT  ["/root/kubernetes-webhook-injector"]
