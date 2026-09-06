enum NamedVariant {
  /// The neutral control: paper fill, hairline edge.
  normal,

  /// The workhorse neutral — the grey chip a toolbar button or a default
  /// action is, one step deeper than the paper it sits on.
  recessed,

  /// The filled variant of a widget.
  ///
  /// A filled widget has a solid background color.
  filled,

  /// The tinted variant of a widget.
  ///
  /// A tinted widget has a background color that is a shade of the primary color.
  tinted,

  /// The outlined variant of a widget.
  ///
  /// An outlined widget has a border around the widget.
  outlined,

  /// The plain variant of a widget.
  ///
  /// A plain widget has no background color and no border.
  plain,
}

/// The variant of a widget.
mixin WidgetVariant on Enum {
  NamedVariant get namedVariant =>
      NamedVariant.values.where((e) => e.name == name).first;
}
