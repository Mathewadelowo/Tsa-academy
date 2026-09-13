FROM alpine:3.22

RUN apk add --no-cache \
    bash \
     procps \
    iputils \
    ca-certificates

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

WORKDIR /app


COPY app/ /app/


RUN chmod +x /app/*.sh && \
    chown -R appuser:appgroup /app

USER appuser

ENTRYPOINT ["/app/diagnostic.sh"]

CMD ["help"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD ["/app/healthcheck.sh"]
