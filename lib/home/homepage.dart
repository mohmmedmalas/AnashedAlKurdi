import 'dart:io';

import 'package:bookapp/configuration/images.dart';
import 'package:bookapp/model/dhikrItemsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';

import '../commenwidget/boxesHome.dart';
import '../commenwidget/boxesHomeOneLine.dart';
import '../commenwidget/customAppBar.dart';
import '../commenwidget/imageSlider.dart';
import '../configuration/theme.dart';
import '../contant/awradAndZker.dart';
import '../contant/beadsCounterPage.dart';
import '../contant/beadsPrivetCounterPage.dart';
import '../contant/contactUs.dart';
import '../contant/files.dart';
import '../contant/filesBurda.dart';
import '../contant/filesMauled.dart';
import '../contant/filesYoutube.dart';
import '../contant/licensesTime.dart';
import '../contant/pdfViewerPage.dart';
// import '../model.dart';
// import '../contant/pdfViewerPageMix.dart';
// import '../pages/pages/newIamge.dart';
// import '../pages/renewBox/RequestBulkFromBoxes.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<DhikrItems> data = [] ;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    fetchDataFromFirestore();

  }

  // void newApp(title , image){
  //   /// NewPAge
  //   Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NewPAge(title:title ,  image: image,)));
  //
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        leadingWidget: SizedBox(),
        title: "Home Page".trn(),
        // title: "Home Page".trn(),
        // title: Text(titles[_currentIndex] , style: ourTextStyle(color: Theme_Information.Color_1, fontSize: 18),),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            if(data.isNotEmpty && data.first.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  print("data ${data.first.toJson()}");
                  ///BeadsPrivetCounter
                  Navigator.push(
                      context,
                      MyCustomRoute(
                          builder: (BuildContext context) => BeadsPrivetCounter(
                            title:  data.first.title,
                            id: data.first.id,
                            description: data.first.description,
                            dhikr: data.first.dhikr,
                            image: data.first.image,
                          )));
                },
                child: Container(
                  height: size_H(40),
                  color: Colors.red,
                  width: double.infinity,
                  child: Center(child: Text("${data.first.title}", style: ourTextStyle(color: Theme_Information.Color_1))),
                ),
              ),
            ),

            SizedBox(height: size_H(10),),
            /// slider
            InkWell(
              onTap: (){
                // postDataAndIncrementCounter();
///
//                 void incrementCount() {
//                   count++;
                  // FirebaseFirestore.instance.collection('your_collection_name').doc('your_document_id').update({'count': count});
                // }
              },
              child: Container(
                height: size_H(210),
                // child: Image.asset("assets/images/image_new/banner_new.jpg" ,width: size_W(350),fit: BoxFit.cover,),

                child: ImageSlider(
                  imagePaths: [
                    ImagePath.tareqa,
                  ],
                ),
              ),
            ),
            SizedBox(height: size_H(15),),

            buildBoxWidgetLineOld(context),


            Expanded(child: Image.asset(ImagePath.qubah3 , height: size_H(150),))

          ],
        ),
      ),
    );
  }
///
//   Future getAllData() async {
//     /// getCountry
//     try{
//       // var parameter = {} ;
//       final response = await APIMethods().getMethod("https://flutter-games-dadab-default-rtdb.firebaseio.com/flutter-games/new_meet.json?auth=LI6P5U2fFGERu425tsGkdgpTAt7Slcs0FxVI7YNb");
//       if(response != null){ /// https://sheikhismailalkurdi-2ffea-default-rtdb.europe-west1.firebasedatabase.app
//         print(response.body);
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           // print("rrr ${response.body}");
//           Map<String, dynamic> jsonData = json.decode(response.body);
//
//           List<MeetingData> sessionList = jsonData.entries.map((entry) {
//             return MeetingData.fromJson({
//               'session_id': entry.key,
//               'session_name': entry.value['session_name'],
//             });
//           }).toList();
//           data = sessionList ;
//           setState(() {});
//         }
//       }
//     } catch(e){
//     }
//   }
///
  Future<void> postDataAndIncrementCounter() async {
    Map<String, dynamic> data = {
      "title": "شارك معنا الان في الحملة لنصرة أهل غزة",
      "description": "شارك معنا الان بذكر يا لطيف لنصرة ومساندة أهلنا في غزة",
      "dhikr": "يا لطيف",
      "count": 0
    };

    try {
      await FirebaseFirestore.instance.collection('dhikr_bars').add(data);
      print('Data added to Firestore');
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
  }




  Future fetchDataFromFirestore() async {
    // try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection");
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('dhikr_bars')
          .get();

      // data = querySnapshot.docs
      //     .map((doc) => DhikrItems.fromJson(doc.data() as Map<String, dynamic>))
      //     .toList();


      final List<DhikrItems> dataList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        print(" ${data}");
        return DhikrItems(
          title : "${doc['title']}" ?? "",
          id : "${doc['id']}" ?? "",
          description: doc['description'],
          dhikr: doc['dhikr'],
          enable: doc['enable'],
          image: doc['image'],
          count: doc['count'],
        );
      }).toList();
      print("SSS ${dataList}");
      /// here remove
      dataList.forEach((element) {
        if(element.enable != null && element.enable == false){
          dataList.remove(element);
        }
      });
      print("SSS ${dataList}");
      data = dataList ;
      setState(() {});
      // return data;
    // } catch (e) {
    //   print('Error fetching data from Firestore: $e');
    //   return [];
    // }
  }

  Widget buildBoxWidgetLineOld(BuildContext context) {
    return Column(
      children: [
        BoxWidget(
          list: [
            Boxes(
              name: "الأوراد والأذكار",
              // name: "الأوراد",
              onTap: () {
                // Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => FilesPage()));
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => AwradAndZkerPage()));


              },

            ),


            Boxes(
              name: "Licenses Time".trn(),
              onTap: () {
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) =>  LicensesTime()));
              },

            ),
          ],
        ),
        SizedBox(height:15,),
        BoxWidget(
          list: [
            Boxes(
              name: "Sanad".trn(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPageMix(
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
                  assetPath:  "assets/pdfFiles/sanad_withImage_new2.pdf" , /// new_sanad_a4
                  // assetPath:  "assets/pdfFiles/sanad.pdf" , /// new_sanad_a4
                  title:"Sanad".trn(),
                )));
              },
            ),

            Boxes(
              name: "About Sheikh Ismail Al-Kurdi".trn(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
                  assetPath:  "assets/pdfFiles/aboutsheikh2.pdf" ,
                  title:"About Sheikh Ismail Al-Kurdi".trn() ,
                )));
              },

            ),
          ],
        ),
        SizedBox(height:15,),

        BoxWidget(
          list: [
            Boxes(
              name: "البردة",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FilesPageBurda(
                )));
              },

            ),

            Boxes(
              name: "المجموعة المباركة لمجلس الصلاة على سيدنا النبي ﷺ",
              // name: "المجموعة المباركة لمجلس الصلاة على النبي صلى الله عليه وسلم",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FilesPageMauled()));
              },

            )
          ],
        ),
