import 'package:boshqa_dunyo_ostonasi/core/router/app_router.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/data/repository_impl/feedrepository_impl.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/data/repository_impl/shop_repo_impl.dart';
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
import 'features/shop/domain/abstract/shop_repository.dart';

// Adding a service locator class for better dependency management
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  ShopRepository get shopRepository => ShopRepositoryImpl(firestore);
  FeedRepository get feedRepository => FeedRepositoryImpl(firestore: firestore);
}

void main() async {
  // Ensuring widget binding initialization
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Adding error handling for Firebase initialization
    print('Initializing Firebase...');
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
    
    // Running the app
    runApp(const MyApp());
  } catch (e) {
    print('Firebase initialization failed: $e');
    // You might want to show an error screen or retry mechanism here
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using ServiceLocator for dependency injection
    final sl = ServiceLocator();

    return MultiBlocProvider(
      providers: [
        // Initializing AuthBloc with authStarted event
        BlocProvider(
          create: (_) => AuthBloc(sl.auth)..add(AuthStarted()),
        ),
        // Initializing HomeBloc with LoadFeed event
        BlocProvider(
          create: (_) => HomeBloc(sl.feedRepository)..add(LoadFeed()),
        ),
        // Initializing UploadBloc with required dependencies
        BlocProvider(
          create: (_) => UploadBloc(
            auth: sl.auth,
            firestore: sl.firestore,
            storage: sl.storage,
          ),
        ),
        // Initializing ProfileBloc
        BlocProvider(
          create: (_) => ProfileBloc(sl.auth),
        ),
        // Initializing ShopBloc with LoadBooks event
        BlocProvider(
          create: (_) => ShopBloc(sl.shopRepository)..add(LoadBooks()),
        ),
      ],
      child: MaterialApp.router(
        
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        // Optimizing theme configuration
        theme: ThemeData(
          fontFamily: 'Handlee',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey,
            brightness: Brightness.light,
          ),
          useMaterial3: true, // Enabling Material 3 for modern design
        ),
        // darkTheme: ThemeData(
        
        //   fontFamily: 'Handlee',
        //   colorScheme: ColorScheme.fromSeed(
        //     seedColor: Colors.blueGrey,
        //     brightness: Brightness.dark,
        //   ),
        //   useMaterial3: true,
        // ),
        // themeMode: ThemeMode.system, // Respecting system theme
      ),
    );
  }
}

// Adding a basic error app widget for failed initialization
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize the application.\nPlease try again later.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}