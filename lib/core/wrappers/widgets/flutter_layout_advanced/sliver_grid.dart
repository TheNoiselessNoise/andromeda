import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSliverGridProps extends MapTraversable {
  const AndromedaSliverGridProps(super.data);

  bool get addAutomaticKeepAlives => getBool('addAutomaticKeepAlives', true);
  bool get addRepaintBoundaries => getBool('addRepaintBoundaries', true);
  AndromedaStyleSliverGridDelegate get gridDelegate => AndromedaStyleSliverGridDelegate(getMap('gridDelegate'));
}

class AndromedaSliverGridWidget extends AndromedaWidget {
  static const String id = 'SliverGrid';
  
  AndromedaSliverGridWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSliverGridWidgetState createState() => AndromedaSliverGridWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSliverGridProps(ctx.props);

    return SliverGrid(
      gridDelegate: sliverGridDelegateFromStyle(prop.gridDelegate) ?? const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildListDelegate(await ctx.children,
        addAutomaticKeepAlives: prop.addAutomaticKeepAlives,
        addRepaintBoundaries: prop.addRepaintBoundaries,
      ),
    );
  }
}

class AndromedaSliverGridWidgetState extends AndromedaWidgetState<AndromedaSliverGridWidget> {}