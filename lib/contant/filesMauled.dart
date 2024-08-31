import 'package:bookapp/configuration/theme.dart';
import 'package:bookapp/contant/pdfViewerPage.dart';
import 'package:bookapp/contant/pdfViewerPageMauled.dart';
import 'package:flutter/material.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';

class FilesPageMauled extends StatefulWidget {
  const FilesPageMauled({Key? key}) : super(key: key);

  @override
  State<FilesPageMauled> createState() => _FilesPageMauledState();
}

class _FilesPageMauledState extends State<FilesPageMauled> {
  List<Map<String, String>> pdfFiles = [
    {
      'title': 'الاستغفار الكبير',
      'assetPath': 'assets/pdfFiles/mauled/1_mauled_new2.pdf',
    },
    {
      'title': 'المزدوجة الحسناء في الإستغاثة بأسماء الله الحسنى',
      'assetPath': 'assets/pdfFiles/mauled/2_mauled_new2.pdf',
    },
    {
      'title': 'الصلاة الكمالية',
      'assetPath': 'assets/pdfFiles/mauled/3_mauled_new2.pdf',
    },
    {
      'title': 'قصيدة يا من يغيث المستغيث',
      'assetPath': 'assets/pdfFiles/mauled/5_mauled_new2N.pdf',
    },
    {
      'title': 'الصلاة العظيمية',
      'assetPath': 'assets/pdfFiles/mauled/4_mauled_new2_n.pdf',
    },
    {
      'title': 'القصيدة المحمدية',
      'assetPath': 'assets/pdfFiles/mauled/6_mauled.pdf',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "المجموعة المباركة لمجلس الصلاة على النبي ﷺ",
        // title: "المجموعة المباركة لمجلس الصلاة على النبي صلى الله عليه وسلم",
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
                    index: index ,
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
  void _openPdf({required assetPath,required title , required int index}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPageMauled(
        // assetPath:assetPath ,
        // title:title ,
        itemList: pdfFiles,
        index: index,
          // item: pdfFiles[index],
    )));
  }
}
