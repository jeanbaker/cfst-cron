FROM alpine:latest

# 安装必要依赖
RUN apk add --no-cache \
    ca-certificates \
    curl \
    tzdata \
    bash \
    jq

WORKDIR /app

# 下载并安装 CFST
RUN curl -fsSL -o cfst.tar.gz \
    https://github.com/XIU2/CloudflareSpeedTest/releases/latest/download/cfst_linux_amd64.tar.gz \
    && tar -zxf cfst.tar.gz \
    && mv cfst_linux_amd64/cfst /app/cfst \
    && mv cfst_linux_amd64/ip.txt /app/ip.txt \
    && mv cfst_linux_amd64/ipv6.txt /app/ipv6.txt \
    && rm -rf cfst.tar.gz cfst_linux_amd64 \
    && chmod +x /app/cfst

# 安装 Supercronic v0.2.51（Linux AMD64）
RUN curl -fsSL -o /usr/local/bin/supercronic \
    https://github.com/aptible/supercronic/releases/download/v0.2.51/supercronic-linux-amd64 \
    && echo "1692066e350a88ff4d7d6474fe3c7a6c41ec5e89  /usr/local/bin/supercronic" | sha1sum -c - \
    && chmod +x /usr/local/bin/supercronic

# 复制配置文件和启动脚本
COPY ASN13335.txt /app/ASN13335.txt
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
