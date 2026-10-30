FROM alpine:latest

# 安装必要依赖
RUN apk add --no-cache ca-certificates curl tzdata dcron bash jq

WORKDIR /app

# 1. 下载压缩包
# 2. 解压
# 3. 将解压出来的 cfst 移动到 /app 根目录，保持原名 cfst
# 4. 清理无用文件和目录
# 5. 赋予执行权限
RUN curl -L -o cfst.tar.gz https://github.com/XIU2/CloudflareSpeedTest/releases/latest/download/cfst_linux_amd64.tar.gz \
    && tar -zxvf cfst.tar.gz \
    && mv cfst_linux_amd64/cfst /app/cfst \
    && mv cfst_linux_amd64/ip.txt /app/ip.txt \
    && mv cfst_linux_amd64/ipv6.txt /app/ipv6.txt \
    && rm -rf cfst.tar.gz cfst_linux_amd64 \
    && chmod +x /app/cfst

# 复制启动脚本
COPY ASN13335.txt /app/ASN13335.txt
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
