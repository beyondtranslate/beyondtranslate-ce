import 'package:flutter/widgets.dart';

import '../../theme/product_tokens.dart' show ProductTokens;
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

  /// Brand artwork is grouped under `provider_icons/` — LLM providers in
  /// `llm/`, traditional translation engines in `traditional/`. The bundle is
  /// compiled in, so membership has to be spelled out — an `AssetImage` for a
  /// file that is not there throws at paint time.
  static const Map<String, String> _assets = {
    'anthropic': 'provider_icons/llm/anthropic.png',
    'baidu': 'provider_icons/traditional/baidu.png',
    'caiyun': 'provider_icons/traditional/caiyun.png',
    'deepl': 'provider_icons/traditional/deepl.png',
    'deepseek': 'provider_icons/llm/deepseek.png',
    'doubao': 'provider_icons/llm/doubao.png',
    'gemini': 'provider_icons/llm/gemini.png',
    'google': 'provider_icons/traditional/google.png',
    'grok': 'provider_icons/llm/grok.png',
    'groq': 'provider_icons/llm/groq.png',
    'iciba': 'provider_icons/traditional/iciba.png',
    'moonshot': 'provider_icons/llm/moonshot.png',
    'ollama': 'provider_icons/llm/ollama.png',
    'openai': 'provider_icons/llm/openai.png',
    'qwen': 'provider_icons/llm/qwen.png',
    'sogou': 'provider_icons/traditional/sogou.png',
    'tencent': 'provider_icons/traditional/tencent.png',
    'xai': 'provider_icons/llm/xai.png',
    'youdao': 'provider_icons/traditional/youdao.png',
    'zhipu': 'provider_icons/llm/zhipu.png',
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
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.color)
              : null,
        ),
        borderRadius: radius,
        border:
            border ??
            Border.all(
              color: tokens.colors.hairline,
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
    final background = switch (type) {
      'system' => ProductTokens.providerBuiltin,
      'anthropic' => ProductTokens.providerClaude,
      'deepl' => ProductTokens.providerDeepl,
      _ => ProductTokens.providerDict,
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
