import 'package:flutter/widgets.dart';

import '../../utils/r.dart';
import '../ui.dart' show DesignThemeContext, DesignTypographyStyles;

/// The provider's identity mark — the deck's `ProviderAvatar`.
///
/// Brand artwork ships for the providers that have it; the rest fall back to
/// the design system's lettered square, so a row never renders a hole for a
/// provider we have no logo for.
class ProviderIcon extends StatelessWidget {
  const ProviderIcon(
    this.type, {
    super.key,
    this.size = 22,
    this.color,
    this.border,
  });

  /// The provider type value as the runtime spells it — `deepl`, `anthropic`,
  /// `openai_compatible`.
  final String type;
  final double size;
  final Color? color;
  final Border? border;

  /// Brand artwork lives in two folders that grew at different times. The
  /// bundle is compiled in, so membership has to be spelled out — an
  /// `AssetImage` for a file that is not there throws at paint time.
  static const Map<String, String> _assets = {
    'anthropic': 'ai_provider_icons/anthropic.png',
    'baidu': 'translation_engine_icons/baidu.png',
    'caiyun': 'translation_engine_icons/caiyun.png',
    'deepl': 'translation_engine_icons/deepl.png',
    'deepseek': 'ai_provider_icons/deepseek.png',
    'gemini': 'ai_provider_icons/gemini.png',
    'google': 'translation_engine_icons/google.png',
    'grok': 'ai_provider_icons/grok.png',
    'iciba': 'translation_engine_icons/iciba.png',
    'ollama': 'ai_provider_icons/ollama.png',
    'openai': 'translation_engine_icons/openai.png',
    'qwen': 'ai_provider_icons/qwen.png',
    'sogou': 'translation_engine_icons/sogou.png',
    'tencent': 'translation_engine_icons/tencent.png',
    'xai': 'ai_provider_icons/xai.png',
    'youdao': 'translation_engine_icons/youdao.png',
  };

  /// True when [type] has brand artwork — callers that need to know before
  /// laying out (a tag that sizes to its mark) can ask.
  static bool hasAsset(String type) => _assets.containsKey(type);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = BorderRadius.circular(tokens.radii.avatar);
    final asset = _assets[type];

    if (asset == null) {
      return _LetterMark(type: type, size: size, radius: radius);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(R.image(asset)),
          fit: BoxFit.cover,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.color) : null,
        ),
        borderRadius: radius,
        border: border ??
            Border.all(
              color: tokens.colors.border,
              width: context.hairlineWidth,
            ),
      ),
    );
  }
}

/// The lettered square the deck draws for a provider with no artwork: the
/// brand colour where the palette carries one, its initial on top.
class _LetterMark extends StatelessWidget {
  const _LetterMark({
    required this.type,
    required this.size,
    required this.radius,
  });

  final String type;
  final double size;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final background = switch (type) {
      'system' => colors.providerBuiltin,
      'anthropic' => colors.providerClaude,
      'deepl' => colors.providerDeepl,
      _ => colors.providerDict,
    };

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, borderRadius: radius),
        child: Text(
          type.isEmpty ? '?' : type.substring(0, 1).toUpperCase(),
          style: tokens.typography.displayStyle(
            // The deck runs the glyph at a little over half the box.
            fontSize: size * 0.55,
            fontWeight: FontWeight.w700,
            height: 1,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
