import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:vida_organizada/config/themes.dart';

class NavegadorScreen extends StatefulWidget {
  const NavegadorScreen({Key? key}) : super(key: key);

  @override
  State<NavegadorScreen> createState() => _NavegadorScreenState();
}

class _NavegadorScreenState extends State<NavegadorScreen> {
  late WebViewController controller;
  final TextEditingController _urlController = TextEditingController();
  final String initialUrl = 'https://www.google.com';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _urlController.text = initialUrl;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              _urlController.text = url;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegador Web'),
        backgroundColor: AppThemes.glassBlack,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    if (await controller.canGoBack()) {
                      await controller.goBack();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    if (await controller.canGoForward()) {
                      await controller.goForward();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    controller.reload();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa una URL',
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _loadUrl(_urlController.text);
                        },
                      ),
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      _loadUrl(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _loadUrl(String url) {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    controller.loadRequest(Uri.parse(url));
  }
}