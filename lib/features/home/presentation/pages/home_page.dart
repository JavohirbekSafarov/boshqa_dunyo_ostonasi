import 'package:boshqa_dunyo_ostonasi/core/router/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home page'),
            backgroundColor: Colors.blueGrey,
            actions: [
              IconButton(onPressed: () {
                context.go(AppRoutes().LoginPage);
              }, icon: state is Authenticated ? Icon(Icons.logout) : Icon(Icons.login)),
            ],
          ),
          body: Column(
            children: [
              Text(state is Authenticated ? state.userId : 'Anonymous User')
            ],
          ),
        );
      },
    );
  }
}
