import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/shared/widgets/glass_app_bar.dart';

class NavegadorScreen extends StatefulWidget {
  final String? initialUrl;
  
  const NavegadorScreen({
    Key? key,
    this.initialUrl,
  }) : super(key: key);

  @override
  State<NavegadorScreen> createState() => _NavegadorScreenState();
}

class _NavegadorScreenState extends State<NavegadorScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  String _currentUrl = '';
  final TextEditingController _urlController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _setupWebView();
  }
  
  void _setupWebView() {
    final initialUrl = widget.initialUrl ?? 'https://www.google.com';
    _currentUrl = initialUrl;
    _urlController.text = initialUrl;
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
              _urlController.text = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onUrlChange: (UrlChange urlChange) {
            setState(() {
              _currentUrl = urlChange.url ?? _currentUrl;
              _urlController.text = _currentUrl;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Manejar errores
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  void _navigateToUrl(String url) {
    String processedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      processedUrl = 'https://$url';
    }
    _controller.loadRequest(Uri.parse(processedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: const Text('Navegador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              _showSaveBookmarkDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de URL personalizada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: AppThemes.glassEffect(
              color: Colors.black,
              opacity: 0.7,
              borderRadius: 0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    if (await _controller.canGoBack()) {
                      await _controller.goBack();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    if (await _controller.canGoForward()) {
                      await _controller.goForward();
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese URL o busque',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _navigateToUrl(_urlController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _navigateToUrl(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Indicador de progreso
          if (_isLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: AppThemes.primaryBlue,
            ),
          
          // WebView
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
  
  void _showSaveBookmarkDialog() {
    final TextEditingController titleController = TextEditingController();
    titleController.text = "Nueva Página";
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guardar enlace'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'URL: $_currentUrl',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar guardado de enlaces
              // Aquí se guardaría el enlace en la base de datos
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Enlace guardado correctamente'),
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}