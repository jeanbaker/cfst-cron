FROM alpine:latest

# 安装必要依赖
RUN apk add --no-cache ca-certificates curl tzdata dcron

WORKDIR /app

# 直接通过 GitHub 的 Release 稳定直链下载最新版（会自动重定向到最新版本）
RUN curl -L -o cfst.tar.gz https://github.com/XIU2/CloudflareSpeedTest/releases/latest/download/cfst_linux_amd64.tar.gz \
    && tar -zxvf cfst.tar.gz \
    && rm cfst.tar.gz \
    && chmod +x cfst

# 复制启动脚本
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
