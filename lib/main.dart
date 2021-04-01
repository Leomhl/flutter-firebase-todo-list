import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:todolist/colors/principal_color.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todolist/screens/to_do_list_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: PrincipalGreyColor.color,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: Colors.white,
        buttonColor: Color(0xff1587f9),
      ),
      home: ToDoListPage(),
    );
  }
}
