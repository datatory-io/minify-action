FROM golang:1.18-alpine

RUN apk update
RUN apk add git bash
RUN go install github.com/tdewolff/minify/v2/cmd/minify@latest
WORKDIR "/github/workspace"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
