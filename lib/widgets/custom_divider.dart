import 'package:flutter/material.dart';
import 'package:zen_mobile/provider/theme_provider.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    required this.themeProvider,
    this.margin = const EdgeInsets.only(top: 0, bottom: 0),
    this.color,
    this.width
  });

  final ThemeProvider themeProvider;
  final EdgeInsets margin;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: width ?? 1,
      color: color ?? themeProvider.themeManager.borderDisabledColor,
    );
  }
}
