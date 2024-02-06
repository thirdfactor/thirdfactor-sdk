import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thirdfactor/src/onboarding/tf_onboarding_dots_decorator.dart';

/// A customizable dots indicator widget for visualizing the progress in the ThirdFactor library.
///
/// The [TfDotsIndicator] widget displays a row of dots, each representing a step or page.
/// It provides various customization options such as colors, sizes, and shapes for both active and inactive dots.
class TfDotsIndicator extends StatelessWidget {
  /// The total number of dots in the indicator.
  final int dotsCount;

  /// The current position of the active dot.
  ///
  /// Must be greater than or equal to zero and less than [dotsCount].
  final int position;

  /// The decorator that defines the appearance of the dots.
  final TfDotsDecorator decorator;

  /// Callback function triggered when a dot is tapped.
  ///
  /// The function is passed the index of the tapped dot.
  final Function(int)? onTap;

  /// Creates a [TfDotsIndicator] with the provided properties.
  TfDotsIndicator({
    Key? key,
    required this.dotsCount,
    this.position = 0,
    this.decorator = const TfDotsDecorator(),
    this.onTap,
  })  : assert(dotsCount > 0,
            'The number of dots (dotsCount) must be greater than zero.'),
        assert(position >= 0,
            'The position must be greater than or equal to zero.'),
        assert(
            position < dotsCount, 'The position must be less than dotsCount.'),
        assert(decorator.colors.isEmpty || decorator.colors.length == dotsCount,
            'The "colors" parameter in the decorator must be empty or have the same length as dotsCount parameter.'),
        assert(
            decorator.activeColors.isEmpty ||
                decorator.activeColors.length == dotsCount,
            'The "activeColors" parameter in the decorator must be empty or have the same length as dotsCount parameter.'),
        assert(decorator.sizes.isEmpty || decorator.sizes.length == dotsCount,
            'The "sizes" parameter in the decorator must be empty or have the same length as dotsCount parameter.'),
        assert(
            decorator.activeSizes.isEmpty ||
                decorator.activeSizes.length == dotsCount,
            'The "activeSizes" parameter in the decorator must be empty or have the same length as dotsCount parameter.'),
        assert(decorator.shapes.isEmpty || decorator.shapes.length == dotsCount,
            'The "shapes" parameter in the decorator must be empty or have the same length as dotsCount parameter.'),
        assert(
            decorator.activeShapes.isEmpty ||
                decorator.activeShapes.length == dotsCount,
            'The "activeShapes" parameter in the decorator must be empty or have the same length as dotsCount parameter.'),
        super(key: key);

  /// Wraps a dot widget with InkWell to enable tap interactions.
  Widget _wrapInkwell(Widget dot, int index) {
    return InkWell(
      customBorder: position == index
          ? decorator.getActiveShape(index)
          : decorator.getShape(index),
      onTap: () => onTap!(index),
      child: dot,
    );
  }

  /// Builds an individual dot based on its index.
  Widget _buildDot(BuildContext context, int index) {
    final double lerpValue = min(1, (position - index).abs()).toDouble();

    final size = Size.lerp(
      decorator.getActiveSize(index),
      decorator.getSize(index),
      lerpValue,
    )!;

    final dot = Container(
      width: size.width,
      height: size.height,
      margin: decorator.spacing,
      decoration: ShapeDecoration(
        color: Color.lerp(
          decorator.getActiveColor(index) ?? Theme.of(context).primaryColor,
          decorator.getColor(index),
          lerpValue,
        ),
        shape: ShapeBorder.lerp(
          decorator.getActiveShape(index),
          decorator.getShape(index),
          lerpValue,
        )!,
      ),
    );
    return onTap == null ? dot : _wrapInkwell(dot, index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        dotsCount,
        (i) => _buildDot(context, i),
      ),
    );
  }
}
