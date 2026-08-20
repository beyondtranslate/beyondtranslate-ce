import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../services/app_windows.dart' show showSettingsWindow;
import '../../utils/platform_util.dart';
import '../../utils/utils.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles;

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

    return Callout(
      tone: CalloutTone.warn,
      icon: Icon(
        FluentIcons.warning_20_regular,
        color: colors.warnStrong,
        size: 16,
      ),
      action: Tooltip(
        message: limitedBanner.tooltip.help,
        child: Button(
          variant: ButtonVariant.warning,
          size: ButtonSize.xs,
          onPressed: () async {
            final url = '${sharedEnv.webUrl}/docs';
            final result = nativeapi.UrlOpener.instance.open(url);
            if (!result.success) {
              throw 'Could not launch $url: ${result.errorMessage}';
            }
          },
          child: Text(limitedBanner.tooltip.help),
        ),
      ),
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
                recognizer: TapGestureRecognizer()..onTap = showSettingsWindow,
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
    );
  }
}
