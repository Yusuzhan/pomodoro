# Stage 1: Build Flutter web
FROM ghcr.io/cirruslabs/flutter:stable AS flutter-builder
WORKDIR /app
COPY mobile/ .
RUN flutter build web --release

# Stage 2: Build Go server
FROM golang:1.26-alpine AS go-builder
WORKDIR /app
COPY server/ .
COPY --from=flutter-builder /app/build/web ./cmd/server/web/dist
RUN CGO_ENABLED=0 go build -o server ./cmd/server

# Stage 3: Runtime
FROM alpine:3.19
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=go-builder /app/server .
EXPOSE 7860
CMD ["./server"]
