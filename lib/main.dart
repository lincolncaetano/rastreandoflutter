import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Views/Login/PreLogin.dart';


final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff937d56),
    primaryTextTheme: TextTheme(
        headline1: TextStyle(color: Colors.white)
    ),
    accentColor: Color(0xffffffff),
    hintColor: Color(0xffffffff),
    appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,toolbarTextStyle: TextStyle( color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
            color: Colors.white
        )
      //backgroundColor: Color(0xff2d2d3a)
    ),
    scaffoldBackgroundColor: Palleta.body2
);

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  Admob.initialize();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rastreando",
        home: PreLogin(),
        theme: temaPadrao,
        initialRoute: "/",
        onGenerateRoute: Routers.genarateRoute,
      )
  );

}

ThemeData buildTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    hintColor: Colors.white,
    primaryColor: Colors.white,
  );
}