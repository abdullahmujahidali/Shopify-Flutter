// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../common/constants.dart';
// import '../../../../generated/l10n.dart';
// import '../../../../models/search_model.dart';
// import 'recent_products.dart';
//
// class RecentSearches extends StatelessWidget {
//   final Function? onTap;
//
//   RecentSearches({this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final widthContent = (screenSize.width / 2) - 4;
//
//     return ListenableProvider.value(
//       value: Provider.of<SearchModel>(context),
//       child: Consumer<SearchModel>(
//         builder: (context, model, child) {
//           return Column(
//             children: <Widget>[
//               model.keywords.isEmpty
//                   ? renderEmpty(context)
//                   : renderKeywords(model, widthContent, context)
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget renderEmpty(context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Expanded(
//       child: Container(
//         width: screenSize.width,
//         child: FittedBox(
//           fit: BoxFit.cover,
//           alignment: Alignment.center,
//           child: Container(
//             width:
//                 screenSize.width / (2 / (screenSize.height / screenSize.width)),
//             height: screenSize.height,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Image.asset(
//                   kEmptySearch,
//                   width: 120,
//                   height: 120,
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   width: 250,
//                   child: Text(
//                     S.of(context).searchForItems,
//                     style: const TextStyle(color: kGrey400),
//                     textAlign: TextAlign.center,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget renderKeywords(
//       SearchModel model, double widthContent, BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Expanded(
//       child: ListView(
//         children: <Widget>[
//           Container(
//             width: screenSize.width,
//             child: FittedBox(
//               fit: BoxFit.cover,
//               child: Container(
//                 width: screenSize.width /
//                     (2 / (screenSize.height / screenSize.width)),
//                 child: Container(
//                   height: 45,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         S.of(context).recentSearches,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       if (model.keywords.isNotEmpty)
//                         InkWell(
//                           onTap: () {
//                             Provider.of<SearchModel>(context, listen: false)
//                                 .clearKeywords();
//                           },
//                           child: Text(
//                             S.of(context).clear,
//                             style: const TextStyle(
//                                 color: Colors.green, fontSize: 13),
//                           ),
//                         )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: screenSize.width,
//             child: FittedBox(
//               fit: BoxFit.cover,
//               child: Container(
//                 width: screenSize.width /
//                     (2 / (screenSize.height / screenSize.width)),
//                 child: Card(
//                   elevation: 0,
//                   color: Theme.of(context).primaryColorLight,
//                   child: Column(
//                     children: List.generate(
//                       (model.keywords.length < 5) ? model.keywords.length : 5,
//                       (index) {
//                         return ListTile(
//                           title: Text(model.keywords[index]),
//                           onTap: () {
//                             onTap!(model.keywords[index]);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Recent(),
//         ],
//       ),
//     );
//   }
// }
