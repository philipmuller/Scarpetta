import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class MainTheme extends ThemeExtension<MainTheme> {
  final Color primaryColor;
  final Color tertiaryColor;
  final Color neutralColor;

  const MainTheme({
    this.primaryColor = const Color(0xFF356859), 
    this.tertiaryColor = const Color(0xFFFF5722), 
    this.neutralColor = const Color(0xFFFFFBE6)
  });

  TextTheme _baseText() {
    final headingTextTheme = GoogleFonts.ebGaramondTextTheme();
    final bodyTextTheme = GoogleFonts.interTextTheme();

    return bodyTextTheme.copyWith(
      displayLarge: headingTextTheme.displayLarge,
      displayMedium: headingTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
      displaySmall: headingTextTheme.displaySmall,
    );
  }

  ColorScheme _colorScheme() {
    final base = CorePalette.of(primaryColor.value);
    final primary = base.primary;
    final tertiary = CorePalette.of(tertiaryColor.value).primary;
    final neutral = CorePalette.of(neutralColor.value).neutral;

    final scheme = Scheme(
      primary: primary.get(40),
      onPrimary: primary.get(100),
      primaryContainer: primary.get(90),
      onPrimaryContainer: primary.get(10),
      secondary: base.secondary.get(40),
      onSecondary: base.secondary.get(100),
      secondaryContainer: base.secondary.get(90),
      onSecondaryContainer: base.secondary.get(10),
      tertiary: tertiary.get(40),
      onTertiary: tertiary.get(100),
      tertiaryContainer: tertiary.get(90),
      onTertiaryContainer: tertiary.get(10),
      error: base.error.get(40),
      onError: base.error.get(100),
      errorContainer: base.error.get(90),
      onErrorContainer: base.error.get(10),
      background: neutral.get(99),
      onBackground: neutral.get(10),
      surface: neutral.get(99),
      onSurface: neutral.get(10),
      surfaceVariant: base.neutralVariant.get(90),
      onSurfaceVariant: base.neutralVariant.get(30),
      outline: base.neutralVariant.get(50),
      outlineVariant: base.neutralVariant.get(80),
      shadow: neutral.get(0),
      scrim: neutral.get(30),
      inverseSurface: neutral.get(20),
      inverseOnSurface: neutral.get(95),
      inversePrimary: primary.get(80),
    );

    return scheme.toColorScheme(Brightness.light);
  }

  ThemeData _base() {
    final textTheme = _baseText();
    final colorScheme = _colorScheme();

    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme.apply(
        displayColor: colorScheme.onSurface,
        bodyColor: colorScheme.onSurface
      ),
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurface,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.primary,
              width: 2
            )
          )
        )
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface
        ),
        indicatorColor: colorScheme.secondaryContainer
      ),
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
      )
    );
  }

  ThemeData toThemeData() {
    return _base();
  }

  @override
  MainTheme copyWith({Color? primaryColor, Color? tertiaryColor, Color? neutralColor}) {
    return MainTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      neutralColor: neutralColor ?? this.neutralColor,
    );
  }

  @override
  MainTheme lerp(covariant ThemeExtension<MainTheme>? other, double t) {
    if (other is! MainTheme) return this;

    return MainTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!
    );
  }
}

extension on Scheme {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      primary: Color(primary),
      onPrimary: Color(onPrimary),
      primaryContainer: Color(primaryContainer),
      onPrimaryContainer: Color(onPrimaryContainer),
      secondary: Color(secondary),
      onSecondary: Color(onSecondary),
      secondaryContainer: Color(secondaryContainer),
      onSecondaryContainer: Color(onSecondaryContainer),
      tertiary: Color(tertiary),
      onTertiary: Color(onTertiary),
      tertiaryContainer: Color(tertiaryContainer),
      onTertiaryContainer: Color(onTertiaryContainer),
      error: Color(error),
      onError: Color(onError),
      errorContainer: Color(errorContainer),
      onErrorContainer: Color(onErrorContainer),
      surface: Color(surface),
      onSurface: Color(onSurface),
      surfaceContainerHighest: Color(surfaceVariant),
      onSurfaceVariant: Color(onSurfaceVariant),
      outline: Color(outline),
      outlineVariant: Color(outlineVariant),
      shadow: Color(shadow),
      scrim: Color(scrim),
      inverseSurface: Color(inverseSurface),
      inversePrimary: Color(inversePrimary),
      brightness: brightness
    );
  }
}