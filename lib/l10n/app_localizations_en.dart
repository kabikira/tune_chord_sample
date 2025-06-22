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

  @override
  String get navTuning => 'Tuning';

  @override
  String get navSearch => 'Search';

  @override
  String get navSettings => 'Settings';

  @override
  String get codeFormRegistration => 'Code Form Registration';

  @override
  String get codeFormEdit => 'Edit Code Form';

  @override
  String get codeFormDetail => 'Code Form Details';

  @override
  String get codeFormList => 'Code Form List';

  @override
  String get register => 'Register';

  @override
  String get edit => 'Edit';

  @override
  String get memo => 'Memo';

  @override
  String get memoOptional => 'Memo (Optional)';

  @override
  String get memoPlaceholder => 'Enter notes about this chord...';

  @override
  String get chordName => 'Chord Name';

  @override
  String get chordNameExample => 'e.g., Em, C, G7';

  @override
  String get fretPosition => 'Fret Position';

  @override
  String fretNumber(int number) {
    return 'Fret $number';
  }

  @override
  String get previousFret => 'Previous Fret';

  @override
  String get nextFret => 'Next Fret';

  @override
  String get reset => 'Reset';

  @override
  String get tuningInfo => 'Tuning Information';

  @override
  String get chordInfo => 'Chord Information';

  @override
  String get fretboardHelp => 'How to Use Fretboard';

  @override
  String get fretboardHelpTapString => 'Tap strings to specify fret positions';

  @override
  String get fretboardHelpOpenString => 'Fret 0 represents open strings';

  @override
  String get fretboardHelpMuteString => 'Long press at fret 0 to mute string (X)';

  @override
  String get fretboardHelpTapAgain => 'Tap the same position again to clear';

  @override
  String get fretboardHelpArrowKeys => 'Use left/right arrows to move fret positions';

  @override
  String get close => 'Close';

  @override
  String get codeFormNotFound => 'Code form not found';
}
