// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:chord_fracture/src/config/validation_constants.dart';

class Tunings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(
        min: 1,
        max: ValidationConstants.maxTuningLength,
      )(); // チューニング名
  TextColumn get strings =>
      text().withLength(
        min: 1,
        max: ValidationConstants.maxTuningLength,
      )(); // 例: "C,G,D,G,C,D
  TextColumn get memo =>
      text().nullable().withLength(max: ValidationConstants.maxTuningLength)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
