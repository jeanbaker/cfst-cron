#!/bin/sh

# 1. 检查是否挂载了私有 task.sh
if [ ! -f "/app/task.sh" ]; then
    echo "【错误】未检测到 /app/task.sh 文件！"
    echo "请在运行容器时使用 -v /你的路径/task.sh:/app/task.sh 参数注入你的私有脚本。"
    exit 1
fi

# 2. 赋予任务脚本执行权限
chmod +x /app/task.sh

echo "----------------------------------------"
echo "✅ 容器环境就绪，私有 task.sh 已加载并赋予权限。"
echo "----------------------------------------"

# 3. 默认定时规则：每天凌晨 3 点
CRON_SCHEDULE="${CRON_SCHEDULE:-0 3 * * *}"

echo "----------------------------------------"
echo "当前配置的定时任务规则: [ $CRON_SCHEDULE ]"
echo "----------------------------------------"

# 4. 定义任务
CRON_JOB="$CRON_SCHEDULE /bin/bash /app/task.sh > /app/output/cron.log 2>&1"

# 5. 确保 crontab 文件存在
touch /etc/crontabs/root

# 6. 检查是否已存在，不存在才追加
if ! grep -Fqx "$CRON_JOB" /etc/crontabs/root; then
    echo "$CRON_JOB" >> /etc/crontabs/root
    echo "定时任务已配置："
    cat /etc/crontabs/root
else
    echo "定时任务已存在，跳过添加"
fi

# 7. Supercronic 前台运行，作为容器 PID 1
exec /usr/local/bin/supercronic /etc/crontabs/root
