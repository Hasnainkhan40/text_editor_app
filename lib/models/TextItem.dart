import 'package:flutter/material.dart';

class TextItem {
  String text;
  Offset position;
  double fontSize;
  FontWeight fontWeight;
  bool isItalic;
  bool isUnderline;
  String fontFamily;

  TextItem({
    required this.text,
    required this.position,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.normal,
    this.isItalic = false,
    this.isUnderline = false,
    this.fontFamily = 'Roboto',
  });

  TextItem copyWith({
    String? text,
    Offset? position,
    double? fontSize,
    FontWeight? fontWeight,
    bool? isItalic,
    bool? isUnderline,
    String? fontFamily,
  }) {
    return TextItem(
      text: text ?? this.text,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
