import 'package:flutter/material.dart';

Size boundingTextSize(String? text, TextStyle style, {int maxLines = 1, double maxWidth = double.infinity}) {
  if (text == null || text.isEmpty) {
    return Size.zero;
  }
  final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr, text: TextSpan(text: text, style: style), maxLines: maxLines)..layout(maxWidth: maxWidth);
  return textPainter.size;
}
