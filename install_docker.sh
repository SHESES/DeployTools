#!/bin/bash

# Универсальный скрипт для установки Docker на Ubuntu (x86 и ARM)

set -e

echo "🔄 Обновление пакетов..."
sudo apt update

echo "⚙️ Установка зависимостей..."
sudo apt install -y ca-certificates curl gnupg

echo "📁 Создание директории для ключей..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "🔑 Загрузка GPG-ключа Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

ARCH=$(dpkg --print-architecture)
CODENAME=$(lsb_release -cs)

echo "📦 Добавление репозитория Docker [arch=$ARCH codename=$CODENAME]..."
echo \
  "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Обновление индексов пакетов..."
sudo apt update

echo "🐳 Установка Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "✅ Проверка установки Docker..."
sudo docker --version

echo "👤 Добавление пользователя $(whoami) в группу docker..."
sudo usermod -aG docker $USER

echo "🚀 Включение автозапуска Docker..."
sudo systemctl enable docker

echo "🎉 Готово! Перезагрузись или выполни 'newgrp docker' для применения."
