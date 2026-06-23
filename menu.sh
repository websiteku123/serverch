#!/data/data/com.termux/files/usr/bin/bash

# Pastikan file jalan di dalam loop terus-menerus sampai user murni memilih Exit (Menu 4)
while true; do
    clear
    # WARNA INDIKATOR FIX (Cyan & Biru)
    echo -e "\e[1;36m======================================\e[0m"
    echo -e "\e[1;34m=== RYYN PROXY CORE SYSTEM [UPDATED] ===\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    echo -e " \e[1;32m1.\e[0m Install Server Dependencies"
    echo -e " \e[1;32m2.\e[0m Start Core Server & Cloudflare"
    echo -e " \e[1;32m3.\e[0m Kill / Stop Server Engine"
    echo -e " \e[1;32m4.\e[0m Exit"
    echo -e "\e[1;36m--------------------------------------\e[0m"
    read -p "Pilih menu [1-4]: " pilihan

    # Bersihkan karakter tak terlihat
    pilihan=$(echo "$pilihan" | tr -d '\r\n[:space:]')

    case "$pilihan" in
        1)
            echo -e "\n\e[1;32m[+] Menginstall Node Modules & Express...\e[0m"
            npm install express cors
            echo -e "\n\e[1;32m[+] Mengunduh binary Cloudflared untuk Termux ARM64...\e[0m"
            pkg install cloudflared -y 2>/dev/null || (wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O $PREFIX/bin/cloudflared && chmod +x $PREFIX/bin/cloudflared)
            echo -e "\n\e[1;32m[+] Semua dependensi berhasil dipasang!\e[0m"
            read -p "Tekan [Enter] untuk kembali ke menu utama..."
            ;;
        2)
            echo -e "\n\e[1;33m[-] Membersihkan sisa proses port 3000 lama...\e[0m"
            killall node 2>/dev/null
            pkill cloudflared 2>/dev/null
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
            # Selesai tunnel dimatikan user (CTRL+C), script akan otomatis loop kembali ke menu
            ;;
        3)
            echo -e "\n\e[1;31m[-] Mematikan semua proses engine node & cloudflare...\e[0m"
            killall node 2>/dev/null
            pkill cloudflared 2>/dev/null
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
