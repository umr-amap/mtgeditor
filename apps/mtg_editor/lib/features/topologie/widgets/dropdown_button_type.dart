import 'package:material_ui/material_ui.dart';

class DropdownButtonType extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DropdownButtonType({super.key, required this.onChanged,});

  @override
  State<DropdownButtonType> createState() => _DropdownButtonTypeState();
}
const List<String> typeList = <String>[
  'Entier',
  'String',
  'Decimal',
  'Date',
  'Bool',
];

class _DropdownButtonTypeState extends State<DropdownButtonType> {
  String dropdownValue = typeList.first;
    String getValue(){
    return dropdownValue;
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (String? value) {
        if (value == null) return;

        setState(() {
          dropdownValue = value;
        });

        widget.onChanged(value);
      },
      items: typeList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),

    );
  }
}