import 'package:flutter/material.dart';
import 'package:todoe/layout/home_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        shadowColor: Colors.black12,
        accentColor: const Color(0xFFC4C4C4),
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: Color(0xFFA5A6F6),
            elevation: 10.0,
            shadowColor: Colors.black,
            titleTextStyle: TextStyle(
                fontSize: 25.0,
                fontFamily: 'quicksand',
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 20.0,
                  )
                ])),
        primaryColor: const Color(0xFFA5A6F6),
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF6A40E0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            showUnselectedLabels: false,
            selectedIconTheme: IconThemeData(size: 50.0, opacity: 0.9),
            unselectedIconTheme: IconThemeData(size: 40.0, opacity: 0.9),
            selectedLabelStyle: TextStyle(
              fontSize: 17.0,
              fontFamily: 'quicksand',
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.pink,
                  offset: Offset(2,2),
                  blurRadius: 20.0,
                )
              ],
            ),
            backgroundColor: Color(0xFFFF5C5C),
            selectedItemColor: Color(0xFF0052CD),
            unselectedItemColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
