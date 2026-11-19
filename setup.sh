#!/bin/bash
set -e

echo "=== 1. Установка GNS3 Server ==="
sudo add-apt-repository ppa:gns3/ppa -y
sudo apt update
sudo apt install gns3-server python3 -y

echo "=== 2. Настройка службы systemd ==="
# Копируем шаблон службы и подставляем текущего пользователя
sed "s/^User=.*/User=$USER/; s/^Group=.*/Group=$USER/" gns3-server.service | sudo tee /etc/systemd/system/gns3server.service > /dev/null
sudo systemctl daemon-reload
sudo systemctl enable --now gns3server

echo "=== 3. Настройка пароля ==="
read -p "Введите пароль для GNS3 (для подключения с Windows): " GNS3_PASS
mkdir -p ~/.config/GNS3/3.0
cat > ~/.config/GNS3/3.0/gns3_server.conf <<EOF
[Server]
host = 0.0.0.0
port = 3080
compute_username = $USER
compute_password = $GNS3_PASS
EOF

echo "=== 4. Генерация лицензии IOU ==="
python3 generate_license.py > iourc
echo "Лицензия создана в файле: $(pwd)/iourc"
echo "Для Windows-клиента скачайте этот файл или скопируйте его содержимое."

echo "=== Готово! ==="
echo "Перезапустите сервер: sudo systemctl restart gns3server"
echo "IP вашего сервера: $(hostname -I | awk '{print $1}')"
echo "Не забудьте указать путь к iourc в настройках GNS3 (IOS on UNIX)."
