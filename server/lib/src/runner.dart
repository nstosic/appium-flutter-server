import 'dart:async';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/appium_test_bindings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:integration_test/integration_test.dart';

const MAX_TEST_DURATION_SECS = 24 * 60 * 60;

void initializeTest({Widget? app, Function? callback}) async {
  IntegrationTestWidgetsFlutterBinding binding =
      AppiumTestWidgetsFlutterBinding.ensureInitialized();
  if (app == null && callback == null) {
    throw Exception("App and callback cannot be null");
  }

  testWidgets('appium flutter server', (tester) async {
    /* Initialize network tools */
    // final appDocDirectory = await getApplicationDocumentsDirectory();
    // await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
    if (callback != null) {
      await callback(tester);
    } else {
      await tester.pumpWidget(app!);
    }
    FlutterDriver.instance.initialize(tester: tester, binding: binding);
    //await tester.pumpWidget(app);
    // await tester.tap(find.text("Form widgets"));
    // await tester.pumpAndSettle();
    // await tester.tap(find.byKey(Key("brushed_check_box")));
    // await tester.pumpAndSettle();
    FlutterServer.instance.startServer(port: 8888);

    // To block the test from ending
    await Completer<void>().future;
  }, timeout: const Timeout(Duration(seconds: MAX_TEST_DURATION_SECS)));
}
