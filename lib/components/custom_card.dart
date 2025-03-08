import 'package:flutter/material.dart';
import 'package:starman/theme/color_const.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.title, required this.children});
  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: .5))],
        color: ColorConst.lightSurface,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: title,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(0),
            child: Column(
              children: children,
            ),
          )
        ],
      ),
    );
  }
}
