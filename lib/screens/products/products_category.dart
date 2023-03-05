// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../widgets/common/refresh_scroll_physics.dart';
// import '../../widgets/product/product_bottom_sheet.dart';
//
// class ProductCategory extends StatelessWidget {
//   final ExpandingBottomSheet? expandingBottomSheet;
//   final Widget child;
//   final Future<void> Function() onRefresh;
//
//   const ProductCategory(
//       {Key? key,
//       required this.child,
//       required this.onRefresh,
//       this.expandingBottomSheet})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: child,
//         ),
//         // CupertinoPageScaffold(
//         //   backgroundColor: Theme.of(context).backgroundColor,
//         //   child: CustomScrollView(
//         //     physics: const RefreshScrollPhysics(),
//         //     slivers: [
//         //       CupertinoSliverNavigationBar(
//         //         backgroundColor: Theme.of(context).backgroundColor,
//         //         largeTitle: const Text('Category'),
//         //       ),
//         //       // CupertinoSliverRefreshControl(
//         //       //   onRefresh: () async {
//         //       //     await Future.wait([]);
//         //       //   },
//         //       // ),
//         //       SliverPadding(
//         //         padding: const EdgeInsets.symmetric(vertical: 8),
//         //         sliver: SliverToBoxAdapter(
//         //           child: Column(
//         //             mainAxisSize: MainAxisSize.max,
//         //             crossAxisAlignment: CrossAxisAlignment.start,
//         //             children: [child],
//         //           ),
//         //         ),
//         //       ),
//         //       // SliverList(
//         //       //   delegate: SliverChildListDelegate([child]),
//         //       // ),
//         //     ],
//         //   ),
//         // ),
//         Align(
//           alignment: Alignment.bottomRight,
//           child: expandingBottomSheet,
//         )
//       ],
//     );
//   }
// }
