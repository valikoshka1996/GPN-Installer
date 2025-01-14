#!/bin/bash

# Оновлення пакетів та інсталяція необхідних залежностей
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y wget curl apt-transport-https software-properties-common

# Інсталяція Prometheus
echo "Інсталяція Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz
tar -xvzf prometheus-2.44.0.linux-amd64.tar.gz
sudo mv prometheus-2.44.0.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.44.0.linux-amd64/promtool /usr/local/bin/
sudo mkdir -p /etc/prometheus
sudo mv prometheus-2.44.0.linux-amd64/consoles /etc/prometheus
sudo mv prometheus-2.44.0.linux-amd64/console_libraries /etc/prometheus
sudo rm -rf prometheus-2.44.0.linux-amd64
rm prometheus-2.44.0.linux-amd64.tar.gz

# Налаштування Prometheus
echo "Налаштування Prometheus..."
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOL

# Створення systemd сервісу для Prometheus
echo "Створення systemd сервісу для Prometheus..."
sudo bash -c 'cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Інсталяція Node Exporter
echo "Інсталяція Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz
tar -xvzf node_exporter-1.8.0.linux-amd64.tar.gz
sudo mv node_exporter-1.8.0.linux-amd64/node_exporter /usr/local/bin/
sudo rm -rf node_exporter-1.8.0.linux-amd64
rm node_exporter-1.8.0.linux-amd64.tar.gz

# Створення systemd сервісу для Node Exporter
echo "Створення systemd сервісу для Node Exporter..."
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Інсталяція Grafana через офіційний репозиторій
echo "Інсталяція Grafana через офіційний репозиторій..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt-get update
sudo apt-get install grafana -y

# Створення systemd сервісу для Grafana
echo "Створення systemd сервісу для Grafana..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Запуск Prometheus та Node Exporter
echo "Запуск Prometheus та Node Exporter..."
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Виведення логінів та паролів
GRAFANA_ADMIN_USER="admin"
GRAFANA_ADMIN_PASSWORD="admin"

echo "Інсталяція завершена!"
echo "Grafana доступна за адресою: http://localhost:3000"
echo "Логін: $GRAFANA_ADMIN_USER"
echo "Пароль: $GRAFANA_ADMIN_PASSWORD"
