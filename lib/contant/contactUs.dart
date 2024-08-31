import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import 'package:bookapp/configuration/theme.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../commenwidget/boxesHomeOneLine.dart';
import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';
import 'licensesTime.dart';

class ContactUS extends StatefulWidget {
  const ContactUS({Key? key}) : super(key: key);

  @override
  State<ContactUS> createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        leadingWidget: SizedBox(),
        title: "Contact US".trn(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // BoxWidgetLine(
            //   box: Boxes(
            //     name: "contact us 1".trn(),
            //     onTap: () {
            //       onTap();
            //     },
            //
            //   ),
            // ),
            ///
            // SizedBox(height: size_H(20)),

            BoxWidgetLine(
              box: Boxes(
                name: "contact us 2".trn(),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MyCustomRoute(
                          builder: (BuildContext context) => LicensesTime()));
                },

              ),
            ),
            SizedBox(height: size_H(20)),

            BoxWidgetLine(
              box: Boxes(
                name: "لدي طلب آخر".trn(),
                onTap: () async {
                  await openmessenger();

                },

              ),
            ),

            // SizedBox(height: size_H(20)),
            //
            // BoxWidgetLine(
            //   box: Boxes(
            //     name: "مشاركة التطبيق" ,
            //     onTap: () {
            //       shareApplication();
            //       // launch('https://m.me/SheikhIsmailAlKurdi'); // Replace {USER_ID} with the recipient's user ID or username
            //
            //     },
            //
            //   ),
            // ),


            SizedBox(height: size_H(30)),

            Text("${"Connect with us on social media platforms".trn()}",
                textAlign: TextAlign.center,
                style: ourTextStyle()),

            SizedBox(height: size_H(30)),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: size_W(120),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Replace with your desired color
            //         ),
            //         onPressed: () {
            //           launch('https://web.facebook.com/SheikhIsmailAlKurdi'); // Replace with your Facebook URL
            //         },
            //         child: Text('Facebook'.trn(), style:  ourTextStyle(color: Theme_Information.Color_1)),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     Container(
            //       width: size_W(120),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Replace with your desired color
            //         ),
            //         onPressed: () {
            //           launch('https://www.youtube.com/channel/UCwZp7VAAO7Ixi-HE4PodMkg'); // Replace with your YouTube URL
            //         },
            //         child: Text('YouTube'.trn(), style:  ourTextStyle(color: Theme_Information.Color_1)),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: size_W(120),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Replace with your desired color
            //         ),
            //         onPressed: () {
            //           launch('https://soundcloud.com/ismail-alkurdi'); // Replace with your SoundCloud URL
            //         },
            //         child: Text('SoundCloud'.trn(), style:  ourTextStyle(color: Theme_Information.Color_1)),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     Container(
            //       width: size_W(120),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Replace with your desired color
            //         ),
            //         onPressed: () {
            //           launch('https://www.instagram.com/SheikhIsmailAlKurdi/'); // Replace with your Instagram URL
            //         },
            //         child: Text('Instagram'.trn() , style:  ourTextStyle(color: Theme_Information.Color_1)),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //   ],
            // ),
