import 'package:bookapp/configuration/theme.dart';
import 'package:bookapp/contant/pdfViewerPage.dart';
import 'package:flutter/material.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';
import 'filesBurda.dart';
import 'filesMauled.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  //
  // List<Map<String, String>> pdfFiles = [
  //   {
  //     'title': 'المقدمة',
  //     'assetPath': 'assets/pdfFiles/starting.pdf',
  //   },
  //   {
  //     'title': 'مقدمة عن الشيخ اسماعيل الكردي',
  //     'assetPath': 'assets/pdfFiles/sheck ismaeel.pdf',
  //   },
  //   {
  //     'title': 'الورد العام',
  //     'assetPath': 'assets/pdfFiles/all_ord.pdf',
  //   },
  //   {
  //     'title': 'حزب البحر',
  //     'assetPath': 'assets/pdfFiles/baher.pdf',
  //   },
  //   {
  //     'title': 'حزب البر',
  //     'assetPath': 'assets/pdfFiles/baar.pdf',
  //   },
  // ];

  List<Map<String, String>> pdfFiles = [
    {
      'title': 'الورد العام',
      'assetPath': 'assets/pdfFiles/file1_new.pdf',
    },

    // {
    //   'title': 'الورد العام - معدل',
    //   'assetPath': 'assets/pdfFiles/file1_test_1.pdf',
    // },
    {
      'title': 'حزب البحر',
      'assetPath': 'assets/pdfFiles/file2_new.pdf',
    },
    {
      'title': 'الصلاة العظيمية',
      'assetPath': 'assets/pdfFiles/file3_new.pdf',
    },
    {
      'title': 'الوظيفة الشاذلية',
      'assetPath': 'assets/pdfFiles/file4_new.pdf',
    },
    {
      'title': 'حزب الإمام النووي',
      'assetPath': 'assets/pdfFiles/file5_new.pdf',
    },
    {
      'title': 'حزب الدور الأعلى',
      'assetPath': 'assets/pdfFiles/file6_new.pdf',
    },
    {
      'title': 'حزب النصر',
      'assetPath': 'assets/pdfFiles/file7_new.pdf',
    },
    {
      'title': 'قصيدة توجيهية',
      'assetPath': 'assets/pdfFiles/file8_new2.pdf',
    },
    // {
    //   'title': 'البردة',
    //   'type' : 'page_burda',
    // },
    // {
    //   'title': 'المولد',
    //   'type' : 'page_maulad',
    // },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "صفحة أوراد الطريق",
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child:   ListView.builder(
          itemCount: pdfFiles.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(pdfFiles[index]['title'] ?? '', style: ourTextStyle(fontSize: MediaQuery.of(context).orientation.name.toString() == "portrait" ? 13 : 40)),
                trailing: Image.asset(ImagePath.qubah2),
                onTap: () {
                  if(pdfFiles[index]['type'] == null) {
                    _openPdf(
                      assetPath: pdfFiles[index]['assetPath'] ?? '',
                      title: pdfFiles[index]['title'] ?? '',
                    );
                  }
                  // } else if(pdfFiles[index]['type'] == "page_burda"){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => FilesPageBurda()));
                  // } else if(pdfFiles[index]['type'] == "page_maulad"){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => FilesPageMauled()));
                  // }

                },
              ),
            );
          },
        ),
      ),
    );
  }
  void _openPdf({required assetPath,required title}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
        assetPath:assetPath ,
        title:title ,
    )));
  }
}
