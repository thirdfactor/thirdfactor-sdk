import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thirdfactor/src/core/thirdfactor.dart';
import 'package:thirdfactor/src/model/tf_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class TfWebView extends StatefulWidget {
  final String verificationUrl;
  final ValueChanged<TfResponse> onCompletion;
  final LoadingBuilder loadingBuilder;

  const TfWebView({
    Key? key,
    required this.verificationUrl,
    required this.onCompletion,
    required this.loadingBuilder,
  }) : super(key: key);

  @override
  State<TfWebView> createState() => _TfWebViewState();
}

class _TfWebViewState extends State<TfWebView> {
  late final WebViewController webController;
  bool _isLoading = false;
  int _progress = 0;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _requestCameraPermission();
    await _requestGalleryPermission();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webController = WebViewController.fromPlatformCreationParams(params);

    webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
        ),
      )
      ..addJavaScriptChannel(
        "TFSDKCHANNEL",
        onMessageReceived: (JavaScriptMessage message) {
          try {
            print("Received message: ${jsonDecode(message.message)['documentPhoto'] }");
            // print("Received message: ${message.}");
            final response = TfResponse.fromJson(message.message);
            // print("Decoded response: $response");
            widget.onCompletion(response);
            Navigator.of(context).pop();
          } catch (e) {
            print("Error decoding response: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Couldn't decode response from Thirdfactor server")),
            );
            throw Exception("Couldn't decode response from Thirdfactor server");
          }
        },
      )
      ..loadRequest(Uri.parse(widget.verificationUrl));

    if (webController.platform is AndroidWebViewController) {
      AndroidWebViewController androidController = webController.platform as AndroidWebViewController;
      androidController
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setOnPlatformPermissionRequest((request) => request.grant())
        ..setOnShowFileSelector(_androidImagePicker);
    }
  }

  Future<List<String>> _androidImagePicker(FileSelectorParams params) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return [Uri.file(image.path).toString()];
      }
    } catch (e) {
      print('Error picking image: $e');
      // You might want to show a snackbar or dialog to inform the user about the error
    }
    return [];
  }

  Future<bool> _requestCameraPermission() async {
    if (await Permission.camera.isGranted) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestGalleryPermission() async {
    if (await Permission.photos.isGranted) return true;
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          LinearProgressIndicator(value: _progress / 100),
          WebViewWidget(controller: webController),
          if (_isLoading)
            Center(child: widget.loadingBuilder(context, _progress)),
        ],
      ),
    );
  }
}