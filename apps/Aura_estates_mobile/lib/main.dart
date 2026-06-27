import 'package:aura_estates/core/router/router.dart';
import 'package:aura_estates/core/storage/hive_registrar.g.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:aura_estates/features/properties/data/models/user_data.dart';
import 'package:aura_estates/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<UserData>('user_data');
  runApp(ProviderScope(child: AuraEstatesApp()));
}

class AuraEstatesApp extends StatelessWidget {
  const AuraEstatesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Aura Estates',
      themeMode: ThemeMode.dark, //forcerDarkMode
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
