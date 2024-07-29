// import 'package:flutter/material.dart';
// import 'package:mockito/mockito.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_platform_interface/src/platform_webview_controller.dart';
// import 'package:webview_flutter_platform_interface/src/platform_navigation_delegate.dart';
// import 'package:webview_flutter_platform_interface/src/platform_webview_widget.dart';
// import 'package:webview_flutter_platform_interface/src/types/load_request_params.dart';

// // Mock implementation for WebViewPlatform using Mockito
// class MockWebViewPlatform extends Mock
//     with MockPlatformInterfaceMixin
//     implements WebViewPlatform {
//   // Create a mock PlatformWebViewController
//   @override
//   PlatformWebViewController createPlatformWebViewController(
//       PlatformWebViewControllerCreationParams params) {
//     return MockPlatformWebViewController();
//   }

//   // Create a mock PlatformNavigationDelegate
//   @override
//   PlatformNavigationDelegate createPlatformNavigationDelegate(
//       PlatformNavigationDelegateCreationParams params) {
//     return MockPlatformNavDelegate();
//   }

//   // Create a mock PlatformWebViewWidget
//   @override
//   PlatformWebViewWidget createPlatformWebViewWidget(
//       PlatformWebViewWidgetCreationParams params) {
//     return MockPlatformWebViewWidget();
//   }
// }

// // Mock implementation for PlatformWebViewWidget
// class MockPlatformWebViewWidget extends Mock
//     with MockPlatformInterfaceMixin
//     implements PlatformWebViewWidget {
//   // Mock build method to return an empty SizedBox
//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox.shrink();
//   }
// }

// // Mock implementation for PlatformWebViewController
// class MockPlatformWebViewController extends Mock
//     with MockPlatformInterfaceMixin
//     implements PlatformWebViewController {
//   // Mock implementation of setJavaScriptMode
//   @override
//   Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
//     return;
//   }

//   // Mock implementation of setPlatformNavigationDelegate
//   @override
//   Future<void> setPlatformNavigationDelegate(
//       PlatformNavigationDelegate handler) async {
//     return;
//   }

//   // Mock implementation of addJavaScriptChannel
//   @override
//   Future<void> addJavaScriptChannel(
//       JavaScriptChannelParams javaScriptChannelParams) async {
//     return;
//   }

//   // Mock implementation of loadRequest
//   @override
//   Future<void> loadRequest(LoadRequestParams params) async {
//     return;
//   }
// }

// // Mock implementation for PlatformNavigationDelegate
// class MockPlatformNavDelegate extends Mock
//     with MockPlatformInterfaceMixin
//     implements PlatformNavigationDelegate {
//   // Mock implementation of setOnPageStarted
//   @override
//   Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {
//     return;
//   }

//   // Mock implementation of setOnPageFinished
//   @override
//   Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
//     return;
//   }

//   // Mock implementation of setOnProgress
//   @override
//   Future<void> setOnProgress(ProgressCallback onProgress) async {
//     return;
//   }

//   // Mock implementation of setOnNavigationRequest
//   @override
//   Future<void> setOnNavigationRequest(
//       NavigationRequestCallback onNavigationRequest) async {
//     return;
//   }
// }
