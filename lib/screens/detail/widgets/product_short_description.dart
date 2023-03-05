import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product;
import '../../../widgets/html/index.dart' as html;

class ProductShortDescription extends StatelessWidget {
  final Product product;

  const ProductShortDescription(this.product);

  @override
  Widget build(BuildContext context) {
    if (product.shortDescription?.isEmpty ?? true) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        /// JS Support for Reveal Button Plugin
        /// https://wordpress.org/plugins/coupon-reveal-button
        var jsFunction = 'spbcta_pass';
        var regExp = RegExp(
          // ignore: unnecessary_string_escapes
          '$jsFunction[(\'-\',]+?[a-zA-Z0-9_-]+',
          multiLine: true,
          caseSensitive: false,
        );

        try {
          final matches = regExp.allMatches(product.shortDescription ?? '');
          if (matches.isNotEmpty) {
            var match = matches.first.group(0).toString();
            var coupon = base64
                .decode(match.replaceAll('$jsFunction(\'', '').toString());
            var snackBar = SnackBar(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              duration: const Duration(seconds: 20),
              backgroundColor: Theme.of(context).primaryColorLight,
              content: Text(
                utf8.decode(coupon),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: const Color(0xFF750B2B),
                    ),
              ),
              action: SnackBarAction(
                label: S.of(context).cancel,
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar,
            );
          }
        } catch (error) {
          printLog(error);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: html.HtmlWidget(
          product.shortDescription!,
        ),
      ),
    );
  }
}
