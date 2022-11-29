import 'package:earth_quake/pages/home_page.dart';
import 'package:earth_quake/providers/earth_quake_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>EarthQuakeProvider()),
      ],
      child: const MyApp()));
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.merriweatherTextTheme(),
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) =>HomePage(),

      },
    );
  }
}
