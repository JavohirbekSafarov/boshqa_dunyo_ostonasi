import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Profile page', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ma`lumotlar yangilandi!')));
          }
          if (state is LoggedOut) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Akkauntdan chiqildi!')));
            context.go(AppRoutes.HomePage);
          }
        },
        builder: (context, state) {
          if (state is LoggedOut) {
            return Center(child: Text('Logging out...'));
          } else if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            nameController.text = state.user.displayName ?? '';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: CircleAvatar(radius: 50, backgroundImage: NetworkImage(state.user.photoURL ?? ''))),
                  const SizedBox(height: 16),
                  Text('Email: ${state.user.email ?? "Noma'lum"}'),
                  const SizedBox(height: 16),
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Ism')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        context.read<ProfileBloc>().add(UpdateDisplayName(name));
                      }
                    },
                    child: const Text('Ismni saqlash'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(LogoutRequested());
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go(AppRoutes.ShopPage);
                    },
                    icon: const Icon(Icons.shop),
                    label: const Text('Shop Boshqaruvi'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Xatolik: ${state.message}'));
          } else {
            return const Center(child: Text('Holat noma`lum'));
          }
        },
      ),
    );
  }
}
