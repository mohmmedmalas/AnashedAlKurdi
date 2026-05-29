// import 'package:nasheedapp/configuration/theme.dart';
// import 'package:nasheedapp/contant/pdfViewerPage.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../commenwidget/customAppBar.dart';
// import '../configuration/images.dart';
//
// class FilesPageYoutube extends StatefulWidget {
//   const FilesPageYoutube({Key? key}) : super(key: key);
//
//   @override
//   State<FilesPageYoutube> createState() => _FilesPageYoutubeState();
// }
//
// class _FilesPageYoutubeState extends State<FilesPageYoutube> {
//   List<Map<String, String>> pdfFiles = [
//     {
//       'title': 'أناشيد',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8O1c2pCHASgGMPe8VA0Prqc',
//     },
//     {
//       'title': 'الحكم العطائية - مع فضيلة الشيخ إسماعيل الكردي حفظه الله تعالى',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8PGTD50w2JyNe0B-IIbf7E-',
//     },
//     {
//       'title': 'كتاب البرهان المؤيد',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8NE08SaYoONH8Pc2JdLnXaF',
//     },
//     {
//       'title': 'وسائل الوصول إلى شمائل الرسول صلى الله عليه وسلم للشيخ يوسف النبهاني',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8MdIxn06gpBGcAIyf2QItSg',
//     },
//     {
//       'title': "شرح قصيدة 'ما لذة العيش إلا صحبة الفقرا' في آداب الطريق",
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8P0BTyvC_amUDV-nN5m3Ko0',
//     },
//     {
//       'title': 'كتاب حقائق عن التصوف للشيخ عبد القادر عيسى',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8PYAs9jAycZ7PHE_Bij6gjB',
//     },
//     {
//       'title': 'شرح الحكم الغوثية',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8ONArPy52PQ9sB9T4xlSTqK',
//     },
//     {
//       'title': 'مفتاح الفلاح ومصباح الأرواح',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8OyfY3sy3_DS2qFL7WQq6xl',
//     },
//     {
//       'title': 'مجالس الحضرة',
//       'url': 'https://www.youtube.com/playlist?list=PLqFpLuxcFk8PpD5G_aovaB_0kaJoETNLx',
//     },
//     {
//       'title': 'من درر أقوال الشيخ إسماعيل الكردي',
//       'url': 'https://youtube.com/playlist?list=PLqFpLuxcFk8OUdq2LVD1vK9Snp9Y4Zd8Y',
//     },
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppBar(
//         title: "قوائم التشغيل",
//       ),
//
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child:   ListView.builder(
//           itemCount: pdfFiles.length,
//           itemBuilder: (context, index) {
//             return Card(
//               child: ListTile(
//                 title: Text(pdfFiles[index]['title'] ?? '', style: ourTextStyle(fontSize: MediaQuery.of(context).orientation.name.toString() == "portrait" ? 13 : 40)),
//                 trailing: Image.asset(ImagePath.qubah2),
//                 onTap: () {
//                   launch(pdfFiles[index]['url']!);
//                   // _openPdf(
//                   //   assetPath: pdfFiles[index]['assetPath'] ?? '',
//                   //   title: pdfFiles[index]['title'] ?? '',
//                   // );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//   void _openPdf({required assetPath,required title}) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
//         assetPath:assetPath ,
//         title:title ,
//     )));
//   }
// }
