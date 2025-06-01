import 'dart:io';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/upload/presentation/bloc/bloc/upload_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isPoem = true; // true = poem, false = pic
  XFile? image;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = picked);
    }
  }

  void _upload() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (isPoem && (title.isEmpty || content.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("She’r ma’lumotlari to‘liq emas")));
      return;
    }

    if (!isPoem && image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Rasm tanlanmagan")));
      return;
    }

    context.read<UploadBloc>().add(
      UploadRequested(
        isPoem: isPoem,
        title: title,
        content: content,
        image: image != null ? File(image!.path) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Yuklash",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => isPoem = !isPoem),
            child: Text(
              isPoem ? "Rasm yuklash" : "She’r yuklash",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocConsumer<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Muvaffaqiyatli yuklandi")));
            titleController.clear();
            contentController.clear();
            setState(() => image = null);
            context.read<HomeBloc>().add(RefreshFeed());
            context.go(AppRoutes.HomePage);
          } else if (state is UploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Xatolik: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          return context.read<AuthBloc>().state is Authenticated
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Sarlavha"),
                    ),
                    if (isPoem)
                      TextField(
                        controller: contentController,
                        decoration: InputDecoration(labelText: "Matn"),
                        minLines: 6,
                        maxLines: 11,
                      ),
                    if (!isPoem)
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: pickImage,
                            icon: Icon(Icons.image),
                            label: Text("Rasm tanlash"),
                          ),
                          if (image != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(File(image!.path), height: 200),
                            ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    state is UploadLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _upload,
                          child: Text("Yuklash"),
                        ),
                  ],
                ),
              )
              : Center(
                child: Card(
                  color: Colors.white,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Text('Yuklash uchun akkauntga kiring!'),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              context.go(AppRoutes.LoginPage);
                            },
                            child: Text("Kirish"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
        },
      ),
    );
  }
}
