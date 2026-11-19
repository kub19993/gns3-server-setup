#!/usr/bin/env python3
import struct, hashlib, uuid

# Исправленный скрипт генерации лицензии IOU
def get_iou_key():
    # Получаем MAC-адрес
    mac = uuid.getnode()
    # Преобразуем в байты (используем беззнаковый '!L' вместо '!i', чтобы избежать ошибки)
    ioukey = (mac >> 16) & 0xFFFFFFFF
    
    # Паддинги из оригинального скрипта
    iouPad1 = b'\x0b\xad\xef\xbe\xad\xde\x0b\xad\xef\xbe\xad\xde'
    iouPad2 = b'\x0b\xad\xef\xbe\xad\xde\x0b\xad\xef\xbe\xad\xde'
    
    # Генерация хэша
    md5input = iouPad1 + iouPad2 + struct.pack('!L', ioukey) + iouPad1
    md5 = hashlib.md5(md5input).hexdigest()
    
    return md5[:16]

def main():
    import socket
    hostname = socket.gethostname()
    key = get_iou_key()
    
    print("[license]")
    print(f"{hostname} = {key};")
    print("\n# Скопируйте эти две строки в файл iourc (без решетки и текста ниже)")
    print("# Или используйте команду: python3 generate_license.py > iourc")

if __name__ == "__main__":
    main()
