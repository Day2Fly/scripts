#!/bin/bash
# 自动创建 qBittorrent-nox 和 Vertex 的 systemd 服务，实现netcup重启服务 qBittorrent-nox 和 Vertex

USER="dayroot"
QB_PATH="/usr/local/bin/qbittorrent-nox"
VERTEX_PATH="/usr/local/bin/vertex"
QB_CONFIG="/home/$USER/.config/QBittorrent"
VERTEX_CONFIG="/home/$USER/.config/vertex/config.yaml"

echo "👉 正在为用户 $USER 创建 systemd 服务..."

# qBittorrent systemd 服务
sudo tee /etc/systemd/system/qbittorrent-nox.service > /dev/null <<EOF
[Unit]
Description=qBittorrent-nox headless BitTorrent client
After=network.target

[Service]
User=$USER
Group=$USER
UMask=002

ExecStart=$QB_PATH --profile=$QB_CONFIG
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Vertex systemd 服务
sudo tee /etc/systemd/system/vertex.service > /dev/null <<EOF
[Unit]
Description=Vertex service
After=network.target

[Service]
User=$USER
Group=$USER
WorkingDirectory=/home/$USER/.config/vertex
ExecStart=$VERTEX_PATH -c $VERTEX_CONFIG
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 并启用服务
sudo systemctl daemon-reload
sudo systemctl enable qbittorrent-nox
sudo systemctl enable vertex
sudo systemctl restart qbittorrent-nox
sudo systemctl restart vertex

echo "✅ 已创建并启动 qbittorrent-nox 和 vertex systemd 服务"
