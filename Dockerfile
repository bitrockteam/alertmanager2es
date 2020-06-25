FROM golang:1.14 as build

WORKDIR /go/src/github.com/webdevops/alertmanager2es

# Get deps (cached)
COPY ./go.mod /go/src/github.com/webdevops/alertmanager2es
COPY ./go.sum /go/src/github.com/webdevops/alertmanager2es
RUN go mod download

# Compile
COPY ./ /go/src/github.com/webdevops/alertmanager2es
RUN make lint
RUN make build
RUN ./alertmanager2es --help

#############################################
# FINAL IMAGE
#############################################
FROM gcr.io/distroless/static
COPY --from=build /go/src/github.com/webdevops/alertmanager2es/alertmanager2es /
USER 1000
ENTRYPOINT ["/alertmanager2es"]
