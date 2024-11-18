# Bukulapak
Number 1 mobile bookstore in Pacil!!!

### Fast Links
- [Tugas 9](#tugas-9)
- [Tugas 8](#tugas-8)
- [Tugas 7](#tugas-7)

## Tugas 9

### Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?

Membuat model dalam Flutter untuk data JSON penting karena model mempermudah proses parsing dan _serialization_ data antara format JSON dan object Dart. Dengan model, data dapat dikelola dengan lebih terstruktur dan aman. Jika tidak membuat model terlebih dahulu, aplikasi mungkin mengalami kesulitan dalam mengakses atau memanipulasi data yang dapat menyebabkan error runtime akibat pengolahan data yang tidak tepat.

### Jelaskan fungsi dari library http yang sudah kamu implementasikan pada tugas ini.

Library `http` digunakan untuk melakukan permintaan HTTP ke server dari aplikasi Flutter. Fungsi utamanya adalah untuk mengirim permintaan seperti `GET`, `POST`, `PUT`, dan `DELETE`, serta menerima respon dari server. Dalam tugas ini, library `http` memungkinkan aplikasi berkomunikasi dengan _backend_ project Django untuk mengambil atau mengirim data.

### Jelaskan fungsi dari CookieRequest dan jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.

`CookieRequest` adalah class yang digunakan untuk mengelola permintaan HTTP yang memerlukan penyimpanan sesi menggunakan cookie. Fungsi utamanya adalah mempertahankan informasi session dan cookie antara request, yang penting untuk menjaga status _authentication_ user. Dengan membagikan instance CookieRequest ke semua komponen aplikasi Flutter, semua bagian aplikasi dapat mengakses informasi sesi yang konsisten, sehingga proses _authentication_ dan _authorization_ berjalan lancar.

### Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.

Mekanisme pengiriman data dimulai ketika user memasukkan data pada aplikasi Flutter. Data tersebut kemudian di-_serialize_ dalam format JSON, dan dikirim ke server backend Django melalui request HTTP. Backend Django memproses request tersebut, melakukan operasi yang diperlukan seperti menyimpan ke database dan kemudian mengirim response kembali ke aplikasi Flutter. Aplikasi Flutter menerima response tersebut, melakukan parsing data JSON menjadi object Dart menggunakan model, dan kemudian menampilkan data tersebut pada interface user.

### Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.

Pada mekanisme autentikasi, saat user melakukan registrasi, aplikasi Flutter mengumpulkan data akun user dan mengirimkannya ke backend Django melalui permintaan `POST`. Django menangani proses pembuatan akun baru dan mengirim response kembali ke Flutter. Untuk login, Flutter mengirim credential user ke Django, yang kemudian memverifikasi dan mengautentikasi user. Jika berhasil, Django membuat sesi dan mengirim session cookie ke Flutter, yang disimpan oleh `CookieRequest`. Saat logout, Flutter mengirim permintaan logout ke Django, yang akan mengakhiri session user. Dalam seluruh proses ini, Flutter menggunakan informasi session untuk menampilkan menu atau tampilan yang sesuai dengan status autentikasi user.

### Langkah Implementasi Checklist

1. **Fitur Registrasi Akun**

- Pertama, saya membuat fungsi register pada modul `authentication` di proyek Django. Fungsi ini yang akan digunakan untuk menangani request registrasi dari aplikasi Flutter.

```python
@csrf_exempt
def register(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data['username']
        password1 = data['password1']
        password2 = data['password2']

        # Check if the passwords match
        if password1 != password2:
            return JsonResponse({
                "status": False,
                "message": "Passwords do not match."
            }, status=400)
        
        # Check if the username is already taken
        if User.objects.filter(username=username).exists():
            return JsonResponse({
                "status": False,
                "message": "Username already exists."
            }, status=400)
        
        # Create the new user
        user = User.objects.create_user(username=username, password=password1)
        user.save()
        
        return JsonResponse({
            "username": user.username,
            "status": 'success',
            "message": "User created successfully!"
        }, status=200)
    
    else:
        return JsonResponse({
            "status": False,
            "message": "Invalid request method."
        }, status=400)
```

- Lalu, saya menambahkan routing untuk fungsi registrasi yang baru saya buat ini.

```python
from django.urls import path
from authentication.views import register

app_name = 'authentication'

urlpatterns = [
    path('register/', register, name='register'),
]
```

- Kemudian, saya membuat halaman registrasi `register.dart`. Di dalam `register.dart` terdapat form registrasi yang berisi input untuk username, password, dan konfirmasi password menggunakan `TextFormField`.

```DART
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bukulapak_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password1 = _passwordController.text;
                      String password2 = _confirmPasswordController.text;

                      // Cek kredensial
                      // Untuk menyambungkan Android emulator dengan Django pada localhost,
                      // gunakan URL http://10.0.2.2/
                      final response = await request.postJson(
                          "http://127.0.0.1:8000/auth/register/",
                          jsonEncode({
                            "username": username,
                            "password1": password1,
                            "password2": password2,
                          }));
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully registered!'),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to register!'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- Kemudian, pada file `register.dart`, digunakan package `pbp_django_auth` untuk melakukan request ke server django dan mengirim data registrasi ke endpoint Django `/auth/register/`.

```DART
final request = context.watch<CookieRequest>();
```

```DART
ElevatedButton(
  onPressed: () async {
    String username = _usernameController.text;
    String password1 = _passwordController.text;
    String password2 = _confirmPasswordController.text;

    // Cek kredensial
    final response = await request.postJson(
        "http://127.0.0.1:8000/auth/register/",
        jsonEncode({
          "username": username,
          "password1": password1,
          "password2": password2,
        }));
    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully registered!'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to register!'),
          ),
        );
      }
    }
  },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, 50),
    backgroundColor: Theme.of(context).colorScheme.primary,
    padding: const EdgeInsets.symmetric(vertical: 16.0),
  ),
),
```

2. **Membuat halaman login pada proyek tugas Flutter**

- Saya membuat file baru bernama `login.dart` yang merupakan halaman login pada proyek Flutter ini. Ini akan digunakan untuk melakukan login sesuai dengan akun yang sudah di registrasi. Sama seperti registrasi tadi, login ini menggunakan package `pbp_django_auth.dart` untuk melakukan request ke server Django.

```DART
import 'package:bukulapak_mobile/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bukulapak_mobile/screens/register.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      // Cek kredensial
                      final response = await request
                          .login("http://127.0.0.1:8000/auth/login/", {
                        'username': username,
                        'password': password,
                      });

                      if (request.loggedIn) {
                        String message = response['message'];
                        String uname = response['username'];
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  content:
                                      Text("$message Selamat datang, $uname.")),
                            );
                        }
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Gagal'),
                              content: Text(response['message']),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 36.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

