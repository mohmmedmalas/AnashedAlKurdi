import 'dart:io';

import 'package:bookapp/configuration/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import '../commenwidget/customAppBar.dart';
import '../configuration/images.dart';

class LicensesTime extends StatefulWidget {
  const LicensesTime({Key? key}) : super(key: key);

  @override
  State<LicensesTime> createState() => _LicensesTimeState();
}

class _LicensesTimeState extends State<LicensesTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        leadingWidget: SizedBox(),
        title: "Licenses Time".trn(),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مواعيد الدروس:',
                  style: ourTextStyle(fontSize: 20),
                ),
                SizedBox(height: size_H(20)),
                Text(
                  'ـ مجلس اللطيفية ودرس الشمائل المحمدية ودرس شرح الحكم العطائية - كل ثلاثاء - بعد صلاة العشاء ( زاوية الصريح )',
                  style: ourTextStyle(fontSize: 16),
                ),
                SizedBox(height: size_H(10)),
                Text(
                  'ـ  مجلس الصلاة على النبي صلى الله عليه وسلم ودرس شرح الحكم الغوثية - كل جمعة - بعد صلاة العصر (زاوية الصريح )',
                  style: ourTextStyle(fontSize: 16),
                ),
                SizedBox(height: size_H(10)),
                Text(
                  'ـ مجلس الصلاة والسلام على سيدنا محمد ﷺ ودرس كتاب مفتاح الفلاح ومصباح الأرواح - كل سبت - للإمام ابن عطاء الله السكندري (زاوية المفرق )',
                  style: ourTextStyle(fontSize: 16),
                ),

                SizedBox(height: size_H(10)),
                Text(
                  'ـ مجلس الصلاة والسلام على سيدنا محمد ﷺ ودرس حقائق عن التصوف - كل أحد - بعد العشاء مباشرة (زاوية عمان )',
                  style: ourTextStyle(fontSize: 16),
                ),
                SizedBox(height: size_H(10)),
                // Text(
                //   'ـ اي مجالس اخرى يعلن عنها على الصفحة - تابعونا.',
                //   style: ourTextStyle(),
                // ),
                SizedBox(height: size_H(20)),
                Text(
                  'عناوين المجالس',
                  style: ourTextStyle(fontSize: 20),
                ),
                SizedBox(height: size_H(20)),
                Text(
                  '- زاوية الصريح : مسجد الشيخ محمد سعيد الكردي رحمه الله تعالى - اربد',
                  style: ourTextStyle(fontSize: 16),
                ),
                SizedBox(height: size_H(5)),
                GestureDetector(
                  onTap: () {
                    if(!Platform.isAndroid){
                      openMapsSheet(context, latitude:  32.4988250 , longitude:  35.8897983 );
                    }else{
                      launch('https://bit.ly/3vQmnxQ');
                    }

                  },
                  child: Text(
                    'https://bit.ly/3vQmnxQ',
                    style:  ourTextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: size_H(10)),
                Text(
                  '- زاوية عمان : دار الذكر و الاحسان - ضاحية الرشيد',
                  style: ourTextStyle(fontSize: 16),
                ),
                SizedBox(height: size_H(5)),
                GestureDetector(
                  onTap: () {
                    // launch('https://pxl.to/67a86o');

                    if(!Platform.isAndroid){
                      openMapsSheet(context, latitude:  32.0184326 , longitude:  35.8850102 );
                    }else{
                      launch('https://pxl.to/67a86o');
                    }

                  },
                  child: Text(
                    'https://pxl.to/67a86o',
                    style: ourTextStyle(color: Colors.blue),
                  ),
                ),

                SizedBox(height: size_H(10)),
                Text(
                  '- زاوية المفرق : مسجد خليل الرحمن - المفرق',
                  style: ourTextStyle(fontSize: 16),
                ),
                SizedBox(height: size_H(5)),
                GestureDetector(
                  onTap: () {
                    // launch('https://maps.app.goo.gl/cygGPv7rf7XKJpLYA');


                    if(!Platform.isAndroid){
                      openMapsSheet(context, latitude:  32.3427870 , longitude:  36.2034049 );
                    }else{
                      launch('https://maps.app.goo.gl/cygGPv7rf7XKJpLYA');
                    }

                  },
                  child: Text(
                    'https://maps.app.goo.gl/cygGPv7rf7XKJpLYA',
                    style: ourTextStyle(color: Colors.blue),
                  ),
                ),


                // Expanded(child: Center(child: Image.asset(ImagePath.qubah3 , height: size_H(85),)))

              ],
            ),
          ),
        ),
      )
    );
  }

  openMapsSheet(context, {required double latitude,required double longitude}) async {
    try {
      final coords = launcher.Coords(latitude, longitude);
      final title = "";
      final availableMaps = await launcher.MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showDirections(
                          directionsMode: launcher.DirectionsMode.driving,
                          destinationTitle: title,
                          destination: coords,
                        ),
                        title: Text(map.mapName, style: ourTextStyle()),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

}
