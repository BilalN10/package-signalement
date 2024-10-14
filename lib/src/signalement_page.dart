// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_signalement/src/core/pages/signalement_submited.dart';
import 'package:package_signalement/src/model/signalement_fields.dart';
import 'package:package_signalement/src/model/theme/signalement_theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
import 'package:dartz/dartz.dart' as dz;

class SignalementPage<T> extends StatefulWidget {
  const SignalementPage({
    Key? key,
    this.onPop,
    this.onValidatePressed,
    this.signalementTheme,
    this.signalementThemeName,
    this.title,
    this.subtitle,
    this.footer,
    this.validateText,
    this.showDescriptionReport = true,
    this.showFileReport = true,
    this.fileFieldname,
    this.descriptionFieldname,
    this.descriptionHint,
    required this.fieldItem,
    required this.validator,
    this.showSuccessPage = true,
    this.successPageBuilder,
  }) : super(key: key);

  /// Fonction lorsque le bouton de retour est appuyé
  final VoidCallback? onPop;

  final VoidCallback? onValidatePressed;

  /// ThemeData
  final SignalementThemeData? signalementTheme;

  /// ThemeName
  final String? signalementThemeName;

  /// Titre de la page
  final String? title;

  /// Sous-Titre de la page
  final String? subtitle;

  /// Text de fin de page
  final String? footer;

  /// Text du bouto de validation
  final String? validateText;

  /// Champ de description du signalement ou non
  final bool showDescriptionReport;

  /// Champ d'import de fichier d'appuis du signalement ou non
  final bool showFileReport;

  /// Model du champ de selection à choix multiples
  final FieldModel<T> fieldItem;

  /// Fonction de validation du remplissage de formulaire
  final FutureOr<bool> Function(List<dz.Tuple2<int, ItemModel<T>>> listSelectForms, String? description, PlatformFile? file) validator;

  final String? descriptionFieldname;
  final String? descriptionHint;
  final String? fileFieldname;
  final bool showSuccessPage;
  final Widget Function(BuildContext)? successPageBuilder;

  @override
  State<SignalementPage<T>> createState() => _SignalementPageState<T>();
}

class _SignalementPageState<T> extends State<SignalementPage<T>> {
  List<dz.Tuple2<int, ItemModel<T>>> listSelectForms = [];

  String? description;
  PlatformFile? file;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SignalementThemeData themeData = loadThemeData(
      widget.signalementTheme,
      widget.signalementThemeName ?? "signalement_page",
      () => const SignalementThemeData(),
    )!;

    printInDebug(listSelectForms);
    List<Widget> fields = [];
    for (final item in listSelectForms) {
      if (item.value2.childField != null) {
        final FieldModel<T> tmpItem = item.value2.childField!;
        printInDebug("add item: $tmpItem");
        fields.add(
          SelectForm<T>(
            fieldName: tmpItem.fieldName,
            hintText: tmpItem.fieldHint,
            items: tmpItem.items.map((e) => DropdownMenuItem<T>(value: e.value, child: e.child)).toList(),
            onChangedSelect: (value) {
              listSelectForms.removeWhere((element) => element.value1 > item.value1);
              listSelectForms.add(dz.Tuple2<int, ItemModel<T>>(item.value1 + 1, tmpItem.items.firstWhere((element) => element.value == value)));
              setState(() {});
            },
          ),
        );
        fields.add(sh(20));
      }
    }

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: themeData.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: formatHeight(23)),
                    Padding(
                      padding: EdgeInsets.only(left: formatWidth(12)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CTA.back(
                          theme: themeData.themeBack,
                          themeName: themeData.themeNameBack,
                          onTap: widget.onPop ??
                              (() {
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: formatWidth(29)),
                      child: Column(
                        children: [
                          SizedBox(height: formatHeight(32)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.title ?? "signalement.page-title".tr(),
                              style: themeData.titleStyle ??
                                  TextStyle(
                                    color: const Color(0xFF02132B),
                                    fontSize: sp(24),
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          SizedBox(height: formatHeight(9)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.subtitle ?? "signalement.page-subtitle".tr(),
                              style: themeData.subtitleStyle ??
                                  TextStyle(
                                    color: const Color(0xFF02132B).withOpacity(0.65),
                                    fontSize: sp(13),
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          SizedBox(height: formatHeight(18)),
                          SelectForm<T>(
                            fieldName: widget.fieldItem.fieldName,
                            hintText: widget.fieldItem.fieldHint,
                            items: widget.fieldItem.items.map((e) => DropdownMenuItem<T>(value: e.value, child: e.child)).toList(),
                            onChangedSelect: (value) {
                              // listSelectForms.removeWhere((element) => element.value1 >= 0);
                              listSelectForms.clear();
                              listSelectForms = List.from([
                                dz.Tuple2<int, ItemModel<T>>(0, widget.fieldItem.items.firstWhere((element) => element.value == value)),
                              ]);
                              printInDebug(listSelectForms);
                              setState(() {});
                            },
                          ),
                          sh(20),
                          ...fields,
                          if (widget.showDescriptionReport) ...[
                            TextFormUpdated.textarea(
                              theme: themeData.themeDescription,
                              hintText: widget.descriptionHint ?? "signalement.description.hint".tr(),
                              fieldName: widget.descriptionFieldname ?? "signalement.description.field-name".tr(),
                              onChanged: (str) => description = str,
                            ),
                            sh(20),
                          ],
                          if (widget.showFileReport) ...[
                            Input.validatedFile(
                              height: formatHeight(180),
                              onChanged: (p0) => file = p0,
                              fieldName: widget.fileFieldname ?? "signalement.file.field-name".tr(),
                            ),
                            sh(20),
                          ],
                          sh(10),
                          CTA.primary(
                            textButton: widget.validateText ?? "signalement.submit-button".tr(),
                            theme: themeData.themeValidate,
                            themeName: themeData.themeNameValidate,
                            onTap: () async {
                              final res = await widget.validator(listSelectForms, description, file);
                              if (res) widget.onValidatePressed?.call();
                              printInDebug(res);
                              if (res && widget.showSuccessPage) {
                                printInDebug("show signalement success page");
                                execAfterBuild(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        body: SafeArea(
                                          child: SubmitedPage(theme: themeData, successPageBuilder: widget.successPageBuilder),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                          Column(
                            children: [
                              SizedBox(height: formatHeight(12)),
                              Text(
                                widget.footer ?? "signalement.footer".tr(),
                                style: themeData.footerStyle ??
                                    TextStyle(
                                      color: const Color(0xFF02132B).withOpacity(0.75),
                                      fontSize: sp(12),
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: formatHeight(24)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void fooBuilder(int level, model) {
  //   if (/*Tuple2 Dartz*/ list.length >= level && list.where(e => e.value1 == level + 1).isNotEmpty) {
  //     fooBuilder(level + 1, list.where(e => e.value1 == level + 1).first);
  //   }
  // }
}
