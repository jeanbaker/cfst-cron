FROM alpine:latest

# 安装必要依赖
RUN apk add --no-cache ca-certificates curl tzdata dcron

WORKDIR /app

# 自动下载最新版 CloudflareSpeedTest
RUN LATEST_URL=$(curl -s https://api.github.com/repos/XIU2/CloudflareSpeedTest/releases/latest | grep "browser_download_url" | grep "linux_amd64.tar.gz" | cut -d '"' -f 4) \
    && echo "Downloading from: $LATEST_URL" \
    && curl -L -o cfst.tar.gz "$LATEST_URL" \
    && tar -zxvf cfst.tar.gz \
    && rm cfst.tar.gz \
    && chmod +x CloudflareSpeedTest

# 复制启动脚本
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
