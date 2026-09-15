import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/l10n.dart';
import '../state/fit_state.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';

class MDGymApp extends StatelessWidget {
  const MDGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fit,
      builder: (context, _) => MaterialApp(
        title: 'MDGym',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: fit.themeMode,
        locale: fit.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => _PhoneFrame(child: child),
        home: const AppShell(),
      ),
    );
  }
}

/// The screens are laid out for a phone. On the web the window is usually much
/// wider than that, which stretches the body map until the buttons below it sit
/// off-screen. Pin the app to a phone-width column and let the theme colour
/// fill whatever is left over.
class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget? child;

  static const _maxWidth = 460.0;

  @override
  Widget build(BuildContext context) {
    final content = child ?? const SizedBox.shrink();
    if (!kIsWeb) return content;

    final media = MediaQuery.of(context);
    if (media.size.width <= _maxWidth) return content;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: _maxWidth,
            // Screens read the width off MediaQuery, so it has to agree with
            // the box we just put them in.
            child: MediaQuery(
              data: media.copyWith(
                size: Size(_maxWidth, media.size.height),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
