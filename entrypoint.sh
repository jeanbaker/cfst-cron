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
echo "💡 提示：你可以随时使用 docker exec 手动触发测速："
echo "   docker exec -it cfst-cron /bin/sh /app/task.sh"
echo "----------------------------------------"

# 3. 使用 tail -f 挂起容器，让容器作为长驻后台的服务平稳运行，绝对不重启
exec tail -f /dev/null
