import 'package:flutter/material.dart';
import 'package:bukulapak_mobile/models/book_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bukulapak_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:bukulapak_mobile/screens/book_detail.dart'; // Pastikan path benar

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
                    // Navigate to the detail page when tapped
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