#!/bin/bash

# Function untuk menampilkan error dan keluar
error_exit() {
  echo -e "\n❌ \033[1;31mError:\033[0m $1" 1>&2
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  exit 1
}

# Function untuk validasi apakah Docker sudah berjalan
check_docker() {
  if ! [ -x "$(command -v docker)" ]; then
    error_exit "Docker tidak ditemukan, pastikan Docker sudah terinstal."
  fi
  
  if ! systemctl is-active --quiet docker; then
    error_exit "Docker tidak berjalan, mohon jalankan Docker terlebih dahulu."
  fi
}

# Function untuk validasi nama container
validate_container_name() {
  local name=$1
  if [[ ! $name =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error_exit "Nama container tidak valid, hanya boleh menggunakan karakter alfanumerik, garis bawah, atau tanda minus."
  fi
}

# Function untuk logging dengan styling
log_info() {
  echo -e "✅ \033[1;32mINFO:\033[0m $1"
}

# Function untuk memberikan judul bagian
log_section() {
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e " \033[1;34m$1\033[0m"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
}

# Step 1: Cek apakah Docker sudah berjalan
check_docker

# Step 2: Input nama container dari user
log_section "SETUP DOCKER CONTAINER"
read -p "➤ Masukkan nama container yang diinginkan: " container_name
validate_container_name "$container_name"

# Step 3: Validasi apakah nama container sudah digunakan
if [ "$(docker ps -aq -f name=^${container_name}$)" ]; then
  read -p "⚠ Container '$container_name' sudah ada. Apakah Anda ingin menghapus container lama? (y/n): " remove_container
  if [ "$remove_container" == "y" ]; then
    docker rm -f $container_name || error_exit "Gagal menghapus container lama."
    log_info "Container lama '$container_name' dihapus."
  else
    error_exit "Container sudah ada, hentikan script."
  fi
fi

# Step 4: Import Docker image sesuai nama container dari user
if [ ! -f devreza.tar ]; then
  error_exit "File Docker image 'devreza.tar' tidak ditemukan."
fi
import_result=$(docker import devreza.tar $container_name 2>&1) || error_exit "Gagal mengimpor Docker image."
log_info "Image Docker diimpor dengan nama '$container_name'."

# Tampilkan hasil import
echo -e "\033[1;33m$import_result\033[0m"

# Step 5: Jalankan Docker dengan port forwarding dan service restart (apache2 dan mysql)
run_result=$(docker run -d -p 3306:3306 -p 8080:80 -p 8000:8000 --name $container_name $container_name /bin/bash -c "service apache2 restart && service mysql restart && tail -f /dev/null" 2>&1) || error_exit "Gagal menjalankan container Docker."
log_info "Container '$container_name' berhasil dijalankan."

# Tampilkan hasil run container
echo -e "\033[1;33m$run_result\033[0m"

# Step 6: Input lokasi file yang ingin di-copy dari user dan validasi apakah file/direktori ada
log_section "COPY FILE KE CONTAINER"
read -p "➤ Masukkan lokasi file di local yang ingin di-copy (contoh: /home/r/github/template-lms/): " file_path
if [ ! -d "$file_path" ]; then
  error_exit "Direktori $file_path tidak ditemukan."
fi

# Step 7: Copy file ke dalam container
copy_result=$(docker cp "$file_path" "$container_name":/var/www/ 2>&1) || error_exit "Gagal menyalin file ke container Docker."
log_info "File dari '$file_path' berhasil dicopy ke '/var/www/' di container."

# Tampilkan hasil copy
echo -e "\033[1;33m$copy_result\033[0m"

# Step 8: Input lokasi file SQL dan nama database dari file SQL yang diinput user
log_section "IMPORT DATABASE"
read -p "➤ Masukkan lokasi file SQL (contoh: /home/r/github/template-lms/demo_db.sql): " sql_path
if [ ! -f "$sql_path" ]; then
  error_exit "File SQL $sql_path tidak ditemukan."
fi
if [ ! -s "$sql_path" ]; then
  error_exit "File SQL $sql_path kosong."
fi

# Step 9: Ambil nama file SQL dan buat database dengan nama file SQL sebagai database
db_name=$(basename "$sql_path" .sql)

# Step 10: Buat database dengan nama file SQL dan otomatis gunakan username root dan password p
db_result=$(docker exec -i $container_name mysql -u root -pp -e "CREATE DATABASE $db_name;" 2>&1) || error_exit "Gagal membuat database $db_name."
import_result=$(docker exec -i $container_name mysql -u root -pp $db_name < $sql_path 2>&1) || error_exit "Gagal mengimpor database $db_name."
log_info "Database '$db_name' berhasil dibuat dan diimpor."

# Step 11: Tanya apakah user ingin menjalankan Laravel
log_section "MENJALANKAN LARAVEL"
read -p "➤ Apakah Anda menggunakan Laravel? (y/n): " laravel_response
if [ "$laravel_response" == "y" ]; then
  app_dir=$(basename "$file_path")
  
  # Menjalankan Laravel menggunakan php artisan serve
  log_info "Menjalankan Laravel di folder '$app_dir'..."
  docker exec -it $container_name bash -c "cd /var/www/$app_dir && php artisan serve --host=0.0.0.0" || error_exit "Gagal menjalankan Laravel."
fi

echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "✨ \033[1;32mProses selesai.\033[0m Docker container '$container_name' telah berjalan."
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
