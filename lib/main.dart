import 'package:boshqa_dunyo_ostonasi/core/router/app_router.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/data/repository_impl/feedrepository_impl.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/domain/abstract/feedrepository.dart';

void main() async {
  print('+++++++++++++++++++++++Firebase connecting...');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('+++++++++++++++++++++++Firebase connected successfull!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FeedRepository repository = FeedRepositoryImpl(FirebaseFirestore.instance);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(_auth)..add(AuthStarted())),
        BlocProvider(create: (_) => HomeBloc(repository)..add(LoadFeed())),
      ],
      child: MaterialApp.router(routerConfig: appRouter, debugShowCheckedModeBanner: false),
    );
  }
}
