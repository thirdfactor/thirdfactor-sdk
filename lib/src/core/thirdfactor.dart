/// The `thirdfactor` library provides widgets for initializing ThirdFactor Verification in a Flutter application.
/// It includes components for onboarding, web view, and client configurations.
import 'package:flutter/material.dart';
import 'package:thirdfactor/src/model/tf_response.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding_options.dart';
import 'package:thirdfactor/src/tf_webview.dart';

/// The [ThirdFactorScope] builder.
typedef ThirdFactorScopeBuilder = Widget Function(
  BuildContext,
  GlobalKey<NavigatorState>,
);

/// The default transition builder for route animations.
Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return child;
}

/// The default loading indicator builder.
Widget _defaultLoadingIndicator(
  BuildContext context,
  int progress,
) {
  return const CircularProgressIndicator.adaptive();
}

/// The [LoadingBuilder] builder.
typedef LoadingBuilder = Widget Function(
  BuildContext,
  int,
);

/// The widget that initializes ThirdFactor Verification.
class ThirdFactorScope extends StatefulWidget {
  /// Creates [ThirdFactorScope] with the provided properties.
  ///
  /// [key]: A unique identifier for the widget. If not provided, a new [Key] will be automatically assigned.
  ///
  /// [clientId]: The client identifier associated with ThirdFactorScope, used for creating a global navigation key.
  ///
  /// [builder]: A function that builds the widget tree below the [ThirdFactorScope]. It takes a [BuildContext] and a [GlobalKey<NavigatorState>] as parameters.
  ///
  /// [transitionBuilder]: A function that defines the transition animation when pushing or popping routes. Defaults to [_defaultTransitionsBuilder].
  ///
  /// [transitionDuration]: The duration of the forward transition animation. Defaults to 300 milliseconds.
  ///
  /// [reverseTransitionDuration]: The duration of the reverse transition animation (popping). Defaults to 300 milliseconds.
  ///
  /// [navigatorKey]: A global key that uniquely identifies the associated [Navigator] for navigation operations.
  ///
  /// [loadingBuilder]: A function that builds the loading indicator widget during the verification process. Defaults to [_defaultLoadingIndicator].

  ThirdFactorScope({
    Key? key,
     String clientId = "",
    required ThirdFactorScopeBuilder builder,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
        transitionBuilder = _defaultTransitionsBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    GlobalKey<NavigatorState>? navigatorKey,
    LoadingBuilder loadingBuilder = _defaultLoadingIndicator,
  })  : _navKey = navigatorKey ?? GlobalObjectKey(clientId),
        _builder = builder,
        _transitionBuilder = transitionBuilder,
        _transitionDuration = transitionDuration,
        _reverseTransitionDuration = reverseTransitionDuration,
        _clientId = clientId,
        _loadingBuilder = loadingBuilder,
        super(key: key);

  /// The ThirdFactor clientId.
  final String _clientId;
  final ThirdFactorScopeBuilder _builder;
  final GlobalKey<NavigatorState> _navKey;
  final Widget Function(
          BuildContext, Animation<double>, Animation<double>, Widget)
      _transitionBuilder;
  final Duration _transitionDuration;
  final Duration _reverseTransitionDuration;
  final LoadingBuilder _loadingBuilder;

  /// Returns the [ThirdFactorScope] instance for the widget tree
  /// that corresponds to the given [context].
  static ThirdFactorScope of(BuildContext context) {
    final _InheritedThirdFactorScope? scope =
        context.dependOnInheritedWidgetOfExactType();
    assert(scope != null, 'ThirdFactorScope could not be found in context');
    return scope!.scope;
  }

  /// Initiates the ThirdFactor Verification process, guiding the user through the onboarding flow.
  ///
  /// Parameters:
  /// - `verificationUrl`: The verification URL obtained from ThirdFactor server.
  /// - `onCancel`: Callback function triggered when the user cancels the verification process.
  /// - `onCompletion`: Callback function triggered upon completion of the verification process,
  /// indicating whether the verification was successful (`true`) or not (`false`).
  /// - `onboardingOptions`: Optional configuration for customizing the onboarding experience.
  /// This function utilizes the provided `onboardingOptions` to customize the onboarding pages and controls.
  /// If no `onboardingOptions` are provided, it shows no onboarding steps and proceeds directly to the verification.
  ///
  /// Note: Ensure that the `navigation key` from `ThirdFactorScope` is provided to `MaterialApp` or `CupertinoApp`.
  Future<void> startVerification({
    required String verificationUrl,
    required ValueChanged<TfResponse> onCompletion,
    TfOnboardingOptions? onboardingOptions,
    VoidCallback? c,
  }) async {
    try {
      final navigatorState = _navKey.currentState;
      assert(
        navigatorState != null,
        'Ensure that the navigation key from ThirdFactorScope is provided to MaterialApp or CupertinoApp.',
      );
      navigatorState!.push(
        _customPageRouteBuilder(
          onboardingOptions != null
              ? TfOnboarding(
                  onboardingOptions: onboardingOptions,
                  onOnboardingComplete: () {
                    navigatorState.pushReplacement(
                      _customPageRouteBuilder(
                        TfWebView(
                          verificationUrl: verificationUrl,
                          onCompletion: onCompletion,
                          loadingBuilder: _loadingBuilder,
                        ),
                      ),
                    );
                  },
                )
              : TfWebView(
                  verificationUrl: verificationUrl,
                  onCompletion: onCompletion,
                  loadingBuilder: _loadingBuilder,
                ),
        ),
      );
    } catch (_) {
      rethrow;
    }
  }

  PageRouteBuilder _customPageRouteBuilder(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: _transitionBuilder,
      transitionDuration: _transitionDuration,
      reverseTransitionDuration: _reverseTransitionDuration,
    );
  }

  @override
  State<ThirdFactorScope> createState() => _ThirdFactorScopeState();
}

class _ThirdFactorScopeState extends State<ThirdFactorScope>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedThirdFactorScope(
      scope: widget,
      child: widget._builder(context, widget._navKey),
    );
  }
}

class _InheritedThirdFactorScope extends InheritedWidget {
  const _InheritedThirdFactorScope({
    Key? key,
    required this.scope,
    required Widget child,
  }) : super(key: key, child: child);

  final ThirdFactorScope scope;

  @override
  bool updateShouldNotify(_InheritedThirdFactorScope old) {
    return old.scope._clientId != scope._clientId;
  }
}
