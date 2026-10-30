# 🚀 CFST-Cron Docker 镜像使用指南

这是一个内置 **CloudflareSpeedTest (CFST)** 与 **Cron 定时服务**的轻量级 Docker 镜像，支持通过挂载自定义脚本来实现定时优选 IP 与自动化处理。

---

## ⚙️ 快速部署

在你的服务器上执行以下命令启动容器：

```bash
docker run -d \
  --name my-cfst-cron \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -e CRON_SCHEDULE="0 */6 * * *" \
  -v /root/cfst/task.sh:/app/task.sh \
  -v /root/cfst/output:/app/output \
  jakeooo/cfst-cron:latest

CRON_SCHEDULE参数为定时环境变量：
常见 Cron 表达式参考：
"0 3 * * *"：每天凌晨 3 点执行
"0 */6 * * *"：每隔 6 小时执行一次
"0 0 * * 0"：每周日零点执行

compose部署方式：
version: "3.8"

services:
  cfst-cron:
    image: jakeooo/cfst-cron:latest
    container_name: cfst-cron
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
      - CRON_SCHEDULE=0 */6 * * *   # 在这里直接通过环境变量修改定时任务规则
    volumes:
      - ./task.sh:/app/task.sh      # 挂载你的本地私有执行脚本
      - ./output:/app/output        # 挂载测速结果输出目录
