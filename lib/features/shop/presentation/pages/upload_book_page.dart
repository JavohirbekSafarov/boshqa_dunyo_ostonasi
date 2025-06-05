import 'package:boshqa_dunyo_ostonasi/features/shop/data/enties/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/shop_bloc.dart';

class UploadBookPage extends StatefulWidget {
  const UploadBookPage({super.key});

  @override
  State<UploadBookPage> createState() => _UploadBookPageState();
}

class _UploadBookPageState extends State<UploadBookPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book'), backgroundColor: Colors.blueGrey,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final book = Book(
                  id: 'id',
                  title: titleController.text,
                  author: 'authr',
                  description: descController.text,
                  coverUrl: imageUrlController.text,
                  pdfUrl: 'pdf url'
                );
                context.read<ShopBloc>().add(AddBook(book));
                Navigator.pop(context);
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
