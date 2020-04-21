import 'dart:async';

import 'package:sentry/sentry.dart';

final _client = new SentryClient(
  dsn: 'https://2c5f53bfc46041b3a7fee3e243252f8c@o380984.ingest.sentry.io/5207629',
  environmentAttributes: Event(
    release: '1.0.0',
  ),
);

bool get isInDebugMode {
  bool inDebugMode = true;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> reportSentry(dynamic error, dynamic stackTrace) async {
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _client.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Sentry OK: Event ID: ${response.eventId}');
  } else {
    print('Sentry FAIL: ${response.error}');
  }
}
