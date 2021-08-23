import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';

class CustomDropdown extends StatefulWidget {
  CustomDropdown(
      {Key? key,
      required this.dropdownValue,
      required this.items,
      this.isExpanded = false})
      : super(key: key);

  String dropdownValue;
  final bool isExpanded;
  final List<String> items;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: widget.dropdownValue,
      isExpanded: widget.isExpanded,
      underline: Container(
        height: 2,
        color: kPrimaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          widget.dropdownValue = newValue!;
        });
      },
      items: widget.items.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: widget.isExpanded
              ? Text(value, overflow: TextOverflow.ellipsis)
              : Text(value),
        );
      }).toList(),
    );
  }
}
