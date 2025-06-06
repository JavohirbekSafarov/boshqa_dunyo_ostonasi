import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(AppRoutes.HomePage); // yoki kerakli route nomi
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Xush kelibsiz!')));
        } else if (state is AuthAnonymous) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Qandaydir xatolik!')));
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Wait...'),
                content: CircularProgressIndicator(),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.LOGIN_PAGE_TITLE, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.blueGrey,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'email@gmail.com',
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'password',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthWithEmailRequested(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      ),
                    );
                    // ❌ Navigator.pop(context); bu yerda bo‘lmasligi kerak
                  },
                  child: Text('Email bilan kirish'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthWithGoogleRequested());
                    // ❌ Navigator.pop(context); bu yerda ham bo‘lmasligi kerak
                  },
                  icon: Icon(Icons.login),
                  label: Text('Google bilan kirish'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
