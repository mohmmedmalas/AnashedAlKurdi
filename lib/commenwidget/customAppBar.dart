import 'package:flutter/material.dart';
import '../configuration/theme.dart';

import '../configuration/images.dart';

PreferredSize myAppBar({required String title, List<Widget>? actions , Function? onTap ,Widget? leadingWidget ,context }) {
  return PreferredSize(
    preferredSize: context != null && MediaQuery.of(context).orientation.name.toString() == "portrait" ?  Size.fromHeight(80.0) : Size.fromHeight(70.0) ,
    child: CustomAppBar(title: title, actions: actions ,onTap: onTap , leadingWidget: leadingWidget),
  );
}

class CustomAppBar extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leadingWidget;
  final Function? onTap;

  const CustomAppBar({Key? key, this.title,this.onTap,this.leadingWidget, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  buildClipRRectInSide(context)
    ;
  }
  //
  // "Home Page".trn(),
  // ///Virtual
  // "My Inbox".trn(),
  // // "My PO.Box".trn(),
  // "My Order".trn(),
  // "Track Order".trn(),
  // "Profile".trn(),

  ClipRRect buildClipRRectInSide(context) {
    // print("MediaQuery.of(context).orientation.toString() ${MediaQuery.of(context).orientation.name.toString()}");
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            /// here
            colors: [Theme_Information.Primary_Color, Theme_Information.Primary_Color],
            // colors: [Theme_Information.Primary_Color, Theme_Information.Primary_Color],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10 , bottom: 20),
          child:
          AppBar(
            iconTheme: IconThemeData(color: Theme_Information.Color_1),
            leading: leadingWidget,
            actions: actions ??  [
              InkWell(
                  onTap:onTap == null ? null :  (){
                    onTap!();

                  },
                  child: Image.asset(ImagePath.free_1 ,)),
              // Image.asset(ImagePath.free_2 ,),
              // Image.asset(ImagePath.qubah2 ,),
              SizedBox(width: 10,)
            ],
            title: Text(title!,
                style: ourTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).orientation.name.toString() == "portrait" ? 18 : 40,
                )),
            // centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    ),
  );
  }


}