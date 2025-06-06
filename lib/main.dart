import 'package:boshqa_dunyo_ostonasi/core/router/app_router.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/data/repository_impl/feedrepository_impl.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/domain/abstract/shop_repository.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/upload/presentation/bloc/bloc/upload_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/domain/abstract/feedrepository.dart';
import 'features/shop/data/repository_impl/shop_repo_impl.dart';

void main() async {
  print('+++++++++++++++++++++++Firebase connecting...');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('+++++++++++++++++++++++Firebase connected successfull!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late final ShopRepository shopRepository = ShopRepositoryImpl(FirebaseFirestore.instance);
  late final FeedRepository repository = FeedRepositoryImpl(
    firestore: FirebaseFirestore.instance,
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(_auth)..add(AuthStarted())),
        BlocProvider(create: (_) => HomeBloc(repository)..add(LoadFeed())),
        BlocProvider(
          create:
              (_) => UploadBloc(
                auth: _auth,
                firestore: _firebaseFirestore,
                storage: _firebaseStorage,
              ),
        ),
        BlocProvider(create: (_) => ProfileBloc(_auth)),
        BlocProvider(create: (_) => ShopBloc(shopRepository)..add(LoadBooks()))
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Handlee', colorSchemeSeed: Colors.blueGrey),
      ),
    );
  }
}
