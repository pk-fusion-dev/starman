import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosLoadingIndication extends StatelessWidget {
  const IosLoadingIndication({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildLoadingIndicator();
  }

  Widget _buildLoadingIndicator() {
    return const CupertinoActivityIndicator(
      color: Colors.white,
    );
  }
}