// ignore_for_file: depend_on_referenced_packages

import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box {}

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return 'your path';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return 'your path';
  }
}
