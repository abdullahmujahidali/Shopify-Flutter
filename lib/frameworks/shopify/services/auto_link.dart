// import 'dart:async';
//
// // ignore: implementation_imports
// import 'package:graphql/src/link/link.dart';
// // ignore: implementation_imports
// import 'package:graphql/src/link/operation.dart';
// // ignore: implementation_imports
// import 'package:graphql/src/link/fetch_result.dart';
//
// typedef GetToken = Future<String> Function();
//
// class HeaderLink extends Link {
//   HeaderLink({
//     this.getToken,
//   }) : super(
//           request: (Operation operation, [NextLink forward]) {
//             StreamController<FetchResult> controller;
//
//             Future<void> onListen() async {
//               try {
//                 final token = await getToken();
//
//                 operation.setContext(<String, Map<String, String>>{
//                   'headers': <String, String>{
//                     'X-Shopify-Storefront-Access-Token': token
//                   }
//                 });
//               } catch (error) {
//                 controller.addError(error);
//               }
//
//               await controller.addStream(forward(operation));
//               await controller.close();
//             }
//
//             controller = StreamController<FetchResult>(onListen: onListen);
//
//             return controller.stream;
//           },
//         );
//
//   GetToken getToken;
// }
