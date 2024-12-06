import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaFutureBuilderProps extends MapTraversable {
  const AndromedaFutureBuilderProps(super.data);

  dynamic get future => get('future');
  dynamic get builder => get('builder');
  dynamic get initialData => get('initialData');
}

class AndromedaFutureBuilderStyles extends ContextableMapTraversable {
  const AndromedaFutureBuilderStyles(super.context, super.data);
}

class AndromedaFutureBuilderWidget extends AndromedaWidget {
  static const String id = 'FutureBuilder';
  
  AndromedaFutureBuilderWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaFutureBuilderWidgetState createState() => AndromedaFutureBuilderWidgetState();
}

class AndromedaFutureBuilderWidgetState extends AndromedaWidgetState<AndromedaFutureBuilderWidget> {
  Future<dynamic>? _future;
  late AndromedaWidgetContext _widgetContext;

  @override
  void initState() {
    super.initState();
    _initFuture();
  }

  Future<void> _initFuture() async {
    _widgetContext = await widgetContext;
    final prop = AndromedaFutureBuilderProps(await evaluatedProperties);
    final futureRef = prop.future;
    final handler = _widgetContext.prepareCustomHandler(futureRef, 0);
    _future = handler();
  }

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaFutureBuilderProps(ctx.props);
    
    if (_future == null) {
      return const SizedBox.shrink();
    }

    final builder = ctx.prepareCustomHandler(prop.builder, 2);

    return FutureBuilder(
      future: _future,
      initialData: prop.initialData,
      builder: (context, snapshot) {
        return FutureBuilder(
          future: builder(context, snapshot),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              throw snapshot.error!;
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            dynamic result = snapshot.data;

            if (result is FWidget) {
              return _widgetContext.render(result, widget.children) ?? const SizedBox.shrink();
            }

            return const Text("Widget was expected to be returned!");
          },
        );
      }
    );
  }
}