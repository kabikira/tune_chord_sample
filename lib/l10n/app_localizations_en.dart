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
  String get generalError => 'An error occurred. Please try again later.';

  @override
  String get errorMessage => 'An error occurred';

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
  String deleteConfirmationMessage(String tuning) {
    return 'Are you sure you want to delete \"$tuning\"?';
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
  String get tuningNameExample => 'e.g., Open C';

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
  String get chordFormRegistration => 'Chord Form Registration';

  @override
  String get chordFormEdit => 'Edit Chord Form';

  @override
  String get chordFormDetail => 'Chord Form Details';

  @override
  String get chordFormList => 'Chord Form List';

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
  String get chordFormNotFound => 'Chord form not found';

  @override
  String get muteStringLongPress => 'Mute string (long press)';

  @override
  String get currentComposition => 'Current composition:';

  @override
  String get help => 'Help';

  @override
  String get deleteChordForm => 'Delete Chord Form';

  @override
  String get deleteChordFormConfirmation => 'Are you sure you want to delete this chord form?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get confirm => 'Confirm';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get tuningNotFound => 'Tuning not found';

  @override
  String get displayMode => 'Display Mode';

  @override
  String get cardMode => 'Card';

  @override
  String get listMode => 'List';

  @override
  String get toggleFavorite => 'Toggle Favorite';

  @override
  String get noChordFormsFound => 'No chord forms found';

  @override
  String get registerFirst => 'Register first';

  @override
  String get registerChordForm => 'Register Chord Form';

  @override
  String get openString => 'Open';

  @override
  String get muteString => 'Mute';

  @override
  String chordFretPosition(String position) {
    return 'Fret Position: $position';
  }

  @override
  String chordMemo(String memo) {
    return 'Memo: $memo';
  }

  @override
  String get search => 'Search';

  @override
  String get searchKeywordPlaceholder => 'Enter search keyword';

  @override
  String get searchOptions => 'Search Options';

  @override
  String get searchTarget => 'Search Target';

  @override
  String get sortOrder => 'Sort Order';

  @override
  String get searchTargetAll => 'All';

  @override
  String get searchTargetTuning => 'Tuning Only';

  @override
  String get searchTargetChordForm => 'Chord Form Only';

  @override
  String get searchTargetTag => 'Tag Only';

  @override
  String get sortOrderNewest => 'Newest First';

  @override
  String get sortOrderOldest => 'Oldest First';

  @override
  String get sortOrderIdAsc => 'ID Ascending';

  @override
  String get sortOrderIdDesc => 'ID Descending';

  @override
  String get searchEnterKeyword => 'Please enter a search keyword';

  @override
  String get searchNoResults => 'No search results found';

  @override
  String tuningLabel(String tuning) {
    return 'Tuning: $tuning';
  }

  @override
  String fretPositionLabel(String position) {
    return 'Fret Position: $position';
  }

  @override
  String get noName => 'No Name';

  @override
  String get searchError => 'An error occurred during search';

  @override
  String get settings => 'Settings';

  @override
  String get appInfo => 'App Information';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get appearanceSettings => 'Appearance Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get developerOptions => 'Developer Options';

  @override
  String get widgetGallery => 'Widget Gallery';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get backupData => 'Backup Data';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get aboutAppTitle => 'About App';

  @override
  String get appName => 'ChordFracture';

  @override
  String get appDescription => 'A guitar chord form management app for alternate tunings. Record and manage chord forms across various tunings.';

  @override
  String versionLabel(String version) {
    return 'Version: $version';
  }

  @override
  String get deleteData => 'Delete Data';

  @override
  String get deleteDataWarning => 'All tuning and chord form data will be deleted';

  @override
  String get deleteDataDescription => 'This action cannot be undone. All data will be permanently deleted.';

  @override
  String get tuningStringRequired => 'Please enter the string tuning';

  @override
  String tuningStringTooLong(int maxLength) {
    return 'String tuning is too long (maximum $maxLength characters excluding #)';
  }

  @override
  String tuningNameTooLong(int maxLength) {
    return 'Tuning name is too long (maximum $maxLength characters)';
  }

  @override
  String get tuningStringInvalidSharp => 'Invalid sharp (#) pattern detected';

  @override
  String get tuningStringInvalidNote => 'Invalid note pattern detected';

  @override
  String get crashlyticsTest => 'Crashlytics Test';

  @override
  String get crashlyticsTestDescription => 'Generate a test crash to verify Firebase Crashlytics is working properly.';

  @override
  String get testCrash => 'Execute Test Crash';

  @override
  String get crashlyticsTestTitle => 'Crashlytics Test';

  @override
  String get crashlyticsTestWarning => 'This action will crash the app. You can verify it in Firebase Console.';

  @override
  String get proceedWithCrash => 'Execute Crash';

  @override
  String get tuningLimitReachedTitle => 'Tuning limit reached';

  @override
  String get tuningLimitReachedShort => 'On the free plan, you can register up to 10 tunings. Please delete unnecessary items or wait for a future update.';

  @override
  String get tuningLimitReachedPolite => 'You have reached the free plan limit (10). You can organize to free up space; we plan to offer limit expansion in a future update.';

  @override
  String get chordFormLimitReachedTitle => 'Chord form limit reached';

  @override
  String get chordFormLimitReachedShort => 'On the free plan, you can register up to 10 chord forms. Please delete unnecessary items or wait for a future update.';

  @override
  String get chordFormLimitReachedPolite => 'You have reached the free plan limit (10). You can organize to free up space; we plan to offer limit expansion in a future update.';

  @override
  String get ok => 'OK';
}
