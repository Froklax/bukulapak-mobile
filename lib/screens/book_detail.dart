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