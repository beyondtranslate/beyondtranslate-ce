import 'package:flutter/material.dart';

class IconLibrary {
  const IconLibrary({
    required this.chevronLeft,
    required this.chevronRight,
  });

  /// Create the material icon library.
  const IconLibrary.material({
    this.chevronLeft = Icons.chevron_left,
    this.chevronRight = Icons.chevron_right,
  });

  final IconData chevronLeft;
  final IconData chevronRight;
}
