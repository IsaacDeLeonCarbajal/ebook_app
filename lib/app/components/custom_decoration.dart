import 'package:flutter/material.dart';

class CustomDecoration extends InputDecoration {
  CustomDecoration(String labelText, {String? hintText})
      : super(
          label: Text(labelText),
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
          hintText: hintText,
        );
}
