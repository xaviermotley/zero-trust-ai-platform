# syntax=docker/dockerfile:1
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o model-gateway main.go

FROM alpine:3.18
RUN adduser -D nonroot
WORKDIR /home/nonroot
COPY --from=builder /app/model-gateway .
USER nonroot
EXPOSE 8080
ENTRYPOINT ["./model-gateway"]
