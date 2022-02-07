// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';

class MyTemplate extends BeautifulPopupTemplate {
  @override
  final BeautifulPopup options;
  MyTemplate(this.options) : super(options);

  @override
  Color get primaryColor => options.primaryColor ?? const Color(0xff000000); // The default primary color of the template is Colors.black.
  @override
  final maxWidth = 400; // In most situations, the value is the illustration size.
  @override
  final maxHeight = 600;
  @override
  final bodyMargin = 10;

  // You need to adjust the layout to fit into your illustration.
  @override
  get layout {
    return [
      Positioned(
        top: percentH(20),
        child: title,
      ),
      Positioned(
        top: percentH(30),
        height: percentH(actions == null ? 32 : 52),
        left: percentW(0),
        right: percentW(0),
        child: content,
      ),
      Positioned(
        bottom: percentW(28),
        left: percentW(10),
        right: percentW(10),
        child: actions ?? Container(),
      ),
    ];
  }
}
