import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:material_ui/material_ui.dart';

class TemplateView extends StatefulWidget {
  const TemplateView({super.key});

  @override
  State<TemplateView> createState() => _MyFormState();
}

class _MyFormState extends State<TemplateView> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submitForm() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.saveAndValidate()) {
      return;
    }

    debugPrint('Échelle de la plante: ${formState.value['typeEchelle']}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Échelle de la plante',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 8),
            FormBuilderDropdown<String>(
              name: 'typeEchelle',
              decoration: InputDecoration(
                hintText: 'Sélectionner une échelle',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.purple,
                    width: 1.5,
                  ),
                ),
              ),
              items: ['Plante', 'Axe', 'Phytomère']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vous devez entrer l’échelle en premier.'
                  : null,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(onPressed: _submitForm, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
