import 'package:bookapp/configuration/theme.dart';
import 'package:bookapp/contant/pdfViewerPage.dart';
import 'package:flutter/material.dart';

import '../commenwidget/boxesHome.dart';
import '../commenwidget/boxesHomeOneLine.dart';
import '../commenwidget/customAppBar.dart';
import '../commenwidget/imageSlider.dart';
import '../configuration/images.dart';
import 'azkarFiles.dart';
import 'files.dart';
import 'filesBurda.dart';
import 'filesMauled.dart';

class AwradAndZkerPage extends StatefulWidget {
  const AwradAndZkerPage({Key? key}) : super(key: key);

  @override
  State<AwradAndZkerPage> createState() => _AwradAndZkerPageState();
}

class _AwradAndZkerPageState extends State<AwradAndZkerPage> {
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
        title: "صفحة الأوراد والأذكار",
        // title: "Files Page".trn(),
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child:  Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size_H(160),
                // child: Image.asset("assets/images/image_new/banner_new.jpg" ,width: size_W(350),fit: BoxFit.cover,),

                child: ImageSlider(
                  imagePaths: [
                    ImagePath.awrad,
                  ],
                ),
              ),
            ),

            SizedBox(height: size_H(15),),


            BoxWidgetLine(
              box: Boxes(
                name:  "أوراد الطريق",
                onTap: () {
                  Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => FilesPage()));

                },
              ),
            ),
            SizedBox(height: size_H(15),),
            BoxWidgetLine(
              box: Boxes(
                name:  "الأذكار العامة" ,
                onTap: () {
                  Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => AzkarFilePage()));


                },
              ),
            ),
          ],
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
