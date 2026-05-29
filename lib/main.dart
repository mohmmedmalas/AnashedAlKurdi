import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nasheedapp/provider.dart';

import 'package:nasheedapp/starting/splashScreen.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import 'configuration/size_config.dart';
import 'configuration/theme.dart';
import 'contant/pdfViewerPage.dart';
import 'model/generalFireBaseList.dart';


//   /Users/mohmmed/Desktop/flutter_3.24.0/bin/flutter pub add firebase_auth




final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

SharedPreferences? loginDataHistory;

int countPrivet = 0;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  loginDataHistory = await SharedPreferences.getInstance();

  await LocalizeAndTranslate.init(
    assetLoader: const AssetLoaderRootBundleJson('assets/lang'),
    supportedLanguageCodes: const <String>['ar', 'en'],
  );

  //
  // runApp(MyApp());

  runApp(
    ChangeNotifierProvider(
      create: (_) => ActiveFileService(),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging? _messaging ;


  @override
  void initState() {
    super.initState();
    registerNotification();
    try{
      FirebaseMessaging.instance.requestPermission();
    } catch(e){
      print("e = $e");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      // Handle the message when the app is in the foreground
    });


///
///


  }







  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
                // builder: EasyLoading.init(),
                scaffoldMessengerKey: rootScaffoldMessengerKey,
                localizationsDelegates: context.delegates,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                title: 'زاوية الكردي',
                theme: ThemeData(
                  fontFamily: 'calibri',
                  scaffoldBackgroundColor: Theme_Information.Color_1,

                  // primarySwatch: Theme_Information.Primary_Color,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              // home: StreamBuilder<GeneralFireBaseList?>(
              //   stream: activeFileStream(),
              //   builder: (context, snapshot) {
              //     final activeFile = snapshot.data;
              //
              //     return Stack(
              //       children: [
              //         SplashScreen(), // or your main home screen widget
              //
              //         // Show popup overlay only if we have an active file
              //         if (activeFile != null)
              //           ActiveFilePopup(pdfFile: activeFile),
              //       ],
              //     );
              //   },
              // ),
///
    home: SplashScreen(),
             );
          },
        );
      },
    );
  ///


  }

  // Stream<GeneralFireBaseList?> activeFileStream() {
  //   return FirebaseFirestore.instance
  //       .collection('ActiveFiles')
  //       .doc('current')
  //       .snapshots()
  //       .map((snapshot) {
  //     if (snapshot.exists && snapshot.data() != null) {
  //       return GeneralFireBaseList.fromMap(snapshot.data()!);
  //     }
  //     return null;
  //   });
  // }


  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("onBackgroundMessage: $message");
    // Handle the message when the app is in the background
  }

  String? getCountryCode(BuildContext context) {
    // Use the Localizations to get the locale of the device
    Locale locale = context.locale;
    // Locale locale = Localizations.localeOf(context);

    // The country code is available in the countryCode property
    String? countryCode = locale.countryCode;
    return countryCode;
  }




  void saveDataToFirebase({required String token,required String deviceName,required String countryCode}) {
    // String token = 'your_token_here'; // Replace this with the actual token
    // String deviceName = 'your_device_name_here'; // Replace this with the actual device name
    CollectionReference devicesCollection = FirebaseFirestore.instance.collection('devices');

    // Create a new document with a unique ID
    devicesCollection.add({
      'token': token,
      'device_name': deviceName,
      'country_code': countryCode,
      // You can add more fields if needed
    }).then((value) {
      print('Token and Device Name saved to Firestore!');
    }).catchError((error) {
      print('Failed to save Token and Device Name: $error');
    });
  }



  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();

      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

}

