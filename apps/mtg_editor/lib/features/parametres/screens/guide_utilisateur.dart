import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class GuideUtilisateurPage extends StatefulWidget {
  @override
  _GuideUtilisateurPageState createState() => _GuideUtilisateurPageState();
}

class _GuideUtilisateurPageState extends State<GuideUtilisateurPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visionneuse PDF'),
      ),
      body: SfPdfViewer.file(
        File('package:mtgeditor/assets/pdf/Guide_Utilisation.pdf'),
      ),
    );
  }
}