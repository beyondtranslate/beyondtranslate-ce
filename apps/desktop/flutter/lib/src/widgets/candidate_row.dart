import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductTokens;
import 'avatar.dart' show Avatar, AvatarSize;
import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Kbd,
        KbdSize,
        Label,
        LabelTone,
        Pressable,
        kTransitionDuration;

/// The brand colours the deck gives its services, by position in the list —
/// the same order the ⌥n hints count in.
const List<Color> kProviderAvatarColors = [
  ProductTokens.providerBuiltin,
  ProductTokens.providerClaude,
  ProductTokens.providerDeepl,
  ProductTokens.providerDict,
];

/// One candidate service in a result block's 对比 list — two rows: the
/// attribution, then the text. The attribution row is itself 设为首选: a click
/// promotes the service, as ⌥n does; a glossary conflict is left to the marks
/// in the text rather than a further row of buttons; and the card frame is
/// gone, so the list lies directly on the block's tinted surface instead of
/// cutting the output area into pieces.
class CandidateRow extends StatelessWidget {
  const CandidateRow({
    super.key,
    required this.name,
    required this.avatarLabel,
    required this.avatarColor,
    this.shortcut,
    this.onPrefer,
    required this.child,
  });

  final String name;
  final String avatarLabel;
  final Color avatarColor;

  /// ⌥n — the same hint the failure cards show.
  final String? shortcut;

  /// 设为首选. Null leaves the attribution row inert — a service that has not
  /// answered yet, or answered with an error, cannot be promoted.
  final VoidCallback? onPrefer;

  /// The translation, or what stands in for it while the service works.
  final Widget child;

  /// The attribution chip hangs 6px past the text column on each side, as
  /// the deck's `-mx-1.5` does, so the name lines up with the text below
  /// while the hover wash still wraps it.
  static const double chipInset = 6;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.chip);

    final header = Row(
      children: [
        Avatar(size: AvatarSize.xs, label: avatarLabel, color: avatarColor),
        const SizedBox(width: 7),
        Expanded(
          child: Label(tone: LabelTone.subtle, child: Text(name)),
        ),
        if (shortcut != null) Kbd(shortcut!, size: KbdSize.sm),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onPrefer != null)
            Pressable(
              onPressed: onPrefer,
              borderRadius: radius,
              semanticsLabel: name,
              builder: (context, state) => AnimatedContainer(
                duration: kTransitionDuration,
                padding: const EdgeInsets.symmetric(
                  horizontal: chipInset,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: state.hovered
                      ? colors.accent.withValues(alpha: 0.12)
                      : null,
                  borderRadius: radius,
                ),
                child: header,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: chipInset,
                vertical: 4,
              ),
              child: header,
            ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: chipInset),
            child: DefaultTextStyle(
              style: tokens.typography.cjkStyle(
                fontSize: 13,
                height: 1.75,
                color: colors.fgSecondary,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
