import 'package:flutter/material.dart';

/// {@category Model}
/// Champs à choix multiples pouvant s'étendre à l'infini avec une [List]<[ItemModel]> 
class FieldModel<T> {
  /// Nom du champ de selection
  final String? fieldName;

  /// Texte d'attente de choix
  final String? fieldHint;

  /// Liste des possibilités à choisir
  /// [ItemModel]
  final List<ItemModel<T>> items;

  const FieldModel({
    this.fieldHint,
    this.fieldName,
    required this.items,
  });
}

/// {@category Model}
/// Item avec la possibilité de retourner un [FieldModel]
class ItemModel<T> {
  /// Valeur/id de l'item
  final T value;

  /// Valeur renvoyé/affiché par l'item
  final Widget child;

  /// Item possédant ses propres items ou non
  final FieldModel<T>? childField;

  ItemModel({
    required this.child,
    required this.value,
    this.childField,
  });
}
