#!/bin/bash

# 目标 URL
URL="https://greencloudvps.com/billing/store/black-friday-2024/"

# 目标产品的 ID
TARGET_PRODUCT="2222JP"

# 你的 Bark 推送 URL
BARK_URL="https://api.day.app/mKC8zLdBG6ZoFA83ju8r3J/"

# 检查库存的函数
check_stock() {
    # 使用 curl 获取网页内容
    response=$(curl -s "$URL")

    # 从页面中提取库存信息（假设库存信息存在某个特定字段中）
    # 这里简单假设通过产品 ID 获取库存数据，你可以根据实际情况修改
    stock=$(echo "$response" | grep -oP "(?<=id=\"$TARGET_PRODUCT\".*?class=\"stock-amount\">)\d+")

    # 如果库存大于等于 1，返回 true
    if [ "$stock" -ge 1 ]; then
        return 0  # 有货
    else
        return 1  # 没有货
    fi
}

# 发送推送通知
send_bark_notification() {
    message=$1
    curl -X POST "$BARK_URL" -d "message=$message&sound=buzz"
}

# 主监控逻辑
while true; do
    if check_stock; then
        send_bark_notification "有货啦！"
    fi  # 没有货时，不发送任何推送

    # 每 10 分钟检查一次
    sleep 600
done