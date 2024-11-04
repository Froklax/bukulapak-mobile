# Bukulapak
Number 1 mobile bookstore in Pacil!!!

### Fast Links
- [Tugas 7](#tugas-7)

## Tugas 7

### Jelaskan apa yang dimaksud dengan stateless widget dan stateful widget, dan jelaskan perbedaan dari keduanya.

Stateless Widget adalah widget yang tidak memiliki "state" yang dapat berubah. Stateless widget tidak pernah berubah setelah dibuat. Stateless widget cocok untuk tampilan yang statis atau konten yang tidak memerlukan pembaruan data. Contoh dari stateless widget adalah `Icon`, `IconButton`, dan `Text`.

Stateful Widget adalah widget yang memiliki "state" dan dapat berubah-ubah. Stateful widget digunakan ketika tampilan perlu diperbarui berdasarkan data atau interaksi dari pengguna. Contohnya adalah jika ada tombol yang mengubah teks pada tampilan aplikasi, widget ini membutuhkan stateful widget untuk menangani perubahan tersebut.

Perbedaannya adalah stateless widget tidak memiliki "state" yang dapat berubah dan tampilannya tetap setelah dibuat, sedangkan stateful widget memiliki "state" yang bisa berubah, yang memungkinkan tampilannya diperbarui sesuai dengan data atau interaksi dari pengguna.

### Sebutkan widget apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya.

- __MaterialApp__: Widget utama yang _contain_ seluruh aplikasi dan mengatur tema serta navigasi.
- __ThemeData__: Menentukan tema visual aplikasi, seperti skema warna.
- __ColorScheme__: Mengatur skema warna yang digunakan dalam tema.
- __Scaffold__: Menyediakan struktur dasar halaman dengan AppBar dan body.
- __AppBar__: Menampilkan navbar aplikasi di bagian atas dengan judul.
- __Text__: Menampilkan teks pada layar.
- __Padding__: Memberikan ruang di sekitar widget.
- __Column__: Menyusun widget secara vertikal.
- __Row__: Menyusun widget secara horizontal.
- __Card__: Menampilkan kotak dengan sudut melengkung dan bayangan.
- __GridView.count__: Menampilkan widget dalam bentuk grid dengan jumlah kolom tertentu.
- __Icon__: Menampilkan _icon_ grafis.
- __InkWell__: Menangani interaksi menekan pada widget dan memberikan efek visual.
- __SnackBar__: Menampilkan pesan sementara di bagian bawah layar.
- __Material__: Menyediakan efek _material design_ seperti _ripple effect_ saat berinteraksi.

### Apa fungsi dari `setState()`? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.

Fungsi dari `setState()` adalah untuk memberitahu framework Flutter bahwa ada perubahan pada state internal suatu stateful widget, sehingga perlu dilakukan penggambaran ulang (_rebuild_) pada widget tersebut dan turunannya. Variabel yang terdampak oleh `setState()` adalah variabel yang dideklarasikan dalam _class_ `State` dan digunakan dalam metode `build()`.

###  Jelaskan perbedaan antara `const` dengan `final`.

`const`: Nilai variabel bersifat konstan dan harus diinisialisasi pada saat kompilasi (compile-time constant). Digunakan untuk nilai yang benar-benar tetap dan tidak akan pernah berubah sepanjang masa eksekusi program.

`final`: Nilai variabel hanya dapat ditetapkan sekali dan bisa diinisialisasi pada saat runtime. Digunakan untuk nilai yang tidak akan berubah setelah diinisialisasi, tetapi nilainya mungkin tidak diketahui pada saat kompilasi.

### Langkah Implementasi Checklist

