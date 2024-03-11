import 'package:flutter/material.dart';

import '../configuration/theme.dart';
import 'boxesHomeOneLine.dart';

class BoxWidgetLine extends StatelessWidget {
  final Boxes box ;
  BoxWidgetLine({
    required this.box
  });



  @override
  Widget build(BuildContext context) {
    return buildColumn(context);
  }


  Widget buildColumn(context) {
    return _buildBox(box.name, box.onTap , context);
  }



  Widget _buildBox(String text, Function() onTap  , context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size_W(180) + size_W(180) + size_W(10),
        // width: MediaQuery.of(context).size.width * 0.95,
        height: size_H(50),
        // height: size_H(150),
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          color: Theme_Information.Primary_Color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(child: Text(text , style: ourTextStyle(fontSize: 15 ,color: Theme_Information.Color_1),)),
            ),
            // Text(text , style: ourTextStyle(fontSize: 15 ,color: Theme_Information.Color_1),),
          ],
        ),
      ),
    );
  }
}

class Boxes {
  // String image ;
  String name ;
  Function() onTap ;

  Boxes({required this.name,required this.onTap});
}