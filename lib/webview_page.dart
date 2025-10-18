import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final String allowedUrl = 'https://alim12586.github.io/Haf-za-oyunu-web/';
  late final WebViewController _controller;
  String lastMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('FlutterChannel', onMessageReceived: (msg) {
        setState(() {
          lastMessage = msg.message;
        });
        debugPrint('📩 Gelen mesaj: ${msg.message}');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(allowedUrl)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(allowedUrl));
  }

  void reloadPage() => _controller.reload();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafıza Oyunu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reloadPage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          if (lastMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black12,
              child: Text('📨 Sayfadan gelen mesaj: $lastMessage'),
            ),
        ],
      ),
    );
  }
}
