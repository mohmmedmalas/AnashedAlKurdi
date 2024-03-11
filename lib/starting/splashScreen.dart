import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../configuration/theme.dart';
import '../../main.dart';
import '../configuration/images.dart';
import '../home/homepage.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  // GoogleSignInAccount? _currentUser;
  String _contactText = '';
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // StreamSubscription<GoogleSignInAccount?>? _subscription;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
          Navigator.pushReplacement(context, MyCustomRoute(builder: (BuildContext context) => HomePage()));
    });
  }

  @override
  void dispose() {
    // _subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final GoogleSignInAccount? user = _currentUser;
    // print("eee ${user}");
    return Scaffold(
        // appBar: AppBar(
        //     backgroundColor: Theme_Information.Primary_Color,
        //     title: Text("Login Page")
        // ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spacer(),
            SizedBox(
              height: size_H(50),
            ),
            FittedBox(child: Text("زاوية الشيخ محمد سعيد الكردي" , style: ourTextStyle(fontSize: 25 , color: Theme_Information.Color_5),)),
            // Text("تطبيق أوراد الطريقة الشاذلية" , style: ourTextStyle(fontSize: 25 , color: Theme_Information.Color_5),),

            SizedBox(
              height: size_H(5),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(ImagePath.qubah1)),
            SizedBox(
              height: size_H(10),
            ),
            CircularProgressIndicator(color: Theme_Information.Color_1,backgroundColor: Theme_Information.Primary_Color),

            SizedBox(
              height: size_H(10),
            ),


            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(ImagePath.logoMediaBlackWithLink)),
            ),

            // Text("Sponsored".trn() , style: ourTextStyle(fontSize: 20 , color: Theme_Information.Color_5),),
            // SizedBox(
            //   height: size_H(20),
            // ),
            //
            // Text("Sheikh Ismail Al-Kurdi".trn() , style: ourTextStyle( fontSize: 25, color: Theme_Information.Color_5),),

          ],
        ));
  }
}