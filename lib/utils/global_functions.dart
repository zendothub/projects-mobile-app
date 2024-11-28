import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zen_mobile/config/config_variables.dart';
import 'package:zen_mobile/main.dart';
import 'package:zen_mobile/provider/provider_list.dart';

void sentryService() {
  String baseApiUrl = dotenv.env['BASE_API'] ?? 'https://defaultapi.com/'; 
  if (Config.sentryDsn != '' && Config.sentryDsn != null) {
    SentryFlutter.init(
      (options) {
        options.dsn = Config.sentryDsn;
      },
      appRunner: () => runApp(ProviderScope(child: MyApp(baseApiUrl))),
    );
  } else {
    runApp(ProviderScope(child: MyApp(baseApiUrl)));
  }
}

void postHogService(
    {required String eventName,
    required Map<String, dynamic> properties,
    required WidgetRef ref}) {
  if (Config.posthogApiKey != null && Config.posthogApiKey != '') {
    final profileProvider = ref.watch(ProviderList.profileProvider);
    properties.addAll(
      {
        'USER_ID': profileProvider.userProfile.id,
        'USER_EMAIL': profileProvider.userProfile.email,
      },
    );
    try {
      Posthog().capture(
        eventName: eventName,
        properties: properties.cast<String, Object>(),
      );
    } catch (e) {
      sentryService();
    }
  } else {
    return;
  }
}
