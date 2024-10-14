import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_signalement/package_signalement.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

/// {@category Widget}
/// {@category Page}
/// Page de post-signalement
class SubmitedPage extends StatefulWidget {
  /// Titre de la page
  final String? title;
  /// Sous-Titre de la page
  final String? subtitle;
  /// ThemeData de la page
  final SignalementThemeData? theme;
  /// Nom du theme
  final String? themeName;
  /// Fonction de création de votre propre page
  final Widget Function(BuildContext)? successPageBuilder;

  const SubmitedPage({
    this.title,
    this.subtitle,
    this.theme,
    this.themeName,
    this.successPageBuilder,
    super.key,
  });

  @override
  State<SubmitedPage> createState() => _SubmitedPageState();
}

class _SubmitedPageState extends State<SubmitedPage> {
  @override
  Widget build(BuildContext context) {
    final SignalementThemeData theme = loadThemeData(
      widget.theme,
      widget.themeName ?? "signalement_page",
      () => const SignalementThemeData(),
    )!;
    return widget.successPageBuilder?.call(context) ??
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              const SizedBox(width: double.infinity, height: double.infinity),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: formatWidth(41),
                        height: formatWidth(41),
                        decoration: BoxDecoration(color: theme.checkBackgroundColor ?? Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(100)),
                        child: Center(child: Icon(Icons.check_rounded, color: theme.checkColor ?? Colors.white, size: formatWidth(24))),
                      ),
                      sh(14),
                      Text('signalement.success'.tr(), style: theme.titleStyle),
                      sh(5),
                      Text('signalement.success-content'.tr(), style: theme.subtitleStyle),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CTA.primary(
                      textButton: "signalement.back".tr(),
                      onTap: () => Navigator.pop(context),
                    ),
                    sh(30)
                  ],
                ),
              )
            ],
          ),
        );
  }
}
