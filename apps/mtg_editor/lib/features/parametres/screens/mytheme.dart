import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  // ---------------------------------------------------------------------------
  // Palette (relevée sur les maquettes)
  // ---------------------------------------------------------------------------

  // Mode nuit
  static const Color darkBackground = Color(0xFF4F378B); // fond violet
  static const Color darkSurface = Color(0xFF21005D); // cartes + barre de nav
  static const Color darkBorder = Color(0xFFCAC4D0); // liseré des cartes
  static const Color darkOnSurface = Colors.white;

  // Mode jour
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Color(0xFFFFF7FF); // cartes
  static const Color lightBorder = Color(0xFFD9CCE3); // liseré des cartes
  static const Color lightNavBar = Color(0xFFF3EDF7); // barre de nav
  static const Color lightOnSurface = Color(0xFF1D1B20);
  static const Color lightSwitchGrey = Color(0xFF79747E);

  // 1 – Thème de texte clair
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.roboto(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: lightOnSurface,
    ),
    displayLarge: GoogleFonts.roboto(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: lightOnSurface,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: lightOnSurface,
    ),
    displaySmall: GoogleFonts.roboto(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: lightOnSurface,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: lightOnSurface,
    ),
  );

  // 2 – Thème de texte sombre
  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.roboto(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: darkOnSurface,
    ),
    displayLarge: GoogleFonts.roboto(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: darkOnSurface,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: darkOnSurface,
    ),
    displaySmall: GoogleFonts.roboto(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: darkOnSurface,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: darkOnSurface,
    ),
  );

  // Style des petits libellés de la barre de navigation
  static TextStyle _navLabel(Color color) => GoogleFonts.roboto(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: color,
  );

  // 3 – Thème clair (mode jour)
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: lightOnSurface,
        onPrimary: Colors.white,
        surface: lightBackground,
        onSurface: lightOnSurface,
        outline: lightBorder,
      ),
      iconTheme: const IconThemeData(color: lightOnSurface),
      appBarTheme: const AppBarTheme(
        foregroundColor: lightOnSurface,
        backgroundColor: lightBackground,
        elevation: 0,
      ),
      // Cartes "Night Mode", "Guide d'Utilisation", "Archive"
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: lightOnSurface,
        textColor: lightOnSurface,
      ),
      // Interrupteur (désactivé en mode jour : piste claire, pastille grise)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.white
              : lightSwitchGrey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? darkBackground
              : const Color(0xFFE6E0E9);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.transparent
              : lightSwitchGrey;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) => lightOnSurface),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: lightOnSurface,
      ),
      // Barre de navigation (Plantes / Création / Paramètres)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightNavBar,
        elevation: 0,
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: lightOnSurface),
        ),
        labelTextStyle: WidgetStateProperty.all(_navLabel(lightOnSurface)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightNavBar,
        selectedItemColor: lightOnSurface,
        unselectedItemColor: lightOnSurface,
      ),
      textTheme: lightTextTheme,
    );
  }

  // 4 – Thème sombre (mode nuit)
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: darkSurface,
        surface: darkBackground,
        onSurface: darkOnSurface,
        outline: darkBorder,
      ),
      iconTheme: const IconThemeData(color: darkOnSurface),
      appBarTheme: const AppBarTheme(
        foregroundColor: darkOnSurface,
        backgroundColor: darkBackground,
        elevation: 0,
      ),
      // Cartes : violet très foncé avec liseré clair
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: darkOnSurface,
        textColor: darkOnSurface,
      ),
      // Interrupteur activé en mode nuit : piste violette, pastille blanche
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.white
              : const Color(0xFF938F99);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? darkBackground
              : darkSurface;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? darkBorder
              : const Color(0xFF938F99);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) => Colors.white),
        checkColor: WidgetStateProperty.all(darkSurface),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: darkSurface,
        backgroundColor: Colors.white,
      ),
      // Barre de navigation : même violet foncé que les cartes
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        elevation: 0,
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: darkOnSurface),
        ),
        labelTextStyle: WidgetStateProperty.all(_navLabel(darkOnSurface)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
      textTheme: darkTextTheme,
    );
  }
}