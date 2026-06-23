#!/data/data/com.termux/files/usr/bin/bash

while true; do
    clear
    echo -e "\e[1;36m======================================\e[0m"
    echo -e "\e[1;34m=== RYYN PROXY CORE SYSTEM [UPDATED] ===\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    echo -e " \e[1;32m1.\e[0m Install Server Dependencies"
    echo -e " \e[1;32m2.\e[0m Start Core Server & Cloudflare Tunnel"
    echo -e " \e[1;32m3.\e[0m Kill / Stop Server Engine"
    echo -e " \e[1;32m4.\e[0m Exit"
    echo -e "\e[1;36m--------------------------------------\e[0m"
    read -p "Pilih menu [1-4]: " pilihan

    pilihan=$(echo "$pilihan" | tr -d '\r\n[:space:]')

    case "$pilihan" in
        1)
            echo -e "\n\e[1;32m[+] Menginstall Node Modules & Express...\e[0m"
            npm install express cors
            pkg install lsof cloudflared -y 2>/dev/null
            echo -e "\n\e[1;32m[+] Semua dependensi berhasil dipasang!\e[0m"
            read -p "Tekan [Enter] untuk kembali..."
            ;;
        2)
            echo -e "\n\e[1;33m[-] Membuka paksa & mengosongkan Port 3000...\e[0m"
            # MEMBUNUH PROSES BERDASARKAN PORT, BUKAN CUMA NAMA PROSES
            kill -9 $(lsof -t -i:3000) 2>/dev/null
            killall -9 node 2>/dev/null
            pkill -9 cloudflared 2>/dev/null
            sleep 1

            if [ ! -f "server.js" ]; then
                echo -e "\n\e[1;31m[!] Eror: File server.js tidak ada di folder ini!\e[0m"
                read -p "Tekan [Enter] untuk kembali..."
                continue
            fi

            echo -e "\n\e[1;32m[+] Menjalankan Server Node.js di background...\e[0m"
            node server.js &
            sleep 3
            
            echo -e "\n\e[1;36m[+] Membuka Cloudflare Tunnel Jaringan Publik...\e[0m"
            cloudflared tunnel --url http://127.0.0.1:3000
            ;;
        3)
            echo -e "\n\e[1;31m[-] Mematikan total semua proses di port 3000 & engine...\e[0m"
            kill -9 $(lsof -t -i:3000) 2>/dev/null
            killall -9 node 2>/dev/null
            pkill -9 cloudflared 2>/dev/null
            echo -e "\e[1;31m[+] Berhasil dimatikan bersih.\e[0m"
            read -p "Tekan [Enter] untuk kembali..."
            ;;
        4)
            echo -e "\n[+] Keluar dari sistem."
            exit 0
            ;;
        *)
            echo -e "\n\e[1;31m[!] Pilihan tidak valid wok!\e[0m"
            sleep 2
            ;;
    esac
done
