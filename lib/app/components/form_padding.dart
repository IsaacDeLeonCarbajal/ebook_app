import 'package:flutter/material.dart';

class FormPadding extends EdgeInsets {
  static const double verticalPadding = 30;
  static const double horizontalPadding = 10;

  const FormPadding() : super.symmetric(vertical: verticalPadding, horizontal: horizontalPadding);
}
