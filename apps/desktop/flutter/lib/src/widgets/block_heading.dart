import 'package:flutter/widgets.dart';

import '../i18n/i18n.dart';
import 'ui.dart' show DesignThemeContext, DesignTypographyStyles;

/// A block heading: the role word, then what qualifies it.
///
/// Rendered by [BlockHeading], which sets the qualifiers a weight lighter
/// after a gap instead of joining everything with a dot — the role reads as
/// the label and the rest as a note beside it.
@immutable
class BlockHeadingParts {
  const BlockHeadingParts({required this.role, this.details = const []});

  /// 原文 / 译文 — leads and never moves.
  final String role;

  /// Language, service, status — each its own run.
  final List<String> details;
}

/// The heading over the source: 原文, followed by the detected language when
/// the capsule is on 自动检测 and something has been typed. A source the user
/// chose is already in the capsule and is not repeated.
BlockHeadingParts sourceHeading(
  String? detected, {
  bool detectedAutomatically = true,
}) {
  return BlockHeadingParts(
    role: t.workbench.translation.source,
    details: [
      if (detectedAutomatically && detected != null && detected.isNotEmpty)
        detected,
    ],
  );
}

/// The heading over a translation block: 译文 简体中文, 译文, 译文 简体中文 Claude.
///
/// The role word leads and never moves. The language follows only when
/// 自动匹配 picked it — then the heading is the one place the resolved target
/// is printed, and its presence itself says "the app chose this, glance at
/// it". A target chosen in the capsule is already on screen and is not
/// repeated. 首选 is never spelled out: it only means anything while the
/// compare list is open, where the other services are named anyway. The
/// service trails as a qualifier, and [serviceName] is expected to be null
/// for the default service — the one you would have got anyway. A failed
/// query keeps the plain heading; the block's body already says the
/// translation did not arrive, and a status on the label would say it twice.
BlockHeadingParts translationHeading({
  required String target,
  String? serviceName,
  bool matched = true,
  String? status,
}) {
  return BlockHeadingParts(
    role: t.workbench.translation.target,
    details: [
      if (matched && target.isNotEmpty) target,
      if (serviceName != null && serviceName.isNotEmpty) serviceName,
      if (status != null && status.isNotEmpty) status,
    ],
  );
}

/// The heading over a source or translation block. No punctuation between the
/// parts: the role keeps the label weight and the details follow in a lighter
/// one, so 原文 English reads as a label with a note beside it rather than a
/// list of equals. The colour comes from the [Label] around it.
class BlockHeading extends StatelessWidget {
  const BlockHeading(this.parts, {super.key});

  BlockHeading.of({
    super.key,
    required String role,
    List<String> details = const [],
  }) : parts = BlockHeadingParts(role: role, details: details);

  final BlockHeadingParts parts;

  /// `gap-[7px]` in the deck.
  static const double _kGap = 7;

  /// `opacity-75` on the qualifiers — the same ink, stepped back, so the
  /// role stays the thing you read first.
  static const double _kDetailOpacity = 0.75;

  @override
  Widget build(BuildContext context) {
    final inherited = DefaultTextStyle.of(context).style;
    final color = inherited.color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(child: Text(parts.role, overflow: TextOverflow.ellipsis)),
        for (final detail in parts.details) ...[
          const SizedBox(width: _kGap),
          Flexible(
            child: Text(
              detail,
              overflow: TextOverflow.ellipsis,
              style: context.tokens.typography.labelStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    color: color?.withValues(
                      alpha: (color.a) * _kDetailOpacity,
                    ),
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