///
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(Theme_Information.Primary_Color), // Replace with your desired color
//               ),
//               onPressed: () {
//                 launch('https://m.me/SheikhIsmailAlKurdi'); // Replace {USER_ID} with the recipient's user ID or username
//               },
//               child: Text('للتواصل مباشرة مع الشيخ اسماعيل الكردي'   , style:  ourTextStyle(color: Theme_Information.Color_1)),
//             ),

            // SizedBox(height: size_H(30)),

            Image.asset(ImagePath.logoMediaBlack,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                InkWell(
                  onTap: () {
                    launchUrl(Uri.parse('https://www.instagram.com/SheikhIsmailAlKurdi/') , mode: LaunchMode.externalApplication,); // Replace with your Instagram URL



                  },
                  child: Image.asset(ImagePath.instgram),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    // launch('https://web.facebook.com/SheikhIsmailAlKurdi'); // Replace with your Facebook URL


                    final String facebookUrlScheme = 'fb://profile/100052831813876'; // Replace 'your_facebook_id' with the actual ID or username

                    try {
                      bool launched = await launchUrl(Uri.parse(facebookUrlScheme));
                      if (!launched) {
                        // If the app is not installed, open the web browser
                        await launchUrl(Uri.parse('https://www.facebook.com/100052831813876') , mode: LaunchMode.externalApplication,); // Replace 'your_facebook_id' with the actual ID or username
                      }
                    } catch (e) {
                      // Handle error
                      print(e.toString());
                    }

                  },
                  child: Image.asset(ImagePath.facebook),
                ),
                SizedBox(width: 10),

                InkWell(
                  onTap: () async {
                    // print(await canLaunchUrl(Uri.parse("twitter://user?screen_name=IsmailAlKurdii")));
                    // print(await canLaunchUrl(Uri.parse("https://twitter.com/IsmailAlKurdii/")));
                    // launch("twitter://user?screen_name=IsmailAlKurdii") ;

                    if (await canLaunchUrl(Uri.parse("twitter://user?screen_name=IsmailAlKurdii"))) {
                    // If the Twitter app is installed, open the profile in the app
                    await launchUrl(Uri.parse("twitter://user?screen_name=IsmailAlKurdii")  , mode: LaunchMode.externalApplication,);
                    } else {
                    // If the Twitter app is not installed, open the profile in the web browser
                    await launchUrl(Uri.parse("https://twitter.com/IsmailAlKurdii/") , mode: LaunchMode.externalApplication,);
                    }
                    // launch('https://twitter.com/IsmailAlKurdii/'); // Replace with your Instagram URL
                  },
                  child: Image.asset(ImagePath.twitter),
                ),

                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    launchUrl(Uri.parse('https://www.youtube.com/channel/UCwZp7VAAO7Ixi-HE4PodMkg') , mode: LaunchMode.externalApplication,); // Replace with your YouTube URL
                  },
                  child: Image.asset(ImagePath.youtube),
                ),
                SizedBox(width: 10),

                InkWell(
                  onTap: () {
                    launchUrl(Uri.parse('https://www.tiktok.com/SheikhIsmailAlKurdi/') , mode: LaunchMode.externalApplication,); // Replace with your Instagram URL


                    // final String tiktokUsername = 'YOUR_TIKTOK_USERNAME';
                    // final String tiktokUrlScheme = 'tiktok://user/@$tiktokUsername';
                    // final String tiktokWebUrl = 'https://www.tiktok.com/@$tiktokUsername';
                    //
                    // if (await canLaunch(tiktokUrlScheme)) {
                    // await launch(tiktokUrlScheme);
                    // } else {
                    // await launch(tiktokWebUrl);
                    // }

                  },
                  child: Image.asset(ImagePath.tiktok),
                ),
              ],
            ),
            // Image.asset(ImagePath.qubah3 , height: size_H(200),)
          ],
        ),
      ),
    );
  }




  void shareApplication() {


    var urlst = "" ;
    if (Platform.isAndroid) {
      urlst = "https://play.google.com/store/apps/details?id=com.kurdi.sheikhismailalkurdi";
    } else if (Platform.isIOS) {
      // urlst = "https://apps.apple.com/app//6456609292";
    }
    if(urlst != "")
      // launchUrl(
      //   Uri.parse(urlst),
      //   mode: LaunchMode.externalApplication,
      // );

    Share.share(urlst);


    //
  }

 onTap(){
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return Directionality(
         textDirection: TextDirection.rtl,
         child: AlertDialog(
           content: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 'لسلوك طريقة تربية النفس وتهذيبها تحقيقا لكمال العبودية لله مع الالتزام بالاوراد اليومية بالجد و الاجتهاد والمحافظة على اعمال الخير و الاستقامة على امر الله وتعظيم للشريعة المطهرة و السنة النبوية المعظمة بتوجيه من فضيلة الشيخ المربي اسماعيل الكردي كما اخذها عن شيوخه بالسند المتصل لرسول الله صلى الله عليه وسلم و المسماه الطريقة الشاذلية.',
                 style: ourTextStyle(),
               ),
               ///
               // SizedBox(height: 10),
               ///
               GestureDetector(
                 onTap: () async {
                   // launch('https://bit.ly/3QhnaiX');
                   await openmessenger();


                 },
                 child: Text(
                   'يرجى الضغط هنا والتواصل مع صفحة الفيس بوك لأخذ الطريقة',
                   // 'يرجى الضغط هنا وتعبئة المعلومات المطلوبة لاخذ الطريقة',
                   // style: TextStyle(
                   //   fontSize: 16,
                   //   color: Colors.blue,
                   //   decoration: TextDecoration.underline,
                   // ),
                   style: ourTextStyle(color: Colors.blue,),
                 ),
               ),
             ],
           ),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text('Close'.trn() , style: ourTextStyle()),
             ),
           ],
         ),
       );
     },
   );
 }

 Future<void> openmessenger() async {
   if(Platform.isAndroid){
     launch('https://m.me/SheikhIsmailAlKurdi'); // Replace {USER_ID} with the recipient's user ID or username

   } else {
     final String facebookUrlScheme = 'fb://profile/100052831813876'; // Replace 'your_facebook_id' with the actual ID or username

     try {
       bool launched = await launchUrl(Uri.parse(facebookUrlScheme));
       if (!launched) {
         // If the app is not installed, open the web browser
         await launchUrl(Uri.parse('https://www.facebook.com/100052831813876') , mode: LaunchMode.externalApplication,); // Replace 'your_facebook_id' with the actual ID or username
       }
     } catch (e) {
       // Handle error
       print(e.toString());
     }
   }
 }



}
