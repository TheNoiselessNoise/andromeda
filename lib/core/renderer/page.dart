import '../language/ast.dart';
import '../renderer/_.dart';

abstract class AndromedaPageWidget extends AndromedaWidget {
  final FPage page;

  AndromedaPageWidget({
    super.key,
    required this.page,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
  }) : super(
    widgetDef: FWidget(
      page.name.lexeme,
      stateBlock: page.stateBlock,
      styleBlock: page.styleBlock,
      renderBlock: page.renderBlock,
    ),
  );

  @override
  AndromedaWidgetState createState();
}