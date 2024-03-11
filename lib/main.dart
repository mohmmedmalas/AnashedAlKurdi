import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bookapp/starting/splashScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'configuration/size_config.dart';
import 'configuration/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
SharedPreferences? loginDataHistory;

int countPrivet = 0;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  loginDataHistory = await SharedPreferences.getInstance();

  await translator.init(
    language: 'ar' ,
    languagesList: <String>['ar'],
    assetsDirectory: 'assets/langs/',
  );

  runApp(MyApp());

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


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {

      RemoteMessage? messageTemp = await FirebaseMessaging.instance.getInitialMessage();

      print("onMessageOpenedApp: $message");
      if(message.data["url"] != null){
        print("onMessageOpenedApp: ${message.data["url"]}");
        launchUrl(Uri.parse(message.data["url"]) , mode: LaunchMode.externalApplication,); // Replace with your Instagram URL
      }

       else  if(messageTemp != null && messageTemp.data["url"] != null){
        print("onMessageOpenedApp: ${messageTemp.data["url"]}");
        launchUrl(Uri.parse(messageTemp.data["url"]) , mode: LaunchMode.externalApplication,); // Replace with your Instagram URL
      }

    });

    // FirebaseMessaging.instance.getToken().then((value) {
    //   // String token = value;
    //   loginDataHistory!.setString('fcmToken', '$value');
    //   print("token = $value");
    // });

///
    Future.delayed(const Duration(seconds:1), () async {
      FirebaseMessaging.instance.getToken().then((value) async {
        loginDataHistory!.setString('fcmToken', '$value');
        FirebaseMessaging.instance.subscribeToTopic("all");
        print("token = $value");
      });
    });
///

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });



  }




  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);


    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
                // builder: EasyLoading.init(),
                localizationsDelegates: translator.delegates,
                locale: translator.activeLocale,
                debugShowCheckedModeBanner: false,
                title: 'زاوية الكردي',
                theme: ThemeData(
                  fontFamily: 'calibri',
                  backgroundColor: Theme_Information.Primary_Color,
                  // primarySwatch: Theme_Information.Primary_Color,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: SplashScreen()
             );
          },
        );
      },
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("onBackgroundMessage: $message");
    // Handle the message when the app is in the background
  }

  String? getCountryCode(BuildContext context) {
    // Use the Localizations to get the locale of the device
    Locale locale = translator.activeLocale;
    // Locale locale = Localizations.localeOf(context);

    // The country code is available in the countryCode property
    String? countryCode = locale.countryCode;
    return countryCode;
  }


  Future<String> getDeviceName() async {
    String deviceName = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
      }
    } catch (e) {
      // Handle any exceptions that might occur while fetching device info
      print('Error getting device name: $e');
    }

    return deviceName;
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

