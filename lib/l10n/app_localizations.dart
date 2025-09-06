import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// Classic greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @tuningManagement.
  ///
  /// In en, this message translates to:
  /// **'Tuning Management'**
  String get tuningManagement;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again later.'**
  String get generalError;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorMessage;

  /// No description provided for @noTuningsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No tunings registered'**
  String get noTuningsRegistered;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get registrationDate;

  /// No description provided for @updateDate.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updateDate;

  /// No description provided for @registerTuning.
  ///
  /// In en, this message translates to:
  /// **'Register Tuning'**
  String get registerTuning;

  /// No description provided for @stringTuning.
  ///
  /// In en, this message translates to:
  /// **'String Tuning'**
  String get stringTuning;

  /// No description provided for @tuningExample.
  ///
  /// In en, this message translates to:
  /// **'Example: CGDGCD'**
  String get tuningExample;

  /// No description provided for @tuningInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Please input from low to high pitch'**
  String get tuningInputDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{tuning}\"?'**
  String deleteConfirmationMessage(String tuning);

  /// No description provided for @deleteWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All chord forms associated with this tuning will also be deleted.'**
  String get deleteWarningMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editTuning.
  ///
  /// In en, this message translates to:
  /// **'Edit Tuning'**
  String get editTuning;

  /// No description provided for @tuningName.
  ///
  /// In en, this message translates to:
  /// **'Tuning Name'**
  String get tuningName;

  /// No description provided for @tuningNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., Open C'**
  String get tuningNameExample;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get newTag;

  /// Title for tag deletion dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get deleteTag;

  /// Confirmation message for tag deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {tagName}?'**
  String deleteTagConfirmation(String tagName);

  /// Label for tuning tab in navigation bar
  ///
  /// In en, this message translates to:
  /// **'Tuning'**
  String get navTuning;

  /// Label for search tab in navigation bar
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// Label for settings tab in navigation bar
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Title for chord form registration screen
  ///
  /// In en, this message translates to:
  /// **'Chord Form Registration'**
  String get chordFormRegistration;

  /// Title for chord form edit screen
  ///
  /// In en, this message translates to:
  /// **'Edit Chord Form'**
  String get chordFormEdit;

  /// Title for chord form detail screen
  ///
  /// In en, this message translates to:
  /// **'Chord Form Details'**
  String get chordFormDetail;

  /// Title for chord form list screen
  ///
  /// In en, this message translates to:
  /// **'Chord Form List'**
  String get chordFormList;

  /// Text for register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Text for edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Label for memo field
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// Label for optional memo field
  ///
  /// In en, this message translates to:
  /// **'Memo (Optional)'**
  String get memoOptional;

  /// Placeholder text for memo field
  ///
  /// In en, this message translates to:
  /// **'Enter notes about this chord...'**
  String get memoPlaceholder;

  /// Label for chord name field
  ///
  /// In en, this message translates to:
  /// **'Chord Name'**
  String get chordName;

  /// Hint text for chord name field
  ///
  /// In en, this message translates to:
  /// **'e.g., Em, C, G7'**
  String get chordNameExample;

  /// Title for fret position section
  ///
  /// In en, this message translates to:
  /// **'Fret Position'**
  String get fretPosition;

  /// Display text for fret number
  ///
  /// In en, this message translates to:
  /// **'Fret {number}'**
  String fretNumber(int number);

  /// Tooltip for previous fret button
  ///
  /// In en, this message translates to:
  /// **'Previous Fret'**
  String get previousFret;

  /// Tooltip for next fret button
  ///
  /// In en, this message translates to:
  /// **'Next Fret'**
  String get nextFret;

  /// Text for reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Title for tuning info section
  ///
  /// In en, this message translates to:
  /// **'Tuning Information'**
  String get tuningInfo;

  /// Title for chord info section
  ///
  /// In en, this message translates to:
  /// **'Chord Information'**
  String get chordInfo;

  /// Title for fretboard help dialog
  ///
  /// In en, this message translates to:
  /// **'How to Use Fretboard'**
  String get fretboardHelp;

  /// Fretboard help instruction 1
  ///
  /// In en, this message translates to:
  /// **'Tap strings to specify fret positions'**
  String get fretboardHelpTapString;

  /// Fretboard help instruction 2
  ///
  /// In en, this message translates to:
  /// **'Fret 0 represents open strings'**
  String get fretboardHelpOpenString;

  /// Fretboard help instruction 3
  ///
  /// In en, this message translates to:
  /// **'Long press at fret 0 to mute string (X)'**
  String get fretboardHelpMuteString;

  /// Fretboard help instruction 4
  ///
  /// In en, this message translates to:
  /// **'Tap the same position again to clear'**
  String get fretboardHelpTapAgain;

  /// Fretboard help instruction 5
  ///
  /// In en, this message translates to:
  /// **'Use left/right arrows to move fret positions'**
  String get fretboardHelpArrowKeys;

  /// Text for close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Error message when chord form is not found
  ///
  /// In en, this message translates to:
  /// **'Chord form not found'**
  String get chordFormNotFound;

  /// Text for mute control widget
  ///
  /// In en, this message translates to:
  /// **'Mute string (long press)'**
  String get muteStringLongPress;

  /// Label for current chord composition display
  ///
  /// In en, this message translates to:
  /// **'Current composition:'**
  String get currentComposition;

  /// Text for help button
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Title for chord form deletion dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Chord Form'**
  String get deleteChordForm;

  /// Confirmation message for chord form deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chord form?'**
  String get deleteChordFormConfirmation;

  /// Warning message for irreversible actions
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotBeUndone;

  /// Text for confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// Error message when tuning is not found
  ///
  /// In en, this message translates to:
  /// **'Tuning not found'**
  String get tuningNotFound;

  /// Label for display mode selection
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get displayMode;

  /// Card display mode option
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get cardMode;

  /// List display mode option
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listMode;

  /// Tooltip for favorite toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Favorite'**
  String get toggleFavorite;

  /// Message when no chord forms are found
  ///
  /// In en, this message translates to:
  /// **'No chord forms found'**
  String get noChordFormsFound;

  /// Suggestion to register first when list is empty
  ///
  /// In en, this message translates to:
  /// **'Register first'**
  String get registerFirst;

  /// Title or button text for chord form registration
  ///
  /// In en, this message translates to:
  /// **'Register Chord Form'**
  String get registerChordForm;

  /// Label for open string in chord diagrams
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openString;

  /// Label for muted string in chord diagrams
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get muteString;

  /// Display text for chord fret position
  ///
  /// In en, this message translates to:
  /// **'Fret Position: {position}'**
  String chordFretPosition(String position);

  /// Display text for chord memo
  ///
  /// In en, this message translates to:
  /// **'Memo: {memo}'**
  String chordMemo(String memo);

  /// Title for search screen
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Placeholder text for search input field
  ///
  /// In en, this message translates to:
  /// **'Enter search keyword'**
  String get searchKeywordPlaceholder;

  /// Title for search options section
  ///
  /// In en, this message translates to:
  /// **'Search Options'**
  String get searchOptions;

  /// Label for search target selection
  ///
  /// In en, this message translates to:
  /// **'Search Target'**
  String get searchTarget;

  /// Label for sort order selection
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get sortOrder;

  /// Search target option for all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchTargetAll;

  /// Search target option for tuning only
  ///
  /// In en, this message translates to:
  /// **'Tuning Only'**
  String get searchTargetTuning;

  /// Search target option for chord form only
  ///
  /// In en, this message translates to:
  /// **'Chord Form Only'**
  String get searchTargetChordForm;

  /// Search target option for tag only
  ///
  /// In en, this message translates to:
  /// **'Tag Only'**
  String get searchTargetTag;

  /// Sort order option for newest first
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get sortOrderNewest;

  /// Sort order option for oldest first
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get sortOrderOldest;

  /// Sort order option for ID ascending
  ///
  /// In en, this message translates to:
  /// **'ID Ascending'**
  String get sortOrderIdAsc;

  /// Sort order option for ID descending
  ///
  /// In en, this message translates to:
  /// **'ID Descending'**
  String get sortOrderIdDesc;

  /// Empty state message when no search keyword is entered
  ///
  /// In en, this message translates to:
  /// **'Please enter a search keyword'**
  String get searchEnterKeyword;

  /// Empty state message when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No search results found'**
  String get searchNoResults;

  /// Label for tuning display in search results
  ///
  /// In en, this message translates to:
  /// **'Tuning: {tuning}'**
  String tuningLabel(String tuning);

  /// Label for fret position display in search results
  ///
  /// In en, this message translates to:
  /// **'Fret Position: {position}'**
  String fretPositionLabel(String position);

  /// Placeholder text when item has no name
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;

  /// Error message during search operation
  ///
  /// In en, this message translates to:
  /// **'An error occurred during search'**
  String get searchError;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// App information section title
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// About app item label
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Version item label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Appearance settings section title
  ///
  /// In en, this message translates to:
  /// **'Appearance Settings'**
  String get appearanceSettings;

  /// Dark mode setting label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Developer options section title
  ///
  /// In en, this message translates to:
  /// **'Developer Options'**
  String get developerOptions;

  /// Widget gallery item label
  ///
  /// In en, this message translates to:
  /// **'Widget Gallery'**
  String get widgetGallery;

  /// Data management section title
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// Data backup item label
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupData;

  /// Data restore item label
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get restoreData;

  /// Delete all data item label
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get deleteAllData;

  /// About app dialog title
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutAppTitle;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'ChordFracture'**
  String get appName;

  /// Application description
  ///
  /// In en, this message translates to:
  /// **'A guitar chord form management app for alternate tunings. Record and manage chord forms across various tunings.'**
  String get appDescription;

  /// Version display label
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String versionLabel(String version);

  /// Delete data dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Data'**
  String get deleteData;

  /// Data deletion warning message
  ///
  /// In en, this message translates to:
  /// **'All tuning and chord form data will be deleted'**
  String get deleteDataWarning;

  /// Data deletion detailed description
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All data will be permanently deleted.'**
  String get deleteDataDescription;

  /// Error message when tuning string is required
  ///
  /// In en, this message translates to:
  /// **'Please enter the string tuning'**
  String get tuningStringRequired;

  /// Error message when tuning string exceeds maximum length
  ///
  /// In en, this message translates to:
  /// **'String tuning is too long (maximum {maxLength} characters excluding #)'**
  String tuningStringTooLong(int maxLength);

  /// Error message when tuning name exceeds maximum length
  ///
  /// In en, this message translates to:
  /// **'Tuning name is too long (maximum {maxLength} characters)'**
  String tuningNameTooLong(int maxLength);

  /// Error message when invalid sharp pattern is detected
  ///
  /// In en, this message translates to:
  /// **'Invalid sharp (#) pattern detected'**
  String get tuningStringInvalidSharp;

  /// Error message when invalid note pattern is detected
  ///
  /// In en, this message translates to:
  /// **'Invalid note pattern detected'**
  String get tuningStringInvalidNote;

  /// Label for Crashlytics test feature
  ///
  /// In en, this message translates to:
  /// **'Crashlytics Test'**
  String get crashlyticsTest;

  /// Description of Crashlytics test feature
  ///
  /// In en, this message translates to:
  /// **'Generate a test crash to verify Firebase Crashlytics is working properly.'**
  String get crashlyticsTestDescription;

  /// Text for test crash button
  ///
  /// In en, this message translates to:
  /// **'Execute Test Crash'**
  String get testCrash;

  /// Title for Crashlytics test dialog
  ///
  /// In en, this message translates to:
  /// **'Crashlytics Test'**
  String get crashlyticsTestTitle;

  /// Warning message for Crashlytics test
  ///
  /// In en, this message translates to:
  /// **'This action will crash the app. You can verify it in Firebase Console.'**
  String get crashlyticsTestWarning;

  /// Text for proceed with crash button
  ///
  /// In en, this message translates to:
  /// **'Execute Crash'**
  String get proceedWithCrash;

  /// Dialog title when tuning registration limit is reached
  ///
  /// In en, this message translates to:
  /// **'Tuning limit reached'**
  String get tuningLimitReachedTitle;

  /// Short description when tuning limit is reached
  ///
  /// In en, this message translates to:
  /// **'On the free plan, you can register up to 10 tunings. Please delete unnecessary items or wait for a future update.'**
  String get tuningLimitReachedShort;

  /// Polite description when tuning limit is reached
  ///
  /// In en, this message translates to:
  /// **'You have reached the free plan limit (10). You can organize to free up space; we plan to offer limit expansion in a future update.'**
  String get tuningLimitReachedPolite;

  /// Dialog title when chord form registration limit is reached
  ///
  /// In en, this message translates to:
  /// **'Chord form limit reached'**
  String get chordFormLimitReachedTitle;

  /// Short description when chord form limit is reached
  ///
  /// In en, this message translates to:
  /// **'On the free plan, you can register up to 10 chord forms. Please delete unnecessary items or wait for a future update.'**
  String get chordFormLimitReachedShort;

  /// Polite description when chord form limit is reached
  ///
  /// In en, this message translates to:
  /// **'You have reached the free plan limit (10). You can organize to free up space; we plan to offer limit expansion in a future update.'**
  String get chordFormLimitReachedPolite;

  /// Text for OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
