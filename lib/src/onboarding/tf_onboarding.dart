library introduction_screen;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding_dots.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding_options.dart';

/// Onboarding screen widget for guiding users through a series of pages before the verification process in the ThirdFactor library.
///
/// The [TfOnboarding] widget provides a customizable onboarding experience with options to define onboarding pages,
/// callbacks for button presses, custom button widgets, dots decorator, animation settings, and more.
class TfOnboarding extends StatefulWidget {
  /// Configuration options for customizing the onboarding process.
  final TfOnboardingOptions onboardingOptions;

  /// Callback function triggered upon completion of the onboarding process.
  final VoidCallback onOnboardingComplete;

  /// Creates a [TfOnboarding] instance with the provided properties.
  const TfOnboarding({
    Key? key,
    required this.onboardingOptions,
    required this.onOnboardingComplete,
  }) : super(key: key);

  @override
  TfOnboardingState createState() => TfOnboardingState();
}

class TfOnboardingState extends State<TfOnboarding> {
  late PageController _pageController;
  int _currentPage = 0;

  PageController get controller => _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get pageLength => widget.onboardingOptions.onboardingPages.length;
  int get currentPage => _currentPage;
  bool get isLastPage => currentPage == pageLength - 1;

  void next() {
    animateScroll(currentPage + 1);
  }

  void previous() {
    animateScroll(currentPage - 1);
  }

  Future<void> skipToEnd() async {
    await animateScroll(pageLength - 1);
  }

  void done() {
    if (widget.onboardingOptions.onDone != null) {
      widget.onboardingOptions.onDone!();
    }
    widget.onOnboardingComplete();
  }

  Future<void> animateScroll(int page) async {
    await _pageController.animateToPage(
      max(min(page, pageLength - 1), 0),
      duration:
          Duration(milliseconds: widget.onboardingOptions.animationDuration),
      curve: widget.onboardingOptions.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? leftBtn;
    if (widget.onboardingOptions.showSkip) {
      leftBtn = Visibility(
        visible: !isLastPage,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: OnboardingButton(
          custom: widget.onboardingOptions.skip,
          title: "Skip",
          onPressed: skipToEnd,
        ),
      );
    }

    Widget? rightBtn;
    if (isLastPage) {
      rightBtn = OnboardingButton(
        custom: widget.onboardingOptions.done,
        title: "Done",
        onPressed: done,
      );
    } else if (!isLastPage && widget.onboardingOptions.showNext) {
      rightBtn = OnboardingButton(
        title: "Next",
        custom: widget.onboardingOptions.next,
        onPressed: next,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            physics: widget.onboardingOptions.scrollPhysics,
            children: widget.onboardingOptions.onboardingPages,
          ),
          Padding(
            padding: widget.onboardingOptions.controlsPadding,
            child: SafeArea(
              child: Align(
                alignment: widget.onboardingOptions.controlAlignment,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(child: leftBtn ?? const SizedBox.shrink()),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Semantics(
                            label: "Page ${currentPage + 1} of $pageLength",
                            excludeSemantics: true,
                            child: TfDotsIndicator(
                              dotsCount: pageLength,
                              position: _currentPage,
                              decorator: widget.onboardingOptions.dotsDecorator,
                              onTap: (pos) => animateScroll(pos),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: rightBtn ?? const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Button widget used in onboarding screens for actions like "Skip," "Next," and "Done."
class OnboardingButton extends StatelessWidget {
  /// The title or text of the button.
  final String title;

  final Widget? custom;

  /// Callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// Creates an [OnboardingButton] instance with the provided properties.
  const OnboardingButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.custom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: custom ?? Text(title),
    );
  }
}
