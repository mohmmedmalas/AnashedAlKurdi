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
import 'nasheedListByCategory.dart';
// import 'filesMauled.dart';

class NasheedListMaqamatPage extends StatefulWidget {
  const NasheedListMaqamatPage({Key? key}) : super(key: key);

  @override
  State<NasheedListMaqamatPage> createState() => _NasheedListMaqamatPageState();
}

class _NasheedListMaqamatPageState extends State<NasheedListMaqamatPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "قصائد حسب المقامات",
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
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
                  name:  "مقام الصبا",
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "4F5NaRyX1YY7Wgu5HBTT",
                      categoryName: "مقام الصبا",
                    )));
                  },
                ),
              ),
              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام النهاوند" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "VU6CRKTXJzsdSe9LEiHD",
                      categoryName: "مقام النهاوند",
                    )));

                  },
                ),
              ),

              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام العجم" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "VPL1YahhBpHebgpHSDQj",
                      categoryName: "مقام العجم",
                    )));

                  },
                ),
              ),

              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام البيات" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "rwaOL69J0XU0bjSISu2d",
                      categoryName: "مقام البيات",
                    )));

                  },
                ),
              ),


              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام السيكا" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "y4Dhad7nnn6o30DJ8Dt7",
                      categoryName: "مقام السيكا",
                    )));

                  },
                ),
              ),

              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام الحجاز" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "fcUc3en2pH05Fq4uvqou",
                      categoryName: "مقام الحجاز",
                    )));

                  },
                ),
              ),


              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام الرست" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "ldgwhOQSIiBPeft8HLPm",
                      categoryName: "مقام الرست",
                    )));

                  },
                ),
              ),

              SizedBox(height: size_H(15),),
              BoxWidgetLine(
                box: Boxes(
                  name:  "مقام الكرد" ,
                  onTap: () {
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => NasheedListByCategoryPage(
                      categoryID: "pbLctXukVR2pVXnTGjUI",
                      categoryName: "مقام الكرد",
                    )));

                  },
                ),
              ),
              SizedBox(height: size_H(15),),

            ],
          ),
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
