import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/star_links/providers/star_links_provider.dart';

// ignore: must_be_immutable
class ShopDropdown extends ConsumerWidget {
  ShopDropdown({super.key, required this.onSelected, this.selectedItem});
  Function(String?) onSelected;
  String? selectedItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datas = ref.watch(starLinksProvider);
    if (datas.isEmpty) {
      ref.read(starLinksProvider.notifier).getStarLinks();
    }
    return DropdownButton<String>(
      // dropdownColor: Theme.of(context).colorScheme.secondary,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      value: selectedItem,
      items: datas.map((data) {
        return DropdownMenuItem<String>(
          value: data.userId,
          child: Text(data.warehouseName.toString()),
        );
      }).toList(),
      onChanged: onSelected,
      hint: const Text('Select Shop'),
    );
  }
}
