import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FusionDatePick extends StatelessWidget {
  FusionDatePick(
      {super.key, required this.onSelected, this.width, this.selectedDate});
  Function(String?) onSelected;
  final double? width;
  String? selectedDate;

  @override
  Widget build(Object context) {
    selectedDate ??= 'Today';
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    //   child: DropdownMenu(
    //     width: width,
    //     initialSelection: "today",
    //     dropdownMenuEntries: const [
    //       DropdownMenuEntry(value: "today", label: "Today"),
    //       DropdownMenuEntry(value: "yesterday", label: "Yesterday"),
    //       DropdownMenuEntry(value: "thismonth", label: "This Month"),
    //       DropdownMenuEntry(value: "lastmonth", label: "Last Month"),
    //     ],
    //     onSelected: onSelected,
    //   ),
    // );
    return DropdownButton<String>(
      value: selectedDate,
      items: const [
        DropdownMenuItem(
          value: "Today",
          child: Text("Today"),
        ),
        DropdownMenuItem(
          value: "Yesterday",
          child: Text("Yesterday"),
        ),
        DropdownMenuItem(
          value: "This Month",
          child: Text("This Month"),
        ),
        DropdownMenuItem(
          value: "Last Month",
          child: Text("Last Month"),
        ),
      ],
      onChanged: onSelected,
      hint: const Text('Select Date'),
    );
  }
}
