import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

TextTheme buildTextTheme(
  TextTheme base,
  String? language, [
  String fontFamily = 'Roboto',
  String fontHeader = 'Raleway',
]) {
  return base
      .copyWith(
        displayLarge: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.displayLarge!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ).copyWith(

            /// If using the custom font
            /// un-comment below and clone to other headline.., bodyText..
            // fontFamily: 'Your Custom Font',
            ),
        displayMedium: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.displayLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        displaySmall: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.displaySmall!.copyWith(fontWeight: FontWeight.w700),
        ),
        headlineMedium: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headlineMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
        headlineSmall: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
        ),
        titleLarge: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.titleLarge!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ).copyWith(
            // fontFamily: 'Your Custom Font',
            ),
        bodySmall: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.bodySmall!
              .copyWith(fontWeight: FontWeight.w400, fontSize: 14.0),
        ),
        titleMedium: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.titleMedium!.copyWith(),
        ),
        titleSmall: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.titleSmall!.copyWith(),
        ),
        bodyLarge: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.bodyLarge!.copyWith(),
        ),
        bodyMedium: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.bodyLarge!.copyWith(),
        ),
        labelLarge: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.labelLarge!
              .copyWith(fontWeight: FontWeight.w400, fontSize: 14.0),
        ),
      )
      .apply(
        displayColor: kGrey900,
        bodyColor: kGrey900,
      );
}
