import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/core/_.dart';

class ToolboxTabWidgets extends StatelessWidget {
  final TabController tabController;

  const ToolboxTabWidgets({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        return const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Text('Widgets'),
        );
      },
    );
  }
}