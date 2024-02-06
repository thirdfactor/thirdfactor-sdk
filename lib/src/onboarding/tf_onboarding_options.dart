import 'package:flutter/material.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding_dots_decorator.dart';

/// Configuration options for customizing the behavior and appearance of the onboarding process in the ThirdFactor library.
///
/// The [TfOnboardingOptions] class allows you to define various properties such as onboarding pages,
/// callbacks for button presses, custom button widgets, dots decorator, animation settings, and more.
class TfOnboardingOptions {
  /// List of onboarding pages.
  ///
  /// Each page is represented by a widget.
  final List<Widget> onboardingPages;

  /// Callback function triggered when the Done button is pressed.
  final VoidCallback? onDone;

  /// Callback function triggered when the page changes.
  final ValueChanged<int>? onPageChanged;

  /// Custom child widget for the Done button.
  final Widget? done;

  /// Custom child widget for the Skip button.
  final Widget? skip;

  /// Custom child widget for the Next button.
  final Widget? next;

  /// Determines whether the Skip button should be visible.
  final bool showSkip;

  /// Determines whether the Next button should be visible.
  final bool showNext;

  /// Dots decorator to customize dots' color, size, and spacing.
  final TfDotsDecorator dotsDecorator;

  /// Animation duration in milliseconds.
  ///
  /// The default value is `350`.
  final int animationDuration;

  /// Type of animation between pages.
  ///
  /// The default value is `Curves.easeIn`.
  final Curve curve;

  /// Padding for control buttons.
  ///
  /// The default value is `EdgeInsets.all(16.0)`.
  final EdgeInsets controlsPadding;

  /// PageView scroll physics (only applicable when freeze is set to false).
  ///
  /// The default value is `BouncingScrollPhysics()`.
  final ScrollPhysics scrollPhysics;

  /// Alignment for control buttons in the onboarding screen.
  ///
  /// The default value is `Alignment.topCenter`.
  final Alignment controlAlignment;

  /// Creates a [TfOnboardingOptions] instance with the provided properties.
  TfOnboardingOptions({
    required this.onboardingPages,
    this.onDone,
    this.onPageChanged,
    this.done,
    this.skip,
    this.next,
    this.dotsDecorator = const TfDotsDecorator(),
    this.animationDuration = 350,
    this.curve = Curves.easeIn,
    this.controlsPadding = const EdgeInsets.all(32.0),
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.showNext = true,
    this.showSkip = true,
    this.controlAlignment = Alignment.topCenter,
  }) : assert(
          onboardingPages.isNotEmpty,
          "You must provide at least one page using the onboardingPages parameter!",
        );
}
