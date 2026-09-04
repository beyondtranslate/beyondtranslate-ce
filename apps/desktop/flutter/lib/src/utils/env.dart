import 'package:nativeapi/nativeapi.dart';

void initEnv() {
  const appInfo = AppInfo.instance;

  final buildNumber = int.tryParse(appInfo.getBuildNumber() ?? '');
  if (buildNumber != null) {
    Env.instance.appBuildNumber = buildNumber;
  }

  final version = appInfo.getVersion();
  if (version != null && version.isNotEmpty) {
    Env.instance.appVersion = version;
  }
}

class Env {
  Env._();

  /// The shared instance of [Env].
  static final Env instance = Env._();

  String webUrl = 'https://beyondtranslate.com';

  int appBuildNumber = 0;
  String appVersion = '0.0.0';
}
