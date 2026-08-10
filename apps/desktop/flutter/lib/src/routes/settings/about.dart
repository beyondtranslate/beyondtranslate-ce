import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../utils/env.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        PreferenceRow,
        PreferenceSection,
        Pressable;

/// 关于 — the one settings page you read rather than change, which is why it
/// sits in its own run of the rail. Three blocks: what this build is, whether
/// a newer one exists, and where to go for everything else.
///
/// Mirrors the React `AboutPage` in `screens/main/settings-view.tsx` and the
/// macOS `AboutView.swift`.
class AboutSettingsPage extends StatefulWidget {
  const AboutSettingsPage({super.key});

  @override
  State<AboutSettingsPage> createState() => _AboutSettingsPageState();
}

enum _UpdateState { latest, checking }

class _AboutSettingsPageState extends State<AboutSettingsPage> {
  _UpdateState _state = _UpdateState.latest;
  bool _copied = false;

  /// `settings.version` is a literal `v{} (Build {})` — slang leaves it alone
  /// because `{}` is not its placeholder syntax — so the two slots are filled
  /// here, in order.
  String get _versionLabel {
    final parts = t.settings.version.split('{}');
    if (parts.length < 3) {
      return 'v${Env.instance.appVersion} (Build ${Env.instance.appBuildNumber})';
    }
    return parts[0] +
        Env.instance.appVersion +
        parts[1] +
        Env.instance.appBuildNumber.toString() +
        parts[2];
  }

  Future<void> _copyVersion() async {
    await Clipboard.setData(ClipboardData(text: _versionLabel));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  Future<void> _checkForUpdates() async {
    setState(() => _state = _UpdateState.checking);
    // The updater lives in the runtime; until the Flutter shell is wired to
    // it this settles back to "up to date" the way the deck's story does.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _state = _UpdateState.latest);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final about = t.settings.about;
    final checking = _state == _UpdateState.checking;

    return SettingsPage(
      children: [
        // The identity block carries no heading: it is the page announcing
        // itself, and a label over a centred banner would name what the type
        // already says.
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Beyond Translate',
                style: tokens.typography.displayStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.fg,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _versionLabel,
                style: tokens.typography.monoStyle(
                  fontSize: 11,
                  height: 1,
                  color: colors.fgSubtle,
                ),
              ),
              const SizedBox(height: 8),
              Button(
                variant: ButtonVariant.quiet,
                onPressed: _copyVersion,
                child: Text(
                  _copied
                      ? t.common.ui.feedback.copied
                      : about.copy_version_info,
                ),
              ),
            ],
          ),
        ),
        const SettingsSectionDivider(),
        PreferenceSection(
          label: Text(about.title),
          children: [
            // The row is named for the thing, the button for the act —
            // repeating 检查更新 on both sides would read as a label and its
            // echo.
            PreferenceRow(
              title: Text(t.workbench.check_updates),
              subtitle: Text(
                checking ? t.workbench.version_checking : about.up_to_date,
              ),
              trailing: [
                Button(
                  variant: ButtonVariant.secondary,
                  enabled: !checking,
                  onPressed: _checkForUpdates,
                  child: Text(
                    checking ? t.workbench.version_checking : about.check_again,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SettingsSectionDivider(),
        PreferenceSection(
          label: Text(about.links),
          children: [
            _ExternalRow(
              title: about.open_changelog,
              url: '${Env.instance.webUrl}/changelog',
            ),
            _ExternalRow(title: about.website, url: Env.instance.webUrl),
            _ExternalRow(
              title: about.github,
              url: 'https://github.com/beyondtranslate/beyondtranslate',
            ),
            _ExternalRow(
              title: about.report_issue,
              url: 'https://github.com/beyondtranslate/beyondtranslate/issues',
            ),
            _ExternalRow(
              title: about.license,
              url: '${Env.instance.webUrl}/license',
            ),
          ],
        ),
      ],
    );
  }
}

/// A row that leaves the app — the glyph is the whole affordance.
class _ExternalRow extends StatelessWidget {
  const _ExternalRow({required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Pressable(
      onPressed: () => openExternalUrl(url),
      semanticsLabel: title,
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 28),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: tokens.typography.sansStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: state.hovered ? colors.accentText : colors.fg,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Icon(FluentIcons.open_20_regular, size: 13, color: colors.fgFaint),
          ],
        ),
      ),
    );
  }
}

/// Hands a URL to the platform's own opener.
Future<void> openExternalUrl(String url) async {
  if (Platform.isMacOS) {
    await Process.start('open', [url]);
  } else if (Platform.isWindows) {
    await Process.start('rundll32', ['url.dll,FileProtocolHandler', url]);
  } else {
    await Process.start('xdg-open', [url]);
  }
}
