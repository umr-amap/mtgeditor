import 'dart:typed_data';

import 'package:latlong2/latlong.dart';
import 'package:mtg_editor/features/creation/widgets/map.dart';

import '';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

class ProprieteView extends StatefulWidget {
  const ProprieteView({super.key});

  @override
  State<ProprieteView> createState() => _MyFormState();
}

class _MyFormState extends State<ProprieteView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _textFieldController = TextEditingController();
  final List<FormBuilderTextField> _natureFields = [];
  late Future<List<FormBuilderTextField>> _naturesFuture;
  final List<Uint8List> _images = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _naturesFuture = Future.value(_natureFields);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  Future<void> _addFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      final mimeType = pickedFile.mimeType;
      if (mimeType == null || !mimeType.startsWith('image/')) {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Type de fichier incorrect'),
              content: const Text('Veuillez sélectionner une image.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final bytes = await pickedFile.readAsBytes();
      if (!mounted) {
        return;
      }

      setState(() {
        _images.add(bytes);
      });
    }
  }

  Future<void> _addNewPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null && mounted) {
      final bytes = await pickedFile.readAsBytes();
      if (!mounted) {
        return;
      }

      setState(() {
        _images.add(bytes);
      });
    }
  }

  void _deletePhoto(int index) {
    if (index < 0 || index >= _images.length) {
      return;
    }

    setState(() {
      _images.removeAt(index);
    });
  }

  Widget _buildImages() {
    if (_images.isEmpty) {
      return const Center(child: Text('Aucune image choisie'));
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (var index = 0; index < _images.length; index++)
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(_images[index], fit: BoxFit.cover),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Supprimer cette image',
                      onPressed: () => _deletePhoto(index),
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<String?> _displayTextInputDialog(BuildContext context) async {
    _textFieldController.clear();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nom attribut'),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Insérer le nom de l'attribut",
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ANNULER'),
            ),
            ElevatedButton(
              onPressed: () {
                final label = _textFieldController.text.trim();
                if (label.isNotEmpty) {
                  Navigator.pop(context, label);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNewTextField() async {
    final label = await _displayTextInputDialog(context);
    if (!mounted || label == null) {
      return;
    }

    final field = FormBuilderTextField(
      name: 'nature_${_natureFields.length + 1}',
      decoration: InputDecoration(labelText: label),
    );

    setState(() {
      _natureFields.add(field);
      _naturesFuture = Future.value(
        List<FormBuilderTextField>.unmodifiable(_natureFields),
      );
    });
  }

  Widget _buildNatureFields(
    AsyncSnapshot<List<FormBuilderTextField>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Erreur: ${snapshot.error}'));
    }

    final fields = snapshot.data ?? const <FormBuilderTextField>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final field in fields) ...[const SizedBox(height: 8), field],
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _addNewTextField,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter un attribut'),
        ),
      ],
    );
  }

  void _submitForm() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.saveAndValidate()) {
      return;
    }

    debugPrint('Échelle de la plante: ${formState.value['typeEchelle']}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                FormBuilderTextField(
                  name: 'id',
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Nom de la plante',
                  ),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: '1',
                  decoration: const InputDecoration(labelText: 'Hauteur'),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: '2',
                  decoration: const InputDecoration(labelText: 'Diamètre'),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: '3',
                  decoration: const InputDecoration(
                    labelText: 'Surface des feuilles',
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<FormBuilderTextField>>(
                  future: _naturesFuture,
                  builder: (context, snapshot) => _buildNatureFields(snapshot),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Ajouter des photos :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addFromGallery,
                        child: const Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 5.0),
                            Text('Ajouter'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: _addNewPhoto,
                      child: Icon(Icons.photo_camera),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                _buildImages(),
                const SizedBox(height: 20.0),
                const Text(
                  'Ajouter la localisation GPS :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 8.0),
                MapScreen(position: LatLng(52.518611, 13.408056)),
                const SizedBox(height: 8.0),
                FormBuilderTextField(
                  // TODO : Ajout une sécurité pour une localisation valide
                  name: 'localisation',
                  decoration: const InputDecoration(
                    labelText: 'Localisation',
                    hintText: 'Ex: 48°51\'24"N, 2°21\'08″E',
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Continuer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
