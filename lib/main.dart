import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorite_store.dart';
import 'pages/list_page.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final loggedIn = prefs.getBool('isLoggedIn') ?? false;
  await FavoriteStore.instance.load();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Masakan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00D2BE)),
        scaffoldBackgroundColor: const Color(0xFFEFFAF9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00D2BE),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      home: loggedIn ? const ListPage() : const LoginPage(),
    );
  }
}