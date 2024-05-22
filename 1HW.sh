Bash

#!/bin/bash

LOG_FILE="directory_creation_log.txt"

# Проверяем наличие ключа "-d"
if [ "$1" = "-d" ]; then
  ROOT_DIR=$2
else
  read -p "Введите путь до корневой директории: " ROOT_DIR
fi

# Создаем лог файл или очищаем его
echo "" > $LOG_FILE

# Получаем список пользователей системы
USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

# Цикл по каждому пользователю
for USER in $USERS; do
  DIR="$ROOT_DIR/$USER"
  
  # Создаем директорию
  mkdir -p $DIR
  
  if [ -d "$DIR" ]; then
    # Устанавливаем права 755
    chmod 755 $DIR
    
    # Устанавливаем владельца директории
    chown $USER:$USER $DIR
    
    echo "Директория $DIR успешно создана" | tee -a $LOG_FILE
  else
    echo "Ошибка при создании директории $DIR" | tee -a $LOG_FILE
  fi
done
