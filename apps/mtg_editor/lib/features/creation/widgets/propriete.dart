import 'package:flutter_form_builder/flutter_form_builder.dart';
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

  void _addFromGallery() {
    // TODO
  }

  void _addNewPhoto() {
    // TODO
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
              // TODO : Map capable d'être zoomé
              const SizedBox(height: 8.0),
              FormBuilderTextField(
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
    );
  }
}
