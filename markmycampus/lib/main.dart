import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import 'screens/splash_screen.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MarkMyCampusApp());
}

class MarkMyCampusApp extends StatelessWidget {
  const MarkMyCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: const MySplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.yellow,
        textTheme: GoogleFonts.lexendDecaTextTheme(Theme.of(context).textTheme),
      ),
    );
  }
}
