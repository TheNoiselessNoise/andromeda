import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaPage extends AndromedaPageWidget {
  final void Function(String, List<dynamic>) onBuiltin;

  AndromedaPage({
    super.key, 
    required super.page,
    required super.environment,
    required super.evaluator,
    required this.onBuiltin,
  }) : super(parentInstance: null);

  @override
  AndromedaPageState createState() => AndromedaPageState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    return SafeArea(child: Column(children: await ctx.children));
  }
}

class AndromedaPageState extends AndromedaWidgetState<AndromedaPage> {}