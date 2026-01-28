// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String labelText;
  final String value;
  final List<String> items;
  final ValueChanged<String>? onChanged;

  const CustomDropdown({super.key,
    required this.labelText,
    required this.value,
    required this.items,
    this.onChanged,  // Accept a callback function
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.purple.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            isExpanded: true,
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue!;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue!);
              }
            },
            items: widget.items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
