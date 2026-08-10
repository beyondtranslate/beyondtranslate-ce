/// The tokens and type recipes only BeyondTranslate itself has a use for.
///
/// The Flutter twin of `apps/storybook/src/styles/product.css`. The kit stays
/// domain-free, so anything that encodes a product concept lives here instead:
/// the provider brand colours, the marker on a preferred translation, and the
/// typography of a source / translation pair.
///
/// Everything below layers on top of the kit's theme tokens and is reached the
/// same way — `context.product` beside `context.tokens` — so it re-themes with
/// [DesignThemeName] exactly like the rest.
library;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/widgets.dart';

import '../widgets/ui.dart'
    show
        DesignThemeContext,
        DesignThemeName,
        DesignTypography,
        DesignTypographyStyles;

/// The tokens the product layer adds to the design system.
///
/// Only [highlightGlow] varies by theme, so one const instance covers the other
/// three palettes — the same shape as `product.css`, where a single `:root`
/// block is followed by two `[data-theme=…]` overrides.
@immutable
class ProductTokens {
  const ProductTokens({this.highlightGlow = const <BoxShadow>[]});

  /// The preferred translation's type — larger and airier than the source it
  /// answers to.
  static const double translationSize = 17;
  static const double translationLeading = 1.75;

  /// Provider identity — brand colours, deliberately stable across all four
  /// themes.
  static const Color providerBuiltin = Color(0xFF6B4DFF);
  static const Color providerClaude = Color(0xFFD97757);
  static const Color providerDeepl = Color(0xFF3A7BFD);
  static const Color providerDict = Color(0xFF5B7F6B);

  /// The marker on a preferred translation: the weight of its rule. 2px in
  /// every theme, and a token rather than a literal because the marker's
  /// weight is a scheme decision, not a widget's.
  static const double highlightRule = 2;

  /// Glow behind the marker dot — Studio Dark only. Bright Dark is flat by
  /// design: its canvas is bright enough that a glow would only glare.
  final List<BoxShadow> highlightGlow;

  static const ProductTokens _flat = ProductTokens();

  static const ProductTokens _studioDark = ProductTokens(
    highlightGlow: [BoxShadow(blurRadius: 10, color: Color(0xE67C5CFF))],
  );

  static ProductTokens forTheme(DesignThemeName theme) =>
      theme == DesignThemeName.studioDark ? _studioDark : _flat;

  @override
  bool operator ==(Object other) =>
      other is ProductTokens && listEquals(other.highlightGlow, highlightGlow);

  @override
  int get hashCode => Object.hashAll(highlightGlow);
}

extension ProductTokensContext on BuildContext {
  /// The product layer's tokens for the active palette.
  ProductTokens get product => ProductTokens.forTheme(themeName);
}

/// The product's own type recipes — `.type-translation` and `.type-source` in
/// `product.css`. They compose the kit's faces rather than redeclaring them.
extension ProductTypographyStyles on DesignTypography {
  /// 译文正文：CJK face, larger and airier than the source text.
  TextStyle translationStyle({Color? color}) => cjkStyle(
        fontSize: ProductTokens.translationSize,
        fontWeight: FontWeight.w400,
        height: ProductTokens.translationLeading,
        color: color,
      );

  /// 原文：same body size as the surrounding chrome, receded in colour.
  TextStyle sourceStyle({Color? color}) =>
      sansStyle(fontSize: body, height: 1.7, color: color);
}
