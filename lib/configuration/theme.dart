import 'dart:typed_data';
// import 'package:bookapp/configuration/size_config.dart';
import 'package:bookapp/configuration/size_config.dart';
// import 'package:google_fonts/google_fonts.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';




class Theme_Information {


  static Color Primary_Color  = Color(0xff309F24);


  static Color focusColor  = Color(0xff8c9da8) ;
  static Color? Color_1  = Colors.white ;
  static Color? Color_2  = Colors.white10 ;
  static Color? Color_3  = Colors.white30 ;
  static Color? Color_4  = Colors.white70 ;
  static Color? Color_44  = Colors.white70.withOpacity(0) ;
  static Color? Color_5  = Colors.black ;
  static Color? Color_6  = Colors.black38 ;

  static Color? Color_7  = Colors.grey ;
  static Color? Color_8  = Colors.grey[500] ;
  static Color? Color_9  = Colors.grey[200] ;
  static Color? Color_99  = Colors.grey.withOpacity(100) ;
  static Color? Color_10  = Colors.red ;
  static Color? Color_11  = Colors.red[200] ;
  static Color? Color_12  = Colors.green[500] ;
  static Color? Color_13  = Colors.blueGrey ;

  static String? ENGfont = 'Montserrat' ;
  static String? ARfont = "ElMessiri" ;

}


extension Translation on String {
  String trn() => translator.translate(this);
}


void hide_keyboard(context){
  FocusScope.of(context).requestFocus(FocusNode());
}

TextStyle ourTextStyle({Color? color, double? fontSize ,FontWeight?  fontWeight }){
  color ??= Colors.black;
  fontSize ??= size_H(13);
  fontWeight ??= FontWeight.normal;
  if(translator.activeLanguageCode == 'ar'){
    return TextStyle(color:  color ,fontWeight:  fontWeight,  fontSize:  size_H(fontSize));
    // return GoogleFonts.readexPro(color:  color ,fontWeight:  fontWeight, fontSize:  size_H(fontSize));
  } else{
    return TextStyle(color:  color ,fontWeight:  fontWeight, fontSize:  size_H(fontSize));
    // return GoogleFonts.aBeeZee(color:  color ,fontWeight:  fontWeight, fontSize:  size_H(fontSize));
  }
  //
}


double size_H(var hight){
  if(hight.runtimeType.toString() == "Int"){
    hight = hight.toDouble();
  }
  return  SizeConfig.heightMultiplier! * (hight / 7.00 ) ;
  // return  SizeConfig.heightMultiplier! * (hight / 7.81 ) ;
}


double size_W(var width){
  if(width.runtimeType.toString() == "Int"){
    width = width.toDouble();
  }
  return  SizeConfig.widthMultiplier! * (width / 3.92 ) ;}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder? builder, RouteSettings? settings })
      : super(builder: builder!, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // transitionDuration: Duration(milliseconds: 2000),
    return new FadeTransition(opacity: animation, child: child );
    // return new ScaleTransition(scale: animation, child: child );
    // return new RotationTransition(turns: animation, child: child );
  }
}

