import 'package:barcode_scanner/login_page.dart';
import 'package:barcode_scanner/spreadsheet_select.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/spreadsheet_select': (context) => const SpreadSheetSelect(),
        '/login_page': (context) => LoginPage(),
      },
    );
  }
}
