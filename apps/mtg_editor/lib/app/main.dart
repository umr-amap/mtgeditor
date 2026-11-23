import 'package:material_ui/material_ui.dart';
import 'package:mtg_editor/features/liste_plantes/screens/list_plantes_screen.dart';
import 'package:provider/provider.dart';
import 'package:mtg_editor/features/parametres/viewmodels/setting_view_model.dart';
import 'package:mtg_editor/features/parametres/screens/mytheme.dart';
import '../database/app_database.dart';

AppDatabase database = AppDatabase();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SettingViewModel()),
    ],
      child: MyApp(database: database),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.database, super.key});

  final AppDatabase database;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTG Editor',
      theme: context.watch<SettingViewModel>().isDark ? MyTheme.dark() : MyTheme.light(),
      home: ListPlantesScreen(database: database),
    );
  }
}
