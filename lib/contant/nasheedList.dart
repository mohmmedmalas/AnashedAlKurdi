import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nasheedapp/contant/pdfViewerPage.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';
import '../configuration/theme.dart';
import '../model/generalFireBaseList.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class NasheedListPage extends StatefulWidget {
  const NasheedListPage({Key? key}) : super(key: key);

  @override
  State<NasheedListPage> createState() => _NasheedListPageState();
}

class _NasheedListPageState extends State<NasheedListPage> {
  List<GeneralFireBaseList> data = [] ;
  List<GeneralFireBaseList> dataLeadList = [] ;
  bool isSearchOpen = false ;
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      data.clear();
      await fetchDataFromFirestoreMentor();
      dataLeadList = data ;
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: Text("قائمة القصائد"),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.search),
        //       onPressed: (){
        //         setState(() {
        //           isSearchOpen = !isSearchOpen ;
        //           search.clear();
        //           data = dataLeadList ;
        //         });
        //       },
        //     ),
        //   ],
        // ),
        appBar: myAppBar(
            title: "كافة القصائد",
            context: context,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                setState(() {
                  isSearchOpen = !isSearchOpen ;
                  search.clear();
                  data = dataLeadList ;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if(isSearchOpen)
                Padding(
                  padding: const EdgeInsets.only(right: 15.0 , left: 15.0),
                  child: TextFormField(
                    autofocus: isSearchOpen,
                    controller: search,
                    // textAlign: TextAlign.right,
                    // textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'بحث',
                        isCollapsed: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                      suffix: InkWell(
                        child: Icon(Icons.close),
                        onTap: (){
                          setState(() {
                            search.clear();
                            data = dataLeadList ;
                          });
                        },
                      )
                    ),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        data = filterItem(value);
                      });
                      // onSearchTextChanged(value);
                    },
                  ),
                ),
             Expanded(
               child: SingleChildScrollView(
                 child: Column(
                   children:  List.generate(data.length, (index) {
                     final item = data[index];
                     // return buildInkWell(context, item);
                     return Card(
                       color: Theme_Information.Color_1,
                       child: ListTile(
                 
                         title: Text("${item.name}", style: ourTextStyle(fontSize: MediaQuery.of(context).orientation.name.toString() == "portrait" ? 13 : 40)),
                         trailing: Image.asset(ImagePath.qubah2),
                         // onLongPress: (){
                         //   showDialog(
                         //     context: context,
                         //     builder: (ctx) => Directionality(
                         //     textDirection: TextDirection.rtl,
                         //       child: AlertDialog(
                         //         title: Text('تأكيد الحذف'),
                         //         content: Text('هل أنت متأكد من حذف الملف "${item.name}"؟'),
                         //         actions: [
                         //           TextButton(
                         //             child: Text('إلغاء'),
                         //             onPressed: () => Navigator.of(ctx).pop(),
                         //           ),
                         //           ElevatedButton(
                         //             child: Text('حذف'),
                         //             style: ElevatedButton.styleFrom(
                         //               backgroundColor: Colors.red,
                         //             ),
                         //             onPressed: () async {
                         //               Navigator.of(ctx).pop(); // Close dialog
                         //               final firestore = FirebaseFirestore.instance;
                         //               final storage = FirebaseStorage.instance;
                         //
                         //               try {
                         //                 // Delete Firestore document
                         //                 await firestore.collection('Nasheed').doc(item.id).delete();
                         //
                         //                 // Delete file from Firebase Storage if URL exists
                         //                 if (item.filePdf != null && item.filePdf!.isNotEmpty) {
                         //                   final ref = storage.refFromURL(item.filePdf!);
                         //                   await ref.delete();
                         //                 }
                         //
                         //                 ScaffoldMessenger.of(context).showSnackBar(
                         //                   SnackBar(content: Text('تم حذف الملف "${item.name}" بنجاح.')),
                         //                 );
                         //               } catch (e) {
                         //                 ScaffoldMessenger.of(context).showSnackBar(
                         //                   SnackBar(content: Text('حدث خطأ أثناء الحذف: $e')),
                         //                 );
                         //               }
                         //             },
                         //           ),
                         //         ],
                         //       ),
                         //     ),
                         //   );
                         // },
                         onTap: () {
                           log("item ${item.toString()}");
                           Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
                             pdfFile: item,
                             // assetPath:item.filePdf! ,
                             // title:item.name! ,
                           )));
                         },
                       ),
                     );
                   }),
                 ),
               ),
             )
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkWell(BuildContext context, GeneralFireBaseList item) {
    return InkWell(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
                       // assetPath:item.filePdf! ,
                       // title:item.name! ,
                       pdfFile: item,
                     )));
                   },
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text(
                            "${item.name}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    )),
                 );
  }


  List<GeneralFireBaseList> filterItem(String name) {
    if (name.isEmpty) {
      return dataLeadList;
    } else {
      String searched = normalise(name);
      return dataLeadList.where((mentor) {
        return (normalise(mentor.name!)).contains(searched) ;
      }).toList();

    }
  }



  String normalise(String input) => input
      .replaceAll('\u0610', '') //ARABIC SIGN SALLALLAHOU ALAYHE WA SALLAM
      .replaceAll('\u0611', '') //ARABIC SIGN ALAYHE ASSALLAM
      .replaceAll('\u0612', '') //ARABIC SIGN RAHMATULLAH ALAYHE
      .replaceAll('\u0613', '') //ARABIC SIGN RADI ALLAHOU ANHU
      .replaceAll('\u0614', '') //ARABIC SIGN TAKHALLUS

  //Remove koranic anotation
      .replaceAll('\u0615', '') //ARABIC SMALL HIGH TAH
      .replaceAll(
      '\u0616', '') //ARABIC SMALL HIGH LIGATURE ALEF WITH LAM WITH YEH
      .replaceAll('\u0617', '') //ARABIC SMALL HIGH ZAIN
      .replaceAll('\u0618', '') //ARABIC SMALL FATHA
      .replaceAll('\u0619', '') //ARABIC SMALL DAMMA
      .replaceAll('\u061A', '') //ARABIC SMALL KASRA
      .replaceAll('\u06D6',
      '') //ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA
      .replaceAll('\u06D7',
      '') //ARABIC SMALL HIGH LIGATURE QAF WITH LAM WITH ALEF MAKSURA
      .replaceAll('\u06D8', '') //ARABIC SMALL HIGH MEEM INITIAL FORM
      .replaceAll('\u06D9', '') //ARABIC SMALL HIGH LAM ALEF
      .replaceAll('\u06DA', '') //ARABIC SMALL HIGH JEEM
      .replaceAll('\u06DB', '') //ARABIC SMALL HIGH THREE DOTS
      .replaceAll('\u06DC', '') //ARABIC SMALL HIGH SEEN
      .replaceAll('\u06DD', '') //ARABIC END OF AYAH
      .replaceAll('\u06DE', '') //ARABIC START OF RUB EL HIZB
      .replaceAll('\u06DF', '') //ARABIC SMALL HIGH ROUNDED ZERO
      .replaceAll('\u06E0', '') //ARABIC SMALL HIGH UPRIGHT RECTANGULAR ZERO
      .replaceAll('\u06E1', '') //ARABIC SMALL HIGH DOTLESS HEAD OF KHAH
      .replaceAll('\u06E2', '') //ARABIC SMALL HIGH MEEM ISOLATED FORM
      .replaceAll('\u06E3', '') //ARABIC SMALL LOW SEEN
      .replaceAll('\u06E4', '') //ARABIC SMALL HIGH MADDA
      .replaceAll('\u06E5', '') //ARABIC SMALL WAW
      .replaceAll('\u06E6', '') //ARABIC SMALL YEH
      .replaceAll('\u06E7', '') //ARABIC SMALL HIGH YEH
      .replaceAll('\u06E8', '') //ARABIC SMALL HIGH NOON
      .replaceAll('\u06E9', '') //ARABIC PLACE OF SAJDAH
      .replaceAll('\u06EA', '') //ARABIC EMPTY CENTRE LOW STOP
      .replaceAll('\u06EB', '') //ARABIC EMPTY CENTRE HIGH STOP
      .replaceAll('\u06EC', '') //ARABIC ROUNDED HIGH STOP WITH FILLED CENTRE
      .replaceAll('\u06ED', '') //ARABIC SMALL LOW MEEM

  //Remove tatweel
      .replaceAll('\u0640', '')

  //Remove tashkeel
      .replaceAll('\u064B', '') //ARABIC FATHATAN
      .replaceAll('\u064C', '') //ARABIC DAMMATAN
      .replaceAll('\u064D', '') //ARABIC KASRATAN
      .replaceAll('\u064E', '') //ARABIC FATHA
      .replaceAll('\u064F', '') //ARABIC DAMMA
      .replaceAll('\u0650', '') //ARABIC KASRA
      .replaceAll('\u0651', '') //ARABIC SHADDA
      .replaceAll('\u0652', '') //ARABIC SUKUN
      .replaceAll('\u0653', '') //ARABIC MADDAH ABOVE
      .replaceAll('\u0654', '') //ARABIC HAMZA ABOVE
      .replaceAll('\u0655', '') //ARABIC HAMZA BELOW
      .replaceAll('\u0656', '') //ARABIC SUBSCRIPT ALEF
      .replaceAll('\u0657', '') //ARABIC INVERTED DAMMA
      .replaceAll('\u0658', '') //ARABIC MARK NOON GHUNNA
      .replaceAll('\u0659', '') //ARABIC ZWARAKAY
      .replaceAll('\u065A', '') //ARABIC VOWEL SIGN SMALL V ABOVE
      .replaceAll('\u065B', '') //ARABIC VOWEL SIGN INVERTED SMALL V ABOVE
      .replaceAll('\u065C', '') //ARABIC VOWEL SIGN DOT BELOW
      .replaceAll('\u065D', '') //ARABIC REVERSED DAMMA
      .replaceAll('\u065E', '') //ARABIC FATHA WITH TWO DOTS
      .replaceAll('\u065F', '') //ARABIC WAVY HAMZA BELOW
      .replaceAll('\u0670', '') //ARABIC LETTER SUPERSCRIPT ALEF

  //Replace Waw Hamza Above by Waw
      .replaceAll('\u0624', '\u0648')

  //Replace Ta Marbuta by Ha
      .replaceAll('\u0629', '\u0647')

  //Replace Ya
  // and Ya Hamza Above by Alif Maksura
      .replaceAll('\u064A', '\u0649')
      .replaceAll('\u0626', '\u0649')

  // Replace Alifs with Hamza Above/Below
  // and with Madda Above by Alif
      .replaceAll('\u0622', '\u0627')
      .replaceAll('\u0623', '\u0627')
      .replaceAll('\u0625', '\u0627');

  Future fetchDataFromFirestoreMentor() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
      await firestore.collection("Nasheed").get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic>? dataList = document.data() as Map<String, dynamic>?;
          String? name = dataList?['name'] as String?;
          String? id = dataList?['id'] as String?;
          String? filePdf = dataList?['file_pdf'] as String?;

          if (name != null && id != null && id != filePdf) {
            data.add(GeneralFireBaseList(id: id , name:  name , filePdf: filePdf));
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

}

