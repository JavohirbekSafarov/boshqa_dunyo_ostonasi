import 'package:boshqa_dunyo_ostonasi/features/shop/data/enties/book_model.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title), backgroundColor: Colors.blueGrey,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(book.coverUrl, height: 200),
            const SizedBox(height: 16),
            Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('by ${book.author}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(book.description),
          ],
        ),
      ),
    );
  }
}
