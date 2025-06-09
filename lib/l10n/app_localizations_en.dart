// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get tuningManagement => 'Tuning Management';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get noTuningsRegistered => 'No tunings registered';

  @override
  String get registrationDate => 'Created';

  @override
  String get updateDate => 'Updated';

  @override
  String get registerTuning => 'Register Tuning';

  @override
  String get stringTuning => 'String Tuning';

  @override
  String get tuningExample => 'Example: CGDGCD';

  @override
  String get tuningInputDescription => 'Please input from low to high pitch';

  @override
  String get cancel => 'Cancel';

  @override
  String get complete => 'Complete';

  @override
  String get deleteConfirmation => 'Delete Confirmation';

  @override
  String deleteConfirmationMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get deleteWarningMessage => 'This action cannot be undone. All chord forms associated with this tuning will also be deleted.';

  @override
  String get delete => 'Delete';

  @override
  String get editTuning => 'Edit Tuning';

  @override
  String get tuningName => 'Tuning Name';

  @override
  String get update => 'Update';

  @override
  String get tags => 'Tags';

  @override
  String get newTag => 'New Tag';

  @override
  String get deleteTag => 'Delete Tag';

  @override
  String deleteTagConfirmation(String tagName) {
    return 'Are you sure you want to delete $tagName?';
  }
}