3. **Mengintegrasikan sistem autentikasi Django dengan proyek tugas Flutter.**

- Saya menggunakan `Provider`untuk `CookieRequest`. Pada `main.dart`, saya contain seluruh aplikasi dengan `Provider` untuk membagikan instance `CookieRequest` ke seluruh widget.

```DART
void main() {
  runApp(
    Provider(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bukulapak Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
    );
  }
}
```

- Dengan menggunakan `Provider` dan `CookieRequest` dari package `pbp_django_auth`, aplikasi Flutter dapat mengelola sesi autentikasi dan cookie yang diperlukan untuk berkomunikasi dengan backend Django.

- `CookieRequest` memungkinkan aplikasi Flutter untuk mempertahankan session dan melakukan autentikasi pada setiap permintaan `HTTP`.

4. **Membuat model kustom sesuai dengan proyek aplikasi Django.**

- Saya membuat file baru bernama `book_entry.dart` pada folder `models` yang di dalamnya terdapat model Dart yang sesuai dengan model di Django. Saya mendapatkan ini dengan menggunakan aplikasi `QuickType` untuk mendapatkan model ini dari data JSON.

```DART
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    String pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String name;
    dynamic price;
    String description;
    int quantity;

    Fields({
        required this.user,
        required this.name,
        required this.price,
        required this.description,
        required this.quantity,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "price": price,
        "description": description,
        "quantity": quantity,
    };
}
```

5. **Membuat halaman yang berisi daftar semua item yang terdapat pada endpoint `JSON` di Django yang telah kamu deploy.**

