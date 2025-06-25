import 'package:boshqa_dunyo_ostonasi/features/shop/data/enties/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final pdfUrlController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

@override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitob yuklash'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Kitob nomi'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Kitob haqida'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Titul rasm URL'),
            ),
            TextField(
              controller: pdfUrlController,
              decoration: const InputDecoration(labelText: 'PDF URL'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final book = Book(
                  id: 'id',
                  title: titleController.text,
                  author: user?.displayName ?? 'admin',
                  description: descController.text,
                  coverUrl: imageUrlController.text,
                  pdfUrl: pdfUrlController.text,
                );
                context.read<ShopBloc>().add(AddBook(book));
                Navigator.pop(context);
              },
              child: const Text('Yuklash'),
            ),
          ],
        ),
      ),
    );
  }
}
