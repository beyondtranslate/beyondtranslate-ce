enum NamedTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// The tint of a widget.
mixin WidgetTint on Enum {
  NamedTint get namedTint =>
      NamedTint.values.where((e) => e.name == name).first;
}
