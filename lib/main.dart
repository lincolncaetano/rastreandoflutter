import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Views/Login/PreLogin.dart';
import 'package:rastreando/Views/Login/SplashScreen.dart';


final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xffffffff),
    primaryTextTheme: TextTheme(
        headline1: TextStyle(color: Colors.white)
    ),
    accentColor: Color(0xffffffff),
    hintColor: Color(0xffffffff),
    appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        toolbarTextStyle: TextStyle( color: Colors.white, fontSize: 12),
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/*/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  //Admob.initialize(testDeviceIds: ['E8DF5D1106EEBA0D5478A6689879B73D']);


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }




  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ja Chegou",
        home: SplashScreen(),
        theme: temaPadrao,
        initialRoute: "/",
        onGenerateRoute: Routers.genarateRoute,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
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