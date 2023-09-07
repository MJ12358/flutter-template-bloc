import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensionz/flutter_extensionz.dart';

class ContainerTransition extends StatelessWidget {
  const ContainerTransition({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.closedColor,
    this.closedShape = const RoundedRectangleBorder(),
    this.onClosed,
    this.openColor,
    this.tappable = false,
  });

  final CloseContainerBuilder closedBuilder;
  final OpenContainerBuilder openBuilder;
  final Color? closedColor;
  final ShapeBorder closedShape;
  final Function(Object?)? onClosed;
  final Color? openColor;
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      clipBehavior: Clip.none,
      closedColor: closedColor ?? context.theme.scaffoldBackgroundColor,
      openColor: openColor ?? context.theme.scaffoldBackgroundColor,
      closedElevation: 0.0,
      onClosed: onClosed,
      openElevation: 0.0,
      closedShape: closedShape,
      closedBuilder: closedBuilder,
      openBuilder: openBuilder,
      tappable: tappable,
    );
  }
}
