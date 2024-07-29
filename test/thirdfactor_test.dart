import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding.dart';
import 'package:thirdfactor/src/tf_webview.dart';
import 'package:thirdfactor/thirdfactor.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'mocks/thirdfactor_mocks.dart';

void main() {
  group('WebView', () {
    // Set the mock implementation before running tests
    setUp(() {
      // WebViewPlatform.instance = MockWebViewPlatform();
    });

    testWidgets(
        'ThirdFactorScope shows onboarding and then proceeds to verification.',
        (tester) async {
      await tester.pumpWidget(ThirdFactorScope(
        clientId: 'testClientId',
        builder: (context, navigatorKey) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            home:
                const MyTestWidget(), // Your widget that uses ThirdFactorScope
          );
        },
      ));

      // Start Verification to show onboarding
      await tester.tap(find.text('Start Verification'));
      await tester.pumpAndSettle();

      expect(
        find.byType(ThirdFactorScope),
        findsOneWidget,
        reason: "Thirdfactor scope found successfully.",
      );

      expect(
        find.byType(TfOnboarding),
        findsOneWidget,
        reason: "Onboarding shown as TfOnboarding Options is not null.",
      );

      // Simulate completing onboarding
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Ensure web view is shown after completing onboarding
      expect(
        find.byType(TfWebView),
        findsOneWidget,
        reason: "Started webview for the verification once done is pressed.",
      );
    });
  });
}

class MyTestWidget extends StatelessWidget {
  const MyTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ThirdFactorScope.of(context);

    return ElevatedButton(
      onPressed: () {
        scope.startVerification(
          verificationUrl: 'https://demo.thirdfactor.ai/',
          onCompletion: (response) {},
          onboardingOptions: TfOnboardingOptions(
            onboardingPages: [
              const SizedBox.shrink(),
            ],
            done: const Text("Done"),
          ),
        );
      },
      child: const Text('Start Verification'),
    );
  }
}
