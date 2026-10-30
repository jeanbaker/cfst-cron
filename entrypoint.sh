#!/bin/sh

# 1. 检查是否挂载了私有 task.sh
if [ ! -f "/app/task.sh" ]; then
    echo "【错误】未检测到 /app/task.sh 文件！[cite: 1]"
    echo "请在运行容器时使用 -v /你的路径/task.sh:/app/task.sh 参数注入你的私有脚本。[cite: 1]"
    exit 1
fi

# 2. 赋予任务脚本执行权限[cite: 1]
chmod +x /app/task.sh

# 3. 默认定时规则（如果未指定，默认每天凌晨 3 点执行）[cite: 1]
CRON_SCHEDULE="${CRON_SCHEDULE:-0 3 * * *}"
echo "----------------------------------------"[cite: 1]
echo "当前配置的定时任务规则: [ $CRON_SCHEDULE ]"[cite: 1]
echo "----------------------------------------"[cite: 1]

# 4. 将定时任务写入系统的 crontab（使用 /dev/stdout 替代 /proc/1/fd/1，更稳定）
echo "$CRON_SCHEDULE /bin/sh /app/task.sh > /dev/stdout 2>&1" > /etc/crontabs/root

echo "Cron 定时服务已启动，正在等待触发..."[cite: 1]

# 5. 前台稳定运行 Cron 服务（-f 前台运行，-l 2 指定正常日志级别）[cite: 1]
exec crond -f -l 2
