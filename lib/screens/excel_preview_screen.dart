import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import platform specific implementations if needed, but for now we'll stick to the core plugin

class ExcelPreviewScreen extends StatefulWidget {
  final String? base64Data;
  final String title;

  const ExcelPreviewScreen({
    super.key,
    this.base64Data,
    this.title = 'Excel Preview',
  });

  @override
  State<ExcelPreviewScreen> createState() => _ExcelPreviewScreenState();
}

class _ExcelPreviewScreenState extends State<ExcelPreviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });
            // Give the JS scripts 200ms to initialize luckysheet
            await Future.delayed(const Duration(milliseconds: 300));
            // If we have data, load it after page is ready
            if (widget.base64Data != null && mounted) {
                _loadExcelData(widget.base64Data!);
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadFlutterAsset('assets/excel_viewer_html.html');
  }

  Future<void> _loadExcelData(String base64) async {
    try {
      // Use raw string in JS to avoid interpolation issues
      await _controller.runJavaScript('window.loadExcel(`${base64}`, `${widget.title}`)');
    } catch (e) {
      debugPrint("Error injecting excel JS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF217346), // Excel Dark Green
        foregroundColor: Colors.white,
        actions: [
            IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                    // Share logic
                },
            ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF217346)),
            ),
        ],
      ),
    );
  }
}
