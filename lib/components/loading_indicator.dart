import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildLoadingIndicator();
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}