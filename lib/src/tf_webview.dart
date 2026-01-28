// import 'package:flutter/material.dart';
// import 'package:thirdfactor/src/core/thirdfactor.dart';
// import 'package:thirdfactor/src/model/tf_response.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// /// WebView screen for displaying the verification URL in a web view within the ThirdFactor library.
// ///
// /// The [TfWebView] widget creates a web view and loads the provided verification URL.
// class TfWebView extends StatefulWidget {
//   /// The verification URL to be displayed in the web view.
//   final String verificationUrl;
//
//   /// Callback function triggered upon completion of the verification process.
//   final ValueChanged<TfResponse> onCompletion;
//
//   /// The loading builder with callbacks for the current progress.
//   final LoadingBuilder loadingBuilder;
//
//   /// Creates a [TfWebView] instance with the provided verification URL.
//   const TfWebView({
//     Key? key,
//     required this.verificationUrl,
//     required this.onCompletion,
//     required this.loadingBuilder,
//   }) : super(key: key);
//
//   @override
//   State<TfWebView> createState() => _TfWebViewState();
// }
//
// class _TfWebViewState extends State<TfWebView> {
//   /// Web view controller for handling web view interactions.
//   late final WebViewController webController;
//   bool _isLoading = false;
//   int _progress = 0;
//   @override
//   void initState() {
//     super.initState();
//     _requestCameraPermission();
//     // Determine the appropriate platform-specific web view controller creation parameters.
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     // Create a web view controller with the specified parameters.
//     final WebViewController controller =
//         WebViewController.fromPlatformCreationParams(params);
//
//     // Configure the web view controller settings and load the verification URL.
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(onPageFinished: (_) {
//           if (mounted) {
//             setState(() {
//               _isLoading = false;
//             });
//           }
//         }, onPageStarted: (_) {
//           if (mounted) {
//             setState(() {
//               _isLoading = true;
//             });
//           }
//         }, onProgress: (progress) {
//           if (mounted) {
//             setState(() {
//               _progress = progress;
//             });
//           }
//         }),
//       )
//       ..addJavaScriptChannel("TFSDKCHANNEL",
//           onMessageReceived: (JavaScriptMessage message) {
//         try {
//           final response = TfResponse.fromJson(message.message);
//           widget.onCompletion(response);
//           Navigator.of(context).pop();
//         } catch (_) {
//           throw Exception("Couldn't decode response from Thirdfactor server");
//         }
//       })
//       ..loadRequest(
//         Uri.parse(widget.verificationUrl),
//       );
//
//     // Configure additional settings for Android web view controllers.
//     if (controller.platform is AndroidWebViewController) {
//       (controller.platform as AndroidWebViewController)
//         ..setMediaPlaybackRequiresUserGesture(false)
//         ..setOnPlatformPermissionRequest((request) {
//           request.grant();
//         });
//     }
//
//     // Set the web view controller to the local variable for state management.
//     webController = controller;
//   }
//
//   // Function to request camera permission
//   Future<bool> _requestCameraPermission() async {
//     // Check if camera permission is already granted
//     if (await Permission.camera.isGranted) {
//       return true;
//     }
//
//     // Request camera permission
//     final status = await Permission.camera.request();
//
//     return status.isGranted;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Stack(
//         children: [
//           LinearProgressIndicator(
//             value: _progress.toDouble(),
//           ),
//           WebViewWidget(controller: webController),
//           Center(
//             child: _isLoading
//                 ? widget.loadingBuilder(context, _progress)
//                 : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }
// }
