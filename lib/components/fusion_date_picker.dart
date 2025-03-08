import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FusionDatePick extends StatelessWidget {
  FusionDatePick(
      {super.key, required this.onSelected, this.width, this.selectedDate});
  Function(String?) onSelected;
  final double? width;
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    selectedDate ??= 'Today';
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    //   child: DropdownMenu(
    //     width: width,
    //     initialSelection: "today",
    //     dropdownMenuEntries: const [
    //       DropdownMenuEntry(value: "today", label: "today"),
    //       DropdownMenuEntry(value: "yesterday", label: "Yesterday"),
    //       DropdownMenuEntry(value: "thismonth", label: "This Month"),
    //       DropdownMenuEntry(value: "lastmonth", label: "Last Month"),
    //     ],
    //     onSelected: onSelected,
    //   ),
    // );
    return DropdownButton<String>(
      // dropdownColor: Colors.white,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      value: selectedDate,
      items: const [
        DropdownMenuItem(
          value: "Today",
          child: Text("ယနေ့"),
        ),
        DropdownMenuItem(
          value: "Yesterday",
          child: Text("မနေ့က"),
        ),
        DropdownMenuItem(
          value: "This Month",
          child: Text("ယခုလ"),
        ),
        DropdownMenuItem(
          value: "Last Month",
          child: Text("ယခင်လ"),
        ),
      ],
      onChanged: onSelected,
      hint: const Text('Select Date',style: TextStyle(color: Colors.white),),
    );
  }
}
