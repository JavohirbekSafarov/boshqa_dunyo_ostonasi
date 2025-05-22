import 'package:boshqa_dunyo_ostonasi/core/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  print('+++++++++++++++++++++++Firebase connecting...');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('+++++++++++++++++++++++Firebase connected successfull!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc(_auth)..add(AuthStarted()))],
      child: MaterialApp.router(routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      )
    );
  }
}
