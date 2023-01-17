import 'package:isar/isar.dart';

part 'isar_test.dto.g.dart';

@collection
class IsarTestDto {
  Id id = Isar.autoIncrement;
  String? name;
}
