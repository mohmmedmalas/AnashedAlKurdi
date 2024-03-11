import 'package:bookapp/configuration/theme.dart';
import 'package:bookapp/contant/pdfViewerPage.dart';
import 'package:flutter/material.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';
import 'filesBurda.dart';
import 'filesMauled.dart';

class AzkarFilePage extends StatefulWidget {
  const AzkarFilePage({Key? key}) : super(key: key);

  @override
  State<AzkarFilePage> createState() => _AzkarFilePageState();
}

class _AzkarFilePageState extends State<AzkarFilePage> {

  List<Map<String, String>> pdfFiles = [
    {
      'title': 'سورة يس مع وردها',
      'assetPath': 'assets/pdfFiles/file11.pdf',
    },
    {
      'title': 'سورة الواقعة مع وردها',
      'assetPath': 'assets/pdfFiles/file10N.pdf',
    },
    {
      'title': 'سورة الملك',
      'assetPath': 'assets/pdfFiles/file9.pdf',
    },
    {
      'title': 'أوراد السحر',
      'assetPath': 'assets/pdfFiles/file12.pdf',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "صفحة الأذكار العامة",
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
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => AzkarFilePageBurda()));
                  // } else if(pdfFiles[index]['type'] == "page_maulad"){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => AzkarFilePageMauled()));
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
