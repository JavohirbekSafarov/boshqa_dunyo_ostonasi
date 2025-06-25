import 'dart:io';

import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final nameController = TextEditingController();
  String? profileImageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    //final user = context.read<AuthBloc>().state as Authenticated;
    print('+++++++++++++++++++++Ism: ${user?.displayName}');
    nameController.text = user?.displayName ?? '';
    profileImageUrl = user?.photoURL;
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(nameController.text);
    await FirebaseFirestore.instance
        .collection(AppStrings.USER_Firebase_model)
        .doc(user!.uid)
        .set({'name': nameController.text}, SetOptions(merge: true));
    if (profileImageUrl != null) {
      await user.updatePhotoURL(profileImageUrl);
    }
    await user.reload();
    setState(() => isLoading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Profil yangilandi")));
  }

  Future<void> _pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    if (user == null) return;

    final storageRef = FirebaseStorage.instance.ref().child(
      'profilePics/${user.uid}.jpg',
    );

    try {
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        profileImageUrl = downloadUrl;
      });

      // Firebase Auth profiliga rasm URL'sini ham yozish
      await user.updatePhotoURL(downloadUrl);

      await FirebaseFirestore.instance
          .collection(AppStrings.USER_Firebase_model)
          .doc(user.uid)
          .set({'photoURL': downloadUrl}, SetOptions(merge: true));
    } catch (e) {
      print('Upload failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Rasm yuklashda xatolik')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Profilni tahrirlash",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            profileImageUrl != null
                                ? NetworkImage(profileImageUrl!)
                                : null,
                        child:
                            profileImageUrl == null
                                ? const Icon(Icons.person)
                                : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Ism"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text("Saqlash"),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        textAlign: TextAlign.start,
                        "Postlar",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          // if(state is HomeLoading){

                          // } else
                          if (state is HomeLoaded) {
                            final user = FirebaseAuth.instance.currentUser;
                            final myPosts =
                                state.items
                                    .where((e) => e.authorId == user?.uid)
                                    .toList();
                            return ListView.builder(
                              itemCount: myPosts.length,
                              itemBuilder: (context, index) {
                                final item = myPosts[index];
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      title: Text(item.title),
                                      subtitle: Text(
                                        item.type ==
                                                AppStrings.PIC_Firebase_model
                                            ? 'Rasm'
                                            : 'She\'r',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context.read<HomeBloc>().add(
                                            DeleteItem(item),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const Center(
                            child: Text("Yuklangan postlar yo‘q"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
