import 'package:flutter/material.dart';

const Size kDefaultSize = Size.square(9.0);
const EdgeInsets kDefaultSpacing = EdgeInsets.all(6.0);
const ShapeBorder kDefaultShape = CircleBorder();

/// A decorator class for customizing the appearance of dots in the ThirdFactor library.
///
/// The [TfDotsDecorator] class allows you to define various properties such as color, size, shape,
/// and spacing for both active and inactive dots. It provides customization options for each dot individually.
class TfDotsDecorator {
  /// Inactive dot color.
  ///
  /// The default value is [Colors.grey].
  final Color color;

  /// List of inactive dot colors.
  /// Each dot can have a different color defined in the [colors] list.
  ///
  /// The default value is an empty list, which means the [color] parameter is applied to each dot.
  final List<Color> colors;

  /// Active dot color.
  ///
  /// The default value is [Theme.of(context).primaryColor].
  final Color? activeColor;

  /// List of active dot colors.
  /// Each dot can have a different color defined in the [activeColors] list.
  ///
  /// The default value is an empty list, which means the [activeColor] parameter is applied to each dot.
  final List<Color> activeColors;

  /// Inactive dot size.
  ///
  /// The default value is [Size.square(9.0)].
  final Size size;

  /// List of inactive dot sizes.
  /// Each dot can have a different size defined in the [sizes] list.
  ///
  /// The default value is an empty list, which means the [size] parameter is applied to each dot.
  final List<Size> sizes;

  /// Active dot size.
  ///
  /// The default value is [Size.square(9.0)].
  final Size activeSize;

  /// List of active dot sizes.
  /// Each dot can have a different size defined in the [activeSizes] list.
  ///
  /// The default value is an empty list, which means the [activeSize] parameter is applied to each dot.
  final List<Size> activeSizes;

  /// Inactive dot shape.
  ///
  /// The default value is [CircleBorder()].
  final ShapeBorder shape;

  /// List of inactive dot shapes.
  /// Each dot can have a different shape defined in the [shapes] list.
  ///
  /// The default value is an empty list, which means the [shape] parameter is applied to each dot.
  final List<ShapeBorder> shapes;

  /// Active dot shape.
  ///
  /// The default value is [CircleBorder()].
  final ShapeBorder activeShape;

  /// List of active dot shapes.
  /// Each dot can have a different shape defined in the [activeShapes] list.
  ///
  /// The default value is an empty list, which means the [activeShape] parameter is applied to each dot.
  final List<ShapeBorder> activeShapes;

  /// Spacing between dots.
  ///
  /// The default value is [EdgeInsets.all(6.0)].
  final EdgeInsets spacing;

  const TfDotsDecorator({
    this.color = Colors.grey,
    this.colors = const [],
    this.activeColor,
    this.activeColors = const [],
    this.size = kDefaultSize,
    this.sizes = const [],
    this.activeSize = kDefaultSize,
    this.activeSizes = const [],
    this.shape = kDefaultShape,
    this.shapes = const [],
    this.activeShape = kDefaultShape,
    this.activeShapes = const [],
    this.spacing = kDefaultSpacing,
  });

  /// Retrieves the active color for a specific dot index.
  Color? getActiveColor(int index) {
    return activeColors.isNotEmpty ? activeColors[index] : activeColor;
  }

  /// Retrieves the inactive color for a specific dot index.
  Color getColor(int index) {
    return colors.isNotEmpty ? colors[index] : color;
  }

  /// Retrieves the active size for a specific dot index.
  Size getActiveSize(int index) {
    return activeSizes.isNotEmpty ? activeSizes[index] : activeSize;
  }

  /// Retrieves the inactive size for a specific dot index.
  Size getSize(int index) {
    return sizes.isNotEmpty ? sizes[index] : size;
  }

  /// Retrieves the active shape for a specific dot index.
  ShapeBorder getActiveShape(int index) {
    return activeShapes.isNotEmpty ? activeShapes[index] : activeShape;
  }

  /// Retrieves the inactive shape for a specific dot index.
  ShapeBorder getShape(int index) {
    return shapes.isNotEmpty ? shapes[index] : shape;
  }
}
