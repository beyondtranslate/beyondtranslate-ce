import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/app_windows.dart' show showSettingsWindow;
import '../../utils/platform_util.dart';
import '../../widgets/ui.dart'
    show Callout, CalloutTone, DesignThemeContext, DesignTypographyStyles;

class LimitedFunctionalityBanner extends StatelessWidget {
  const LimitedFunctionalityBanner({
    Key? key,
    required this.isAllowedScreenCaptureAccess,
    required this.isAllowedScreenSelectionAccess,
    required this.onTappedRecheckIsAllowedAllAccess,
  }) : super(key: key);
  final bool isAllowedScreenCaptureAccess;
  final bool isAllowedScreenSelectionAccess;
  final VoidCallback onTappedRecheckIsAllowedAllAccess;

  bool get _isAllowedAllAccess =>
      isAllowedScreenCaptureAccess && isAllowedScreenSelectionAccess;

  String _titleText() {
    final permission = t.mini_translator.limited_banner.permission;
    if (!isAllowedScreenCaptureAccess && !isAllowedScreenSelectionAccess) {
      return permission.missing_both;
    }
    if (!isAllowedScreenCaptureAccess) {
      return permission.missing_screen_capture;
    }
    return permission.missing_accessibility;
  }

  @override
  Widget build(BuildContext context) {
    if (_isAllowedAllAccess) return const SizedBox.shrink();

    final tokens = context.tokens;
    final colors = tokens.colors;
    final limitedBanner = t.mini_translator.limited_banner;
    final instruction = limitedBanner.instruction;

    final linkStyle = tokens.typography.sansStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: colors.accentText,
    );

    // The gap to the panel below belongs to the banner — React carries it as
    // `mb-2` on the Callout itself, so the strip brings its own breathing room
    // wherever it is hung.
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Callout(
        tone: CalloutTone.warn,
        // Tighter than the default 14/12: the mini window is 396px wide and this
        // notice runs to three lines, where the default inset is a lot of air
        // around the copy.
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // The copy wraps, so the icon sits on the first line rather than
        // drifting to the middle of the paragraph. The 1px nudge is React's
        // `mt-px`: it puts the glyph on the line's optical centre.
        crossAxisAlignment: CrossAxisAlignment.start,
        icon: Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            FluentIcons.warning_20_regular,
            color: colors.warnStrong,
            size: 16,
          ),
        ),
        // No action: both exits stay in the text flow. At 396px a button on the
        // right squeezes this paragraph into a narrow column.
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: _titleText()),
              if (kIsMacOS) ...[
                const TextSpan(text: ' '),
                TextSpan(text: instruction.app_settings_prefix),
                TextSpan(
                  text: limitedBanner.action.app_settings,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = showSettingsWindow,
                ),
                TextSpan(text: instruction.follow_guide_prefix),
                TextSpan(
                  text: limitedBanner.action.recheck,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = onTappedRecheckIsAllowedAllAccess,
                ),
                TextSpan(text: instruction.suffix),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
