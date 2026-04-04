import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget buildHtmlRenderer(String htmlContent, String viewType) {
  return _MobileHtmlRenderer(htmlContent: htmlContent);
}

String registerHtmlView(String htmlContent) {
  return 'mobile';
}

class _MobileHtmlRenderer extends StatefulWidget {
  const _MobileHtmlRenderer({required this.htmlContent});
  final String htmlContent;

  @override
  State<_MobileHtmlRenderer> createState() => _MobileHtmlRendererState();
}

class _MobileHtmlRendererState extends State<_MobileHtmlRenderer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF121212))
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  void didUpdateWidget(_MobileHtmlRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlContent != widget.htmlContent) {
      _controller.loadHtmlString(widget.htmlContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
