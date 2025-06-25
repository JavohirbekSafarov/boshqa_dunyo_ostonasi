import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/profile/domain/entities/profile_menu_model.dart';
import 'package:boshqa_dunyo_ostonasi/features/profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  late List<Menu> menuItems = [];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile());
    menuItems = [
      Menu('Profil', 'Profilni tahrirlash', Icon(LineIcons.userEdit), () {
        context.push(AppRoutes.ProfileEditPage);
      }),
      Menu('Kutubxona', 'Kitoblarni ko\'rish', Icon(LineIcons.book), () {
        context.push(AppRoutes.ShopPage);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              title: Text(
                AppStrings.PROFILE_PAGE_TITLE,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.blueGrey,
              actions: [
                IconButton(
                  icon: Icon(LineIcons.doorOpen, color: Colors.white),
                  onPressed: () {
                    context.read<ProfileBloc>().add(LogoutRequested());
                  },
                ),
              ],
            ),
            body: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ma`lumotlar yangilandi!')),
                  );
                }
                if (state is LoggedOut) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Akkauntdan chiqildi!')),
                  );
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
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CachedNetworkImage(
                                imageUrl: state.user.photoURL ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Center(
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: Image.asset(
                                        'assets/images/loading.gif',
                                      ),
                                    ),
                                  );
                                },
                                errorWidget:
                                    (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        /*  const SizedBox(height: 16),
                        TextField(controller: nameController, decoration: InputDecoration(labelText: 'Ism')),*/
                        const SizedBox(height: 16),
                        Text(
                          state.user.displayName ?? "Noma'lum",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Email: ${state.user.email ?? "Noma'lum"}'),
                        const SizedBox(height: 16),
                        /* ElevatedButton(
                          onPressed: () {
                            final name = nameController.text.trim();
                            if (name.isNotEmpty) {
                              context.read<ProfileBloc>().add(UpdateDisplayName(name));
                            }
                          },
                          child: const Text('Ismni saqlash'),
                        ),*/
                        /*   const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.push(AppRoutes.ShopPage);
                          },
                          icon: const Icon(Icons.shop),
                          label: const Text('Shop Boshqaruvi'),
                        ),*/
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView.builder(
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) {
                              var item = menuItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,

                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: item.onTap,
                                    child: ListTile(
                                      title: Text(item.title),
                                      subtitle: Text(
                                        item.subtitle,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(
                                        item.icon.icon,
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
        } else {
          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            body: Center(
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
                          child: Text(
                            'Profilni ko\'rish uchun akkauntga kiring!',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            context.go(AppRoutes.LoginPage);
                          },
                          child: Text(
                            "Kirish",
                            style: TextStyle(color: Colors.black),
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
      },
    );
  }
}