///
        SizedBox(height:15,),
        BoxWidget(
          list: [
            Boxes(
              name: "قوائم التشغيل",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FilesPageYoutube()));
              },

            ),

            Boxes(
              // name:  "تواصل معنا ومشاركة التطبيق" ,
              name: "Contact US".trn(),
              onTap: () {
                Navigator.push(
                    context,
                    MyCustomRoute(
                        builder: (BuildContext context) => ContactUS()));
              },
            )
          ],
        ),

        SizedBox(height:15,),

        BoxWidget(
          list: [
            Boxes(
              name:  "مشاركة التطبيق" ,
              onTap: () {
                shareApplication();
              },

            ),

            Boxes(
              // name:  "تواصل معنا ومشاركة التطبيق" ,
              name:  "المسبحة الألكترونية" ,
              onTap: () {
                Navigator.push(
                    context,
                    MyCustomRoute(
                        builder: (BuildContext context) => BeadsCounter()));
              },
            )
          ],
        ),


        // BoxWidgetLine(
        //   box: Boxes(
        //     name:  "مشاركة التطبيق" ,
        //     onTap: () {
        //       shareApplication();
        //       // Navigator.push(
        //       //     context,
        //       //     MyCustomRoute(
        //       //         builder: (BuildContext context) => ContactUS()));
        //     },
        //   ),
        // ),
        // if (kDebugMode)
        // SizedBox(height:15,),
        // if (kDebugMode)
        // BoxWidgetLine(
        //   box: Boxes(
        //     name:  "المسبحة الألكترونية" ,
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MyCustomRoute(
        //               builder: (BuildContext context) => BeadsCounter()));
        //     },
        //   ),
        // ),
      ],
    );
  }
  void shareApplication() {


    // var urlst = "" ;
    // if (Platform.isAndroid) {
    //   urlst = "https://play.google.com/store/apps/details?id=com.kurdi.sheikhismailalkurdi";
    // } else if (Platform.isIOS) {
    //   urlst = "https://apps.apple.com/app/id6456609292";
    // }
    // if(urlst != "")

    const String message = 'حمل تطبيق زاوية الكردي لقراءة أوراد الطريقة والقصائد ومتابعة دروس فضيلة الشيخ إسماعيل الكردي والمجالس:\n\n'
        '* أندرويد:\nhttps://play.google.com/store/apps/details?id=com.kurdi.sheikhismailalkurdi\n\n'
        '* ايفون:\nhttps://apps.apple.com/app/id6456609292\n\n'
        '* هواوي:\nhttps://appgallery.huawei.com/app/C108991813';

    Share.share(message);



  }
  // Future<bool> _isHuaweiDevice() async {
  //   if (Platform.isAndroid) {
  //     final deviceInfo = DeviceInfoPlugin();
  //     AndroidDeviceInfo androidInfo;
  //
  //     try {
  //       androidInfo = await deviceInfo.androidInfo;
  //
  //       if (androidInfo.manufacturer.toLowerCase() == 'huawei') {
  //         print("This is an Android Huawei device.");
  //         return true ;
  //       } else {
  //         print("This is an Android device, but not from Huawei.");
  //       }
  //     } catch (e) {
  //       print("Error getting Android device info: $e");
  //     }
  //   } else {
  //     print("This is not an Android device.");
  //   }
  // }

}