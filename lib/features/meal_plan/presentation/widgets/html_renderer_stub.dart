import 'package:flutter/material.dart';

Widget buildHtmlRenderer(String htmlContent, String viewType) {
  return const Center(child: Text('HTML rendering is only supported on web'));
}

String registerHtmlView(String htmlContent) {
  return 'unsupported';
}
