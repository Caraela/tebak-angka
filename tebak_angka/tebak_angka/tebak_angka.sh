#!/bin/bash

SCORE_FILE="skor.txt"

function tampilkan_skor() {
    if [ -f "$SCORE_FILE" ]; then
        echo ""
        echo "===== Skor Sebelumnya ====="
        cat "$SCORE_FILE"
        echo "==========================="
    fi
}

function reset_skor() {
    read -p "Apakah Anda ingin mereset skor? (y/n): " reset
    if [ "$reset" == "y" ]; then
        > "$SCORE_FILE"
        echo "Skor telah direset."
    fi
}

function satu_pemain() {
    read -p "Masukkan nama Anda: " nama

    echo ""
    echo "Pilih level kesulitan:"
    echo "1. Mudah   (1 - 10, 5 percobaan)"
    echo "2. Sedang  (1 - 50, 7 percobaan)"
    echo "3. Sulit   (1 - 100, 10 percobaan)"

    read -p "Masukkan pilihan level (1/2/3): " level

    case "$level" in
        1) batas_angka=10; max_tebakan=5; level_nama="Mudah" ;;
        2) batas_angka=50; max_tebakan=7; level_nama="Sedang" ;;
        3) batas_angka=100; max_tebakan=10; level_nama="Sulit" ;;
        *) batas_angka=100; max_tebakan=10; level_nama="Sulit" ;;
    esac

    angka_rahasia=$((RANDOM % batas_angka + 1))
    jumlah_tebakan=0
    tebakan=-1

    echo ""
    echo "Saya telah memilih angka antara 1 dan $batas_angka. Anda punya $max_tebakan percobaan."

    while [ "$tebakan" -ne "$angka_rahasia" ] && [ "$jumlah_tebakan" -lt "$max_tebakan" ]; do
        read -p "Tebakan ke-$((jumlah_tebakan + 1)): " tebakan
        ((jumlah_tebakan++))

        if ! [[ "$tebakan" =~ ^[0-9]+$ ]]; then
            echo "Masukkan angka yang valid!"
            continue
        fi

        if [ "$tebakan" -lt "$angka_rahasia" ]; then
            echo "Terlalu rendah!"
        elif [ "$tebakan" -gt "$angka_rahasia" ]; then
            echo "Terlalu tinggi!"
        else
            echo "🎉 Selamat, $nama! Anda menang dalam $jumlah_tebakan tebakan!"
            echo "$nama - $level_nama - $jumlah_tebakan tebakan - Menang" >> "$SCORE_FILE"
            return
        fi
    done

    echo "😢 Maaf, $nama. Anda kalah. Angka yang benar: $angka_rahasia"
    echo "$nama - $level_nama - $jumlah_tebakan tebakan - Kalah" >> "$SCORE_FILE"
}

function dua_pemain() {
    echo "=== MODE DUA PEMAIN ==="
    read -p "Nama Pemain 1: " pemain1
    read -p "Nama Pemain 2: " pemain2

    batas_angka=50
    max_tebakan=7
    angka_rahasia=$((RANDOM % batas_angka + 1))

    echo "Angka telah dipilih (1-$batas_angka). Pemain bergantian menebak."

    giliran=1
    jumlah_tebakan=0

    while [ "$jumlah_tebakan" -lt "$max_tebakan" ]; do
        ((jumlah_tebakan++))
        if [ $((giliran % 2)) -eq 1 ]; then
            read -p "$pemain1 (Tebakan ke-$jumlah_tebakan): " tebakan
            pemain=$pemain1
        else
            read -p "$pemain2 (Tebakan ke-$jumlah_tebakan): " tebakan
            pemain=$pemain2
        fi

        if ! [[ "$tebakan" =~ ^[0-9]+$ ]]; then
            echo "Masukkan angka yang valid!"
            continue
        fi

        if [ "$tebakan" -eq "$angka_rahasia" ]; then
            echo "🎉 $pemain menang! Angka yang benar adalah $angka_rahasia"
            echo "$pemain - Dua Pemain - $jumlah_tebakan tebakan - Menang" >> "$SCORE_FILE"
            return
        elif [ "$tebakan" -lt "$angka_rahasia" ]; then
            echo "Terlalu rendah!"
        else
            echo "Terlalu tinggi!"
        fi
        ((giliran++))
    done

    echo "😢 Tidak ada yang berhasil menebak. Angka yang benar adalah $angka_rahasia"
    echo "$pemain1 vs $pemain2 - Dua Pemain - $jumlah_tebakan tebakan - Kalah" >> "$SCORE_FILE"
}

# ======= Program Utama =======
clear
echo "=============================="
echo "     PERMAINAN TEBAK ANGKA"
echo "=============================="
tampilkan_skor
reset_skor
echo ""
echo "Pilih mode permainan:"
echo "1. Satu Pemain"
echo "2. Dua Pemain"

read -p "Pilihan (1/2): " mode

case "$mode" in
    1) satu_pemain ;;
    2) dua_pemain ;;
    *) echo "Pilihan tidak valid." ;;
esac
