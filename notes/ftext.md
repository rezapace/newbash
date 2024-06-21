# Searches for text in all files in the current folder
ftext() {
# grep: Utilitas baris perintah yang digunakan untuk mencari teks dalam file.
# -i: Melakukan pencarian tanpa mempedulikan huruf besar atau kecil (case-insensitive).
# -I: Mengabaikan file biner.
# -H: Menampilkan nama file yang cocok.
# -r: Melakukan pencarian secara rekursif dalam direktori dan subdirektori.
# -n: Menampilkan nomor baris dari hasil pencarian.
# --color=always: Menyorot teks yang cocok dengan warna.
# "$1": Teks atau pola yang dicari.
# .: Menentukan direktori saat ini sebagai tempat untuk memulai pencarian.
# | less -r: Mengalirkan output grep ke less untuk penelusuran yang lebih mudah, dengan -r menjaga urutan warna.
	grep -iIHrn --color=always "$1" . | less -r
}