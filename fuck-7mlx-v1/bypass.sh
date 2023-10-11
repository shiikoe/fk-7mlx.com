#!/bin/bash
isbanned=0  #0代表未被限制，1代表被限制

site="https://www.7mlx.com"
herf="/wp-content/themes/zibll/yiyan/qv-yiyan.php"
wget -O reply.html $site$herf

#根据结果判断是否被anticc限制
if grep -q "anticc_js_concat" reply.html; then
    echo "检测到被anticc限制。即将尝试绕过。"
    isbanned=1
else
    echo "未被anticc限制。"
fi

#处理第一次绕过
if [ $isbanned -eq 0 ]; then
    # 执行命令
    echo "未被anitcc限制。程序结束。"
    return 0

else
    echo "开始获取真实地址。"
    python geturl.py
    realurl=$(python url.py)
    echo "解析跳转地址："$realurl
    echo "解析真实地址："$site$realurl
    sleep 1
fi


echo "开始重新检测是否通过aiticc检测。"
wget -O reply.html $site$realurl

#根据结果判断是否被anticc限制
if grep -q "anticc_js_concat" reply.html; then
    echo "检测到被anticc限制。再次尝试绕过。"
    isbanned=1
    echo "开始获取真实地址。"
    python geturl.py
    realurl=$(python url.py)
    echo "解析跳转地址："$realurl
    echo "解析真实地址："$site$realurl
    sleep 1
else
    echo "未被anitcc限制。程序结束。"
    return 0
fi

#再次判断是否被限制
wget -O reply.html $site$realurl

#根据结果判断是否被anticc限制
if grep -q "anticc_js_concat" reply.html; then
    echo "任然被anticc限制。绕过失败。"
    return 1
else
    echo "未被anitcc限制。程序结束。"
    return 0
fi