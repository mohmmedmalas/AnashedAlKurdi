// import 'package:flutter/material.dart';
//
// import '../configuration/theme.dart';
// import 'boxesHomeOneLine.dart';
//
// class BoxWidget extends StatelessWidget {
//   final List<Boxes> list ;
//   BoxWidget({
//     required this.list
//   });
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return buildColumn();
//   }
//
//
//   Column buildColumn() {
//     return Column(
//       children: [
//         // if(list.length > 2)
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//               _buildBox('${list[0].name}', list[0].onTap, ),
//               SizedBox(width: size_W(10),),
//               _buildBox('${list[1].name}', list[1].onTap, ),
//           ],
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildBox(String text, Function() onTap , ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: size_W(180),
//         height: size_H(50),
//         // height: size_H(150),
//         decoration: BoxDecoration(
//           // shape: BoxShape.circle,
//             color: Theme_Information.Primary_Color,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: SizedBox(
//                   height: size_H(40),
//                   child: Center(child: Text(text ,textAlign: TextAlign.center, maxLines: 2,overflow: TextOverflow.ellipsis, style: ourTextStyle(fontSize: 15 ,color: Theme_Information.Color_1),))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
