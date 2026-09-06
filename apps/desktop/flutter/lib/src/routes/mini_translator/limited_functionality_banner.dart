import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/app_windows.dart' show showSettingsWindow;
import '../../theme/product_tokens.dart'
    show ProductFonts, ProductPalette, ProductTypography;
import '../../utils/platform_util.dart';
import '../../widgets/ui.dart'
    show Callout, CalloutTint, ThemeDataBuildContextProps, WidgetSize;

class LimitedFunctionalityBanner extends StatelessWidget {
  const LimitedFunctionalityBanner({
    super.key,
    required this.isAllowedScreenCaptureAccess,
    required this.isAllowedScreenSelectionAccess,
    required this.onTappedRecheckIsAllowedAllAccess,
  });
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

    final vars = context.vars;
    final limitedBanner = t.mini_translator.limited_banner;
    final instruction = limitedBanner.instruction;

    final linkStyle = vars.sansStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: vars.accentText,
    );

    // The gap to the panel below belongs to the banner — React carries it as
    // `mb-2` on the Callout itself, so the strip brings its own breathing room
    // wherever it is hung.
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      // The kit's callout fills whatever height it is handed — its text column
      // is `MainAxisSize.max` — and the mini window hands it the whole pane.
      // Releasing the vertical constraint puts it back on its own copy.
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: Callout(
          // The small density: the mini window is 396px wide and this notice
          // runs to three lines, where the medium inset is a lot of air around
          // the copy. The kit already starts the icon on the first line once a
          // message wraps.
          size: WidgetSize.small,
          // No action: both exits stay in the text flow. At 396px a button on
          // the right squeezes this paragraph into a narrow column.
          message: Text.rich(
            TextSpan(
              // The kit hands its message a `DefaultTextStyle`, which replaces
              // the ambient one rather than merging with it, so the copy names
              // the app's face itself. Size and colour stay the kit's.
              style: TextStyle(
                fontFamily: ProductFonts.sansFamily,
                fontFamilyFallback: ProductFonts.sansFallback,
              ),
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
          tint: CalloutTint.warning,
          icon: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              FluentIcons.warning_20_regular,
              color: vars.warnStrong,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
