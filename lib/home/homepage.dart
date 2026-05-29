// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:nasheedapp/configuration/images.dart';
// import 'package:nasheedapp/home/sendNasheed.dart';
// import 'package:nasheedapp/model/dhikrItemsModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:connectivity/connectivity.dart';
// // import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// // import 'package:share_plus/share_plus.dart';
//
// import '../commenwidget/boxesHome.dart';
// import '../commenwidget/boxesHomeOneLine.dart';
// import '../commenwidget/customAppBar.dart';
// import '../commenwidget/imageSlider.dart';
// import '../configuration/basePage.dart';
// import '../configuration/theme.dart';
// import '../contant/awradAndZker.dart';
// // import '../contant/beadsCounterPage.dart';
// // import '../contant/beadsPrivetCounterPage.dart';
// // import '../contant/contactUs.dart';
// import '../contant/files.dart';
// import '../contant/filesBurda.dart';
// // import '../contant/filesMauled.dart';
// import '../contant/filesYoutube.dart';
// // import '../contant/licensesTime.dart';
// import '../contant/nasheedList.dart';
// import '../contant/nasheedListByCategory.dart';
// import '../contant/nasheedListHadra.dart';
// import '../contant/nasheedListMaqamat.dart';
// import '../contant/pdfViewerPage.dart';
// import '../starting/splashScreen.dart';
// // import '../model.dart';
// // import '../contant/pdfViewerPageMix.dart';
// // import '../pages/pages/newIamge.dart';
// // import '../pages/renewBox/RequestBulkFromBoxes.dart';
//
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   List<DhikrItems> data = [] ;
//   bool hasShownPopup = false; // To make sure popup shows only once until admin pushes again
//
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     // fetchDataFromFirestore();
//
//   }
//
//   // void newApp(title , image){
//   //   /// NewPAge
//   //   Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NewPAge(title:title ,  image: image,)));
//   //
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//       child: Scaffold(
//         endDrawer:  _buildDrawer() ,
//
//         appBar: myAppBar(
//             leadingWidget: Builder(
//               builder: (context) => IconButton(
//                 icon: Icon(Icons.menu),
//                 onPressed: () => Scaffold.of(context).openEndDrawer(),
//               ),
//             ),
//           onTap: (){
//               Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => SendNasheed()));
//
//           },
//           title: "الصفحة الرئيسية",
//           context: context
//           // title: "Home Page",
//           // title: Text(titles[_currentIndex] , style: ourTextStyle(color: Theme_Information.Color_1, fontSize: 18),),
//         ),
//         body: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Column(
//             children: [
//
//               SizedBox(height: size_H(10),),
//               /// slider
//               Container(
//                 height: size_H(210),
//                 // child: Image.asset("assets/images/image_new/banner_new.jpg" ,width: size_W(350),fit: BoxFit.cover,),
//
//                 child: ImageSlider(
//                   imagePaths: [
//                     ImagePath.tareqa,
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: size_H(15),),
//
//               BoxWidgetLine(
//                 box: Boxes(
//                   name: "كافة القصائد",
//                   onTap: () {
//                     Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListPage()));
//                   },
//                 ),
//               ),
//
//               SizedBox(height:15,),
//
//               BoxWidgetLine(
//                 box: Boxes(
//                   name: "ديوان سيدي الكردي",
//                   onTap: () {
//                     Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
//                       categoryID: "Xu7D8m9y4dorZu2BuDEJ",
//                       categoryName: "ديوان سيدي الكردي",
//                     )));
//                   },
//                 ),
//               ),
//
//               SizedBox(height:15,),
//
//               BoxWidgetLine(
//                 box: Boxes(
//                   name: "قصائد الحضرة",
//                   onTap: () {
//                     Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListHadraPage()));
//                   },
//                 ),
//               ),
//
//               SizedBox(height:15,),
//
//               BoxWidgetLine(
//                 box: Boxes(
//                   name: "قصائد حسب المقامات",
//                   onTap: () {
//                     Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListMaqamatPage()));
//                   },
//                 ),
//               ),
//
//               SizedBox(height:15,),
//
//
//               Expanded(child: Image.asset(ImagePath.qubah3 , height: size_H(150),))
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   // Create the drawer widget
//   Widget _buildDrawer() {
//     return Drawer(
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               // Drawer Header
//               Container(
//                 height: size_H(200),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Theme_Information.Primary_Color!,
//                       Theme_Information.Color_1!.withOpacity(0.5),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: size_W(100),
//                       height: size_H(100),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       // child: Icon(
//                       //   Icons.mosque,
//                       //   size: size_W(40),
//                       //   color: Theme_Information.Primary_Color,
//                       // ),
//                       child: Image.asset("${ImagePath.qubah2}" ,scale: 2,
//                       ),
//
//                     ),
//                     SizedBox(height: size_H(15)),
//                     Text(
//                       "قصائد الكردي",
//                       style: ourTextStyle(
//                         color: Theme_Information.Primary_Color,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "Zawiyat Al-Kurdi",
//                       style: ourTextStyle(
//                         color: Theme_Information.Primary_Color,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Drawer Menu Items
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     _buildDrawerItem(
//                       icon: Icons.menu_book,
//                       title: "Sanad",
//                       onTap: () {
//                         // Navigator.pop(context); // Close drawer
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
//                         //   assetPath: "assets/pdfFiles/sanad_withImage_new2.pdf",
//                         //   title: "sanad".trn(),
//                         // )));
//                       },
//                     ),
//
//                     // Divider
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       child: Divider(color: Colors.grey[300]),
//                     ),
//
//                     _buildDrawerItem(
//                       icon: Icons.logout,
//                       title: "Logout",
//                       onTap: () {
//                         Navigator.pop(context);
//                         FirebaseAuth.instance.signOut();
//                         Navigator.pushReplacement(context, MyCustomRoute(builder: (BuildContext context) => SplashScreen()));
//
//                         // Add settings page navigation if you have one
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Footer
//               Container(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Divider(color: Colors.grey[300]),
//                     Text(
//                       "Version 1.0.0",
//                       style: ourTextStyle(
//                         color: Colors.grey[600]!,
//                         fontSize: 12,
//                       ),
//                     ),
//                     Text(
//                       "© 2024 Zawiyat Al-Kurdi",
//                       style: ourTextStyle(
//                         color: Colors.grey[600]!,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build drawer items
//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: Theme_Information.Primary_Color!.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           icon,
//           color: Theme_Information.Primary_Color,
//           size: 20,
//         ),
//       ),
//       title: Text(
//         title,
//         style: ourTextStyle(
//           color: Colors.black87,
//           fontSize: 15,
//         ),
//       ),
//       onTap: onTap,
//       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//     );
//   }
//
//
//
// }