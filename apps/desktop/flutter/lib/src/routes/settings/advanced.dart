import 'dart:io';

import 'package:flutter/material.dart' hide Switch;

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' as runtime_service;
import '../../services/runtime.dart' show AdvancedSettingsPatch;
import '../../services/settings_store.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show Input, PreferenceRow, PreferenceSection, Switch;

/// Mirrors macOS `AdvancedView.swift`.
class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});

  @override
  State<AdvancedSettingsPage> createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  late final TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    _portController = TextEditingController();
    settingsStore.addListener(_handleSettingsChanged);
    _syncControllers();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleSettingsChanged);
    _portController.dispose();
    super.dispose();
  }

  void _handleSettingsChanged() {
    _syncControllers();
    if (mounted) {
      setState(() {});
    }
  }

  void _syncControllers() {
    final advanced = settingsStore.advanced;
    _setControllerText(_portController, advanced.apiServerPort.toString());
  }

  void _setControllerText(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _updatePort(String value) async {
    final port = int.tryParse(value.trim()) ?? 0;
    await settingsStore.updateAdvanced(
      AdvancedSettingsPatch(apiServerPort: port.clamp(0, 65535)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final advanced = settingsStore.advanced;
    final apiInfo = runtime_service.apiServerInfo;
    final address = apiInfo?.baseUrl ?? t.settings.advanced.disabled;

    return SettingsPage(
      children: [
        PreferenceSection(
          label: Text(t.settings.advanced.api_server),
          children: [
            // The state of the thing is the row's second line, not the
            // section's footnote — the deck reads 运行于 … under the name it
            // belongs to.
            PreferenceRow(
              title: Text(t.settings.advanced.api_server),
              subtitle: advanced.apiServerEnabled
                  ? apiInfo == null
                        ? Text(t.settings.advanced.disabled)
                        : _ApiServerLinkText(baseUrl: address)
                  : Text(t.settings.advanced.api_server_description),
              trailing: [
                Switch(
                  checked: advanced.apiServerEnabled,
                  semanticsLabel: t.settings.advanced.api_server,
                  onChanged: (value) {
                    settingsStore.updateAdvanced(
                      AdvancedSettingsPatch(apiServerEnabled: value),
                    );
                  },
                ),
              ],
            ),
            if (advanced.apiServerEnabled)
              PreferenceRow(
                title: Text(t.settings.advanced.port),
                trailing: [
                  SizedBox(
                    width: 96,
                    child: Input(
                      mono: true,
                      controller: _portController,
                      placeholder: '0',
                      semanticsLabel: t.settings.advanced.port,
                      onSubmitted: _updatePort,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _ApiServerLinkText extends StatelessWidget {
  const _ApiServerLinkText({required this.baseUrl});

  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    final text = t.settings.advanced.running_at;
    final parts = text.split('{url}');
    final style = DefaultTextStyle.of(context).style;
    final linkStyle = style.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts.first),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap: () => _openUrl(baseUrl),
              child: Text(baseUrl, style: linkStyle),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts.last),
        ],
      ),
    );
  }
}

Future<void> _openUrl(String url) async {
  if (Platform.isMacOS) {
    await Process.start('open', [url]);
  } else if (Platform.isWindows) {
    await Process.start('rundll32', ['url.dll,FileProtocolHandler', url]);
  } else {
    await Process.start('xdg-open', [url]);
  }
}
