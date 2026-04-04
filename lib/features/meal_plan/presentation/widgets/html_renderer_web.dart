import 'dart:convert';
import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

Widget buildHtmlRenderer(String htmlContent, String viewType) {
  return HtmlElementView(viewType: viewType);
}

String registerHtmlView(String htmlContent) {
  final viewType = 'meal-plan-${DateTime.now().millisecondsSinceEpoch}';

  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final dataUrl =
        'data:text/html;charset=utf-8;base64,${base64Encode(utf8.encode(htmlContent))}';

    return html.IFrameElement()
      ..src = dataUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
  });

  return viewType;
}
