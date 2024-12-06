import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSliverListProps extends MapTraversable {
  const AndromedaSliverListProps(super.data);

  bool get addAutomaticKeepAlives => getBool('addAutomaticKeepAlives', true);
  bool get addRepaintBoundaries => getBool('addRepaintBoundaries', true);
}

class AndromedaSliverListWidget extends AndromedaWidget {
  static const String id = 'SliverList';
  
  AndromedaSliverListWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSliverListWidgetState createState() => AndromedaSliverListWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSliverListProps(ctx.props);

    return SliverList(
      delegate: SliverChildListDelegate(await ctx.children,
        addAutomaticKeepAlives: prop.addAutomaticKeepAlives,
        addRepaintBoundaries: prop.addRepaintBoundaries,
      ),
    );
  }
}

class AndromedaSliverListWidgetState extends AndromedaWidgetState<AndromedaSliverListWidget> {}