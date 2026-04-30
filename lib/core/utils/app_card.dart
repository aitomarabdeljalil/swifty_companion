import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.radius = 16,
    this.onTap,
    this.enableHover = true,
    this.enableGradient = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double radius;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool enableGradient;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final surface = brightness == Brightness.light
        ? Colors.white
        : theme.colorScheme.surface;
    final borderColor = brightness == Brightness.light
        ? Colors.black.withOpacity(0.05)
        : theme.colorScheme.outline.withOpacity(0.25);
    final shadowColor = brightness == Brightness.light
        ? Colors.black.withOpacity(0.08)
        : Colors.black.withOpacity(0.35);

    final scale = _pressed ? 0.98 : 1.0;
    final blur = _pressed ? 6.0 : 10.0;
    final spread = _pressed ? 0.5 : 1.5;

    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      scale: scale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: borderColor),
          gradient: widget.enableGradient
              ? LinearGradient(
                  colors: [
                    surface,
                    surface.withOpacity(0.94),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: blur,
              spreadRadius: spread,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.radius),
            onTap: widget.onTap,
            onHighlightChanged: widget.onTap == null
                ? null
                : (value) => setState(() => _pressed = value),
            onHover: widget.enableHover
                ? (value) => setState(() => _pressed = value)
                : null,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
