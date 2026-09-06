import 'dart:io';

import 'package:flutter/material.dart' hide Switch, TextField;

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' as runtime_service;
import '../../services/runtime.dart' show AdvancedSettingsPatch;
import '../../services/settings_store.dart';
import '../../theme/product_tokens.dart' show ProductTypography;
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        PreferenceRow,
        PreferenceSection,
        Switch,
        TextField,
        ThemeDataBuildContextProps;

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
        PreferenceSection(label: t.settings.advanced.api_server, children: [
          // The state of the thing is the row's second line, not the
          // section's footnote — the deck reads 运行于 … under the name it
          // belongs to.
          PreferenceRow(
              title: t.settings.advanced.api_server,
              // The kit's row prints its second line itself, so the address is
              // the row's own action rather than a link buried in the copy.
              subtitle: advanced.apiServerEnabled
                  ? apiInfo == null
                      ? t.settings.advanced.disabled
                      : t.settings.advanced.running_at
                          .replaceAll('{url}', address)
                  : t.settings.advanced.api_server_description,
              onPressed: advanced.apiServerEnabled && apiInfo != null
                  ? () => _openUrl(address)
                  : null,
              trailing: Switch(
                  value: advanced.apiServerEnabled,
                  onChanged: (value) {
                    settingsStore.updateAdvanced(
                      AdvancedSettingsPatch(apiServerEnabled: value),
                    );
                  })),
          if (advanced.apiServerEnabled)
            PreferenceRow(
                title: t.settings.advanced.port,
                trailing: SizedBox(
                  width: 96,
                  child: TextField(
                      style: context.vars.monoStyle(),
                      controller: _portController,
                      placeholder: '0',
                      onSubmitted: _updatePort),
                )),
        ]),
      ],
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
