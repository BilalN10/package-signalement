import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

/// {@category Theme}
class SignalementThemeData {
  const SignalementThemeData({
    this.titleStyle,
    this.subtitleStyle,
    this.footerStyle,
    this.themeBack,
    this.themeNameBack,
    this.themeNameValidate,
    this.themeValidate,
    this.themeDropDown,
    this.themeDescription,
    this.themeFiles,
    this.backgroundColor,
    this.checkBackgroundColor,
    this.checkColor,
  });

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? footerStyle;
  final CtaThemeData? themeBack;
  final String? themeNameBack;
  final CtaThemeData? themeValidate;
  final String? themeNameValidate;
  final CustomFormFieldThemeData? themeDropDown;
  final CustomFormFieldThemeData? themeDescription;
  final CustomFormFieldThemeData? themeFiles;
  final Color? backgroundColor;

  final Color? checkColor;
  final Color? checkBackgroundColor;
}
