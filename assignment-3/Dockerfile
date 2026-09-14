FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    procps \
    bind-tools \
    netcat-openbsd \
    ca-certificates

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

WORKDIR /app

COPY app/app.sh /app/

RUN mkdir -p /app/logs && \
    chown -R appuser:appgroup /app && \
    chmod +x /app/app.sh

USER appuser

ENTRYPOINT ["/app/app.sh"]

