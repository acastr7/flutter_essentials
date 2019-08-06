import 'package:flutter/services.dart';
import 'package:flutter_essentials/app_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_essentials/flutter_essentials.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_essentials');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('buildString', () async {
    expect(await AppInfo.buildString, '42');
  });
}