- Saya membuat halaman yang menampilkan daftar item dari endpoint `JSON` pada file `list_bookentry.dart`. Halaman ini mengambil data produk dari endpoint `JSON` di Django dan menampilkannya dalam bentuk list.

```DART
import 'package:flutter/material.dart';
import 'package:bukulapak_mobile/models/book_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bukulapak_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:bukulapak_mobile/screens/book_detail.dart';

class BookEntryPage extends StatefulWidget {
  const BookEntryPage({super.key});

  @override
  State<BookEntryPage> createState() => _BookEntryPageState();
}

class _BookEntryPageState extends State<BookEntryPage> {
  Future<List<Product>> fetchBook(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/json/');

    // Melakukan konversi data json menjadi object Product
    List<Product> listBuku = [];
    for (var d in response) {
      if (d != null) {
        listBuku.add(Product.fromJson(d));
      }
    }
    return listBuku;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchBook(request),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada data buku pada Bukulapak.',
                  style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(product: snapshot.data![index]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black, blurRadius: 2.0, offset: Offset(0, 1))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data![index].fields.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Price: ${snapshot.data![index].fields.price}'),
                        const SizedBox(height: 10),
                        Text('Description: ${snapshot.data![index].fields.description}'),
                        const SizedBox(height: 10),
                        Text('Stock: ${snapshot.data![index].fields.quantity}'),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
```

- File ini akan Menampilkan `name`, `price`, `description`, dan `quantity` dari setiap item dalam sebuah list.

6. **Membuat halaman detail untuk setiap item yang terdapat pada halaman daftar Item.**

- Saya juga membuat file `book_detail.dart` yang akan menampilkan detail dari setiap item yang terdapat pada halaman `list_bookentry.dart`. Halaman ini dapat diakses dengan menekan item mana saja pada halaman daftar item, yang di dalamnya akan menunjukkan atribut dari setiap item.

```DART
import 'package:flutter/material.dart';
import 'package:bukulapak_mobile/models/book_entry.dart';

class BookDetailPage extends StatelessWidget {
  final Product product;

  const BookDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.fields.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.fields.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Price: ${product.fields.price}'),
            const SizedBox(height: 10),
            Text('Description: ${product.fields.description}'),
            const SizedBox(height: 10),
            Text('Stock: ${product.fields.quantity}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- Juga terdapat fitur untuk kembali ke halaman daftar item, dengan menekan button kembali. Ini akan melakukan `Navigator.pop(context)` yang akan membuat tampilan kembali ke halaman sebelumnya.

7. **Melakukan filter pada halaman daftar item dengan hanya menampilkan item yang terasosiasi dengan pengguna yang login.**

- Pada tugas Django sebelum-sebelumnya, sudah dibuah fungsi `show_json` yang memfilter buku dan hanya menampilkan buku yang terasosiasi dengan user yang login saja.

```python
def show_json(request):
    data = Product.objects.filter(user=request.user)
    return HttpResponse(serializers.serialize("json", data), content_type="application/json")

```

```python
path('json/', show_json, name='show_json'),
```

- Pada file `list_bookentry.dart`, dilakukan `HTTP` `GET` request ke endpoint Django yang berada di `http://127.0.0.1:8000/json/`. Ini merupakan path untuk fungsi `show_json` tadi, yang sudah memfilter item berdasarkan user yang login. Kemudian akan dilakukan looping melalui seluruh elemen di response, dan menggunakan `fromJson` yang akan mengubah data JSON menjadi object `Product` yang akan disimpan di `listBuku`.  

```DART
final response = await request.get('http://127.0.0.1:8000/json/');

    // Melakukan konversi data json menjadi object Product
    List<Product> listBuku = [];
    for (var d in response) {
      if (d != null) {
        listBuku.add(Product.fromJson(d));
      }
    }
    return listBuku;
```

- Dengan ini, user hanya akan melihat buku yang ditambahkan oleh diri sendiri dan tidak dapat melihat buku yang ditambahkan oleh orang lain.

8. **Mengubah README.md.**

- Terakhir, saya mengubah `README.md` yang sebelumnya telah saya buat untuk menambahkan jawaban dari pertanyaan-pertanyaan yang diberikan pada Tugas 9.

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

