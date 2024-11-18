# Bukulapak
Number 1 mobile bookstore in Pacil!!!

### Fast Links
- [Tugas 8](#tugas-8)
- [Tugas 7](#tugas-7)

## Tugas 9

### Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?

### Jelaskan fungsi dari library http yang sudah kamu implementasikan pada tugas ini

### Jelaskan fungsi dari CookieRequest dan jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.

### Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter

### Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.

### Langkah Implementasi Checklist


## Tugas 8

### Apa kegunaan const di Flutter? Jelaskan apa keuntungan ketika menggunakan const pada kode Flutter. Kapan sebaiknya kita menggunakan const, dan kapan sebaiknya tidak digunakan?

`const` digunakan untuk mendefinisikan nilai dan widget yang bersifat _constant_ pada waktu kompilasi. `const` hanya dibuat sekali dan dapat di-_share_, sehingga mengurangi penggunaan memori dan meningkatkan performa aplikasi. `const` juga menjamin bahwa nilai atau widget tidak akan berubah selama _runtime_, sehingga mengurangi kemungkinan ada bug dan menghindari rebuild pada widget karena sudah diketahui tidak berubah.

### Jelaskan dan bandingkan penggunaan Column dan Row pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!

`Column` dan `Row` adalah widget layout yang digunakan untuk menyusun _child_ dari widget.

- `Column`: Menyusun widget secara vertikal (dari atas ke bawah).

```DART
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Text('Item Pertama'),
    Text('Item Kedua'),
    Text('Item Ketiga'),
  ],
)
```

- `Row`: Menyusun widget secara horizontal (dari kiri ke kanan). 

```DART
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    InfoCard(title: 'NPM', content: npm),
    InfoCard(title: 'Name', content: name),
    InfoCard(title: 'Class', content: className),
  ],
),
```

Perbedaannya adalah arah penyusunan child widget. Column secara vertikal, sedangkan Row secara horizontal.

### Sebutkan apa saja elemen input yang kamu gunakan pada halaman form yang kamu buat pada tugas kali ini. Apakah terdapat elemen input Flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!

Pada halaman form yang saya dibuat, elemen input yang digunakan adalah:

- `TextFormField`: Digunakan untuk input _name_, _price_, _description_, dan _stock_.
- `ElevatedButton`: Digunakan sebagai tombol untuk menyimpan data yang telah diinput.

Elemen Flutter lain yang saya tidak digunakan pada tugas kali ini:

- `Checkbox`: Untuk input pilihan iya atau tidak.
- `Radio`: Untuk memilih satu opsi dari beberapa pilihan.
- `Switch`: Untuk toggle keadaan aktif/non-aktif.
- `Slider`: Untuk memilih nilai dalam _range_ tertentu.
- `DropdownButtonFormField`: Untuk menampilkan daftar pilihan dalam bentuk _dropdown_.
- `DatePicker`: Untuk memilih tanggal.
- `TimePicker`: Untuk memilih waktu.
- `File Picker`: Untuk mengunggah file atau gamba

### Bagaimana cara kamu mengatur tema (theme) dalam aplikasi Flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?

Saya mengatur tema dengan menggunakan `ThemeData` pada `MaterialApp` di `main.dart`.

```DART
theme: ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
  ).copyWith(secondary: Colors.deepPurple[400]),
  useMaterial3: true,
),
```

Dengan menetapkan `colorScheme`, semua widget yang menggunakan warna tema akan secara otomatis mengikuti skema warna yang ditentukan yang membuat konsistensi tampilan aplikasi terjaga. Saya mengimplementasikan tema pada aplikasi yang dibuat dengan mendefinisikan `ThemeData` dan menerapkannya ke `MaterialApp`.

### Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada Flutter?

Untuk menangani navigasi dalam aplikasi Flutter dengan banyak halaman, saya menggunakan class `Navigator` dengan _method_ `push`, `pop`, dan `pushReplacement`.

`Navigator.push` digunakan untuk menambahkan route (halaman) baru ke atas stack navigasi, sehingga membuka halaman baru tanpa menutup halaman sebelumnya.

Contoh dari file `left_drawer.dart`:

Ketika pengguna memilih menu "Tambah Produk" pada drawer, aplikasi akan menavigasi ke halaman form tambah buku dengan menggunakan `Navigator.push`:
```DART
ListTile(
  leading: const Icon(Icons.add),
  title: const Text('Tambah Produk'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookEntryFormPage()),
    );
  },
),
```
Di sini, saat `ListTile` ditekan, `Navigator.push` akan menambahkan route baru ke stack dan menampilkan `BookEntryFormPage`.

`Navigator.pop` digunakan untuk menghapus route teratas dari stack navigasi, sehingga kembali ke halaman sebelumnya.

Contoh dari file `bookentry_form.dart`:

Setelah pengguna menekan tombol "OK" pada pop-up berisi data yang diinput form, aplikasi akan kembali ke halaman sebelumnya menggunakan `Navigator.pop`:

```DART
TextButton(
  child: const Text('OK'),
  onPressed: () {
    Navigator.pop(context); // Menutup pop-up
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  },
),
```
Pemanggilan `Navigator.pop(context)` pertama menutup pop-up, dan pemanggilan kedua kembali ke halaman sebelumnya.

`Navigator.pushReplacement` menggantikan route saat ini dengan route baru tanpa menambah ukuran stack navigasi. Halaman sebelumnya akan digantikan oleh halaman baru.

Misalkan pada aplikasi terdapat fitur logout yang ingin langsung menavigasi pengguna ke halaman login dan tidak memungkinkan kembali ke halaman sebelumnya:

```DART
ListTile(
  leading: const Icon(Icons.logout),
  title: const Text('Logout'),
  onTap: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  },
),
```
Dengan menggunakan `Navigator.pushReplacement`, halaman saat ini digantikan oleh `LoginPage` dan halaman sebelumnya dihapus dari stack navigasi. Ini berarti pengguna tidak dapat kembali ke halaman sebelumnya menggunakan tombol back.

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

1. **Membuat program Flutter baru.**
- Pertama, saya membuat program flutter baru bernama `bukulapak_mobile` dengan menjalankan perintah `flutter create bukulapak_mobile`. Perintah ini akan membuat proyek Flutter baru yang berisi struktur dasar aplikasi, termasuk folder `lib`, `android`, `ios`, dan file konfigurasi lainnya.

2. **Membuat tiga tombol sederhana dengan ikon dan teks.**
- Kemudian, Saya membuat file baru bernama `menu.dart` di dalam folder `lib` untuk menjaga kerapihan kode.
- Di dalam `menu.dart`, saya mendefinisikan _class_ `ItemHomepage` untuk merepresentasikan item pada halaman utama:

```DART
class ItemHomepage {
    final String name;
    final IconData icon;
    final Color color;

    ItemHomepage(this.name, this.icon, this.color);
}
```

- _class_ ini memiliki properti name, icon, dan color untuk menyimpan informasi tentang setiap tombol.

- Saya juga membuat _class_ `ItemCard` yang merupakan `StatelessWidget` untuk menampilkan kartu dengan ikon dan nama:

```DART
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}")),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- Kemudian, dalam `menu.dart`, saya membuat _class_ `MyHomePage` yang merupakan `StatelessWidget` dan berfungsi sebagai halaman utama. Di dalamnya, saya mendefinisikan list items yang berisi tiga _instance_ `ItemHomepage` dengan ketentuan:

```DART
final List<ItemHomepage> items = [
  ItemHomepage("Lihat Daftar Produk", Icons.menu, Colors.blue),
  ItemHomepage("Tambah Produk", Icons.add, Colors.orange),
  ItemHomepage("Logout", Icons.logout, Colors.red),
];
```
- Setiap item merepresentasikan tombol yang akan ditampilkan dengan icon dan warna yang berbeda.

3. **Mengimplementasikan warna-warna yang berbeda untuk setiap tombol.**

- Pertama untuk dapat mengatur warna berbeda pada setiap tombol, saya menambahkan atribut color pada _class_ ItemHomepage. 

```DART
class ItemHomepage {
    final String name;
    final IconData icon;
    final Color color;

    ItemHomepage(this.name, this.icon, this.color);
}
```
- Atribut color berfungsi untuk menyimpan informasi warna yang akan digunakan oleh setiap instance ItemHomepage.

- Selanjutnya, saya mendefinisikan list items dan menetapkan warna yang berbeda untuk setiap item:

```DART
final List<ItemHomepage> items = [
  ItemHomepage("Lihat Daftar Produk", Icons.menu, Colors.blue),
  ItemHomepage("Tambah Produk", Icons.add, Colors.orange),
  ItemHomepage("Logout", Icons.logout, Colors.red),
];
```

- Warna-warna tersebut ditentukan menggunakan konstanta warna yang tersedia di Flutter, seperti `Colors.blue`, `Colors.orange`, dan `Colors.red`.

- Terakhir, saya menggunakan atribut color dalam widget `ItemCard`. Dalam _class_ `ItemCard`, saya menggunakan `item.color` untuk menentukan warna tombol:

```DART
Material(
  // Menentukan warna latar belakang dari tombol.
  color: item.color,
  borderRadius: BorderRadius.circular(12),
  child: InkWell(
    // ...
  ),
);
```

4. **Memunculkan Snackbar dengan tulisan tertentu saat tombol ditekan.**

- Di dalam class `ItemCard`, saya membungkus konten card dengan widget `InkWell` dan menambahkan fungsi `onTap`:

```DART
InkWell(
  onTap: () {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("Kamu telah menekan tombol ${item.name}"))
      );
  },
  child: ...
)    
```

- Ketika tombol ditekan, `SnackBar` akan muncul di bagian bawah layar dengan pesan yang sesuai dengan nama tombol yang ditekan.

5. **Mengubah README.md.**
- Terakhir, saya mengubah `README.md` yang sebelumnya telah saya buat untuk menambahkan jawaban dari pertanyaan-pertanyaan yang diberikan pada Tugas 7.

