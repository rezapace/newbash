#!/bin/bash

set -e

log_file="k8s_install.log"

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $log_file
}

error_exit() {
  log "ERROR: $1"
  exit 1
}

log "Memulai instalasi Kubernetes..."

log "Memperbarui sistem..."
sudo apt update && sudo apt upgrade -y || error_exit "Gagal memperbarui sistem"

log "Menginstal prasyarat..."
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y || error_exit "Gagal menginstal prasyarat"

log "Menghapus konfigurasi repositori Docker yang salah..."
sudo rm -f /etc/apt/sources.list.d/docker.list || error_exit "Gagal menghapus konfigurasi repositori Docker yang salah"
sudo rm -f /etc/apt/sources.list.d/additional-repositories.list || error_exit "Gagal menghapus konfigurasi repositori tambahan yang salah"

log "Menambahkan GPG key Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - || error_exit "Gagal menambahkan GPG key Docker"

log "Menambahkan repositori Docker yang benar..."
# Menggunakan nama kode rilis Ubuntu (misalnya, jammy untuk Ubuntu 22.04)
UBUNTU_CODENAME=$(lsb_release -cs)
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list

log "Memperbarui repositori..."
sudo apt-get update || error_exit "Gagal memperbarui repositori"

log "Menginstal Docker..."
sudo apt-get install docker-ce -y || error_exit "Gagal menginstal Docker"

log "Menambahkan user ke grup Docker..."
sudo usermod -aG docker $USER || error_exit "Gagal menambahkan user ke grup Docker"

log "Menambahkan repositori Kubernetes..."
sudo apt-get update && sudo apt-get install -y apt-transport-https curl || error_exit "Gagal menginstal prasyarat Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - || error_exit "Gagal menambahkan GPG key Kubernetes"
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

log "Memperbarui repositori..."
sudo apt-get update || error_exit "Gagal memperbarui repositori"

log "Menginstal kubeadm, kubelet, dan kubectl..."
sudo apt-get install -y kubelet kubeadm kubectl || error_exit "Gagal menginstal kubeadm, kubelet, dan kubectl"
sudo apt-mark hold kubelet kubeadm kubectl || error_exit "Gagal menahan versi kubeadm, kubelet, dan kubectl"

log "Inisialisasi klaster Kubernetes..."
sudo kubeadm init || error_exit "Gagal menginisialisasi klaster Kubernetes"

log "Mengkonfigurasi kubeconfig..."
mkdir -p $HOME/.kube || error_exit "Gagal membuat direktori .kube"
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config || error_exit "Gagal menyalin konfigurasi admin.conf"
sudo chown $(id -u):$(id -g) $HOME/.kube/config || error_exit "Gagal mengubah kepemilikan file konfigurasi"

log "Menginstal jaringan pod (Calico)..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml || error_exit "Gagal menginstal jaringan pod Calico"

log "Instalasi Kubernetes selesai. Silakan keluar dan masuk kembali untuk menerapkan perubahan grup Docker."
log "Jika Anda ingin menambahkan node worker ke klaster, jalankan perintah yang diberikan oleh output kubeadm init."

echo "Instalasi selesai. Lihat log file untuk detail: $log_file"
