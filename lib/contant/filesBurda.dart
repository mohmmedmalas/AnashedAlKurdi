import 'package:bookapp/configuration/theme.dart';
import 'package:bookapp/contant/pdfViewerPage.dart';
import 'package:flutter/material.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';

class FilesPageBurda extends StatefulWidget {
  const FilesPageBurda({Key? key}) : super(key: key);
  @override
  State<FilesPageBurda> createState() => _FilesPageBurdaState();
}


class _FilesPageBurdaState extends State<FilesPageBurda> {
  List<Map<String, String>> pdfFiles = [
    {
      'title': 'الفصل الأول (في الغزل وشكوى الغرام)',
      'assetPath': 'assets/pdfFiles/burda/1_burda_New2.pdf',
      // 'assetPath': 'assets/pdfFiles/burda/1_burda.pdf',
    },
    {
      'title': 'الفصل الثاني (في التحذير من هوى النفس)',
      'assetPath': 'assets/pdfFiles/burda/2_burda_New2.pdf',
    },
    {
      'title': 'الفصل الثالث (في مدح سيد المرسلين)',
      'assetPath': 'assets/pdfFiles/burda/3_burda_New2N.pdf',
    },
    {
      'title': 'الفصل الرابع (في مولده عليه الصلاة والسلام)',
      'assetPath': 'assets/pdfFiles/burda/4_burda_New2_NNN.pdf',
    },
    {
      'title': 'الفصل الخامس (في معجزاته صلى الله عليه وسلم)',
      'assetPath': 'assets/pdfFiles/burda/5_burda_New2_NNNN.pdf',
    },
    {
      'title': 'الفصل السادس (في شـرف الــقرآن ومدحـه)',
      'assetPath': 'assets/pdfFiles/burda/6_burda_New2_NNNN.pdf',
    },
    {
      'title': 'الفصل السابع (في إسرائه ومعراجه صلى الله عليه وسلم)',
      'assetPath': 'assets/pdfFiles/burda/7_burda_New2N.pdf',
    },
    {
      'title': 'الفصل الثامن (في جهاد النَّبي صلى الله عليه وسلم)',
      'assetPath': 'assets/pdfFiles/burda/8_burda_New2N.pdf',
    },
    {
      'title': 'الفصل التاسع (في التَّوسل بالنَّبي صلى الله عليه وسلم)',
      'assetPath': 'assets/pdfFiles/burda/9_burda_New2N.pdf',
    },
    {
      'title': 'الفصل العاشر (في المناجاة وعرض الحاجات)',
      'assetPath': 'assets/pdfFiles/burda/10_burda_New2N.pdf',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "البردة",
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
                  _openPdf(
                    assetPath: pdfFiles[index]['assetPath'] ?? '',
                    title: pdfFiles[index]['title'] ?? '',
                  );
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
