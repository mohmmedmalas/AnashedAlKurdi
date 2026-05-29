import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nasheedapp/contant/pdfViewerPage.dart';

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';
import '../configuration/theme.dart';
// import 'package:intl/intl.dart';
// 
// 

import 'package:nasheedapp/configuration/theme.dart';
import 'package:nasheedapp/contant/pdfViewerPage.dart';
import 'package:flutter/material.dart';

import '../commenwidget/boxesHome.dart';
import '../commenwidget/boxesHomeOneLine.dart';
import '../commenwidget/customAppBar.dart';
import '../commenwidget/imageSlider.dart';
import '../configuration/images.dart';
import '../model/generalFireBaseList.dart';
import 'azkarFiles.dart';
import 'files.dart';
import 'filesBurda.dart';
import 'nasheedList.dart';
// import 'filesMauled.dart';

class NasheedListHadraPage extends StatefulWidget {
  const NasheedListHadraPage({Key? key}) : super(key: key);

  @override
  State<NasheedListHadraPage> createState() => _NasheedListHadraPageState();
}

class _NasheedListHadraPageState extends State<NasheedListHadraPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "قصائد الحضرة",
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
                name:  "القيام",
                onTap: () {

                },
              ),
            ),
            SizedBox(height: size_H(15),),
            BoxWidgetLine(
              box: Boxes(
                name:  "الركوع" ,
                onTap: () {


                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _openPdf({required GeneralFireBaseList item}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(
      // assetPath:assetPath ,
      // title:title ,
      pdfFile: item,
    )));
  }
}
