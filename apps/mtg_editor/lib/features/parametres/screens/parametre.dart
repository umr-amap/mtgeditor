import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import './mytheme.dart';
import '../viewmodels/setting_view_model.dart';
import 'archive.dart';
import 'guide_utilisateur.dart';

class EcranSettings extends StatelessWidget {
  const EcranSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // On écoute les changements du ViewModel
    final settingsViewModel = context.watch<SettingViewModel>();
    final bool isDark = settingsViewModel.isDark;

    return SafeArea(
      child: Center(
        child: SettingsList(
          darkTheme: SettingsThemeData(
            settingsListBackground: MyTheme.dark().scaffoldBackgroundColor,
            settingsSectionBackground: MyTheme.dark().cardColor,
          ),
          lightTheme: SettingsThemeData(
            settingsListBackground: MyTheme.light().scaffoldBackgroundColor,
            settingsSectionBackground: MyTheme.light().cardColor,
          ),
          sections: [
            SettingsSection(
              title: const Text("Paramètres"),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: isDark,
                  onToggle: (bool value) {
                    // On met à jour le ViewModel
                    settingsViewModel.isDark = value;
                  },
                  title: const Text("Night Mode"),
                  leading: const Icon(Icons.dark_mode_outlined),
                ),
                SettingsTile.navigation(
                  title: const Text("Guide Utilisateur"),
                  leading: const Icon(Icons.book),
                  onPressed: (BuildContext context) {
                    // On va à la page Guide Utilisateur
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => GuideUtilisateurPage(),
                      ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  title: const Text("Archive"),
                  leading: const Icon(Icons.archive_outlined),
                  onPressed: (BuildContext context) {
                    // On va à la page Archive
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const ArchiveApp(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}