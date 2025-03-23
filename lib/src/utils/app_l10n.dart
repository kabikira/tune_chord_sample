import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppL10n {
  static L10n of(BuildContext context) {
    return L10n.of(context);
  }

  static const localizationsDelegates = L10n.localizationsDelegates;
  static const supportedLocales = L10n.supportedLocales;
}
