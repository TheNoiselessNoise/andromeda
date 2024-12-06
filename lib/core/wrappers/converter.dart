import 'package:andromeda/core/_.dart';

class AndromedaConverter {
  static final _widgets = {
    // Andromeda A Widgets
    AndromedaForLoopWidget.id:                  AndromedaForLoopWidget.new,
  
    // Flutter A Widgets
    AndromedaAnimationWidget.id:                AndromedaAnimationWidget.new,

    // Andromeda Content Widgets
    AndromedaFormWidget.id:                      AndromedaFormWidget.new,
    AndromedaBoolFieldWidget.id:                 AndromedaBoolFieldWidget.new,
    AndromedaColorFieldWidget.id:                AndromedaColorFieldWidget.new,
    AndromedaDateFieldWidget.id:                 AndromedaDateFieldWidget.new,
    AndromedaDateTimeFieldWidget.id:             AndromedaDateTimeFieldWidget.new,
    AndromedaEmailFieldWidget.id:                AndromedaEmailFieldWidget.new,
    AndromedaFileFieldWidget.id:                 AndromedaFileFieldWidget.new,
    AndromedaFloatFieldWidget.id:                AndromedaFloatFieldWidget.new,
    AndromedaImageFieldWidget.id:                AndromedaImageFieldWidget.new,
    AndromedaIntEnumFieldWidget.id:              AndromedaIntEnumFieldWidget.new,
    AndromedaPasswordFieldWidget.id:             AndromedaPasswordFieldWidget.new,
    AndromedaRangeFieldWidget.id:                AndromedaRangeFieldWidget.new,
    AndromedaSliderFieldWidget.id:               AndromedaSliderFieldWidget.new,
    AndromedaStringEnumFieldWidget.id:           AndromedaStringEnumFieldWidget.new,
    AndromedaSubmitButtonWidget.id:              AndromedaSubmitButtonWidget.new,
    AndromedaTextFieldWidget.id:                 AndromedaTextFieldWidget.new,
    AndromedaTimeFieldWidget.id:                 AndromedaTimeFieldWidget.new,
    AndromedaVarcharFieldWidget.id:              AndromedaVarcharFieldWidget.new,

    // Flutter Content Widgets
    AndromedaCardWidget.id:                      AndromedaCardWidget.new,
    AndromedaCircleAvatarWidget.id:              AndromedaCircleAvatarWidget.new,
    AndromedaDividerWidget.id:                   AndromedaDividerWidget.new,
    AndromedaExpansionTileWidget.id:             AndromedaExpansionTileWidget.new,
    AndromedaIconWidget.id:                      AndromedaIconWidget.new,
    AndromedaImageWidget.id:                     AndromedaImageWidget.new,
    AndromedaListTileWidget.id:                  AndromedaListTileWidget.new,
    AndromedaListViewWidget.id:                  AndromedaListViewWidget.new,
    AndromedaPlaceholderWidget.id:               AndromedaPlaceholderWidget.new,
    AndromedaSwitchListTileWidget.id:            AndromedaSwitchListTileWidget.new,
    AndromedaTextWidget.id:                      AndromedaTextWidget.new,

    // Flutter Decorative Widgets
    AndromedaBadgeWidget.id:                     AndromedaBadgeWidget.new,
    AndromedaChipWidget.id:                      AndromedaChipWidget.new,
    AndromedaClipOvalWidget.id:                  AndromedaClipOvalWidget.new,
    AndromedaClipPathWidget.id:                  AndromedaClipPathWidget.new,
    AndromedaClipRRectWidget.id:                 AndromedaClipRRectWidget.new,
    AndromedaClipRectWidget.id:                  AndromedaClipRectWidget.new,

    // Flutter Feedback Widgets
    AndromedaAlertDialogWidget.id:               AndromedaAlertDialogWidget.new,
    AndromedaCircularProgressIndicatorWidget.id: AndromedaCircularProgressIndicatorWidget.new,
    AndromedaLinearProgressIndicatorWidget.id:   AndromedaLinearProgressIndicatorWidget.new,
    AndromedaSnackBarActionWidget.id:            AndromedaSnackBarActionWidget.new,
    AndromedaSnackBarWidget.id:                  AndromedaSnackBarWidget.new,

    // Flutter Interactive Widgets
    AndromedaDropdownButtonWidget.id:            AndromedaDropdownButtonWidget.new,
    AndromedaDropdownMenuItemWidget.id:          AndromedaDropdownMenuItemWidget.new,
    AndromedaElevatedButtonWidget.id:            AndromedaElevatedButtonWidget.new,
    AndromedaFloatingActionButtonWidget.id:      AndromedaFloatingActionButtonWidget.new,
    AndromedaGestureDetectorWidget.id:           AndromedaGestureDetectorWidget.new,
    AndromedaIconButtonWidget.id:                AndromedaIconButtonWidget.new,
    AndromedaInkWellWidget.id:                   AndromedaInkWellWidget.new,
    AndromedaPopupMenuButtonWidget.id:           AndromedaPopupMenuButtonWidget.new,
    AndromedaRefreshIndicatorWidget.id:          AndromedaRefreshIndicatorWidget.new,
    AndromedaTextButtonWidget.id:                AndromedaTextButtonWidget.new,

    // Flutter Layout Widgets
    AndromedaAlignWidget.id:                     AndromedaAlignWidget.new,
    AndromedaCenterWidget.id:                    AndromedaCenterWidget.new,
    AndromedaColumnWidget.id:                    AndromedaColumnWidget.new,
    AndromedaConstrainedBoxWidget.id:            AndromedaConstrainedBoxWidget.new,
    AndromedaContainerWidget.id:                 AndromedaContainerWidget.new,
    AndromedaExpandedWidget.id:                  AndromedaExpandedWidget.new,
    AndromedaFlexibleWidget.id:                  AndromedaFlexibleWidget.new,
    AndromedaPaddingWidget.id:                   AndromedaPaddingWidget.new,
    AndromedaPositionedWidget.id:                AndromedaPositionedWidget.new,
    AndromedaRowWidget.id:                       AndromedaRowWidget.new,
    AndromedaSafeAreaWidget.id:                  AndromedaSafeAreaWidget.new,
    AndromedaSingleChildScrollViewWidget.id:     AndromedaSingleChildScrollViewWidget.new,
    AndromedaSizedBoxWidget.id:                  AndromedaSizedBoxWidget.new,
    AndromedaSpacerWidget.id:                    AndromedaSpacerWidget.new,
    AndromedaStackWidget.id:                     AndromedaStackWidget.new,
    AndromedaVisibilityWidget.id:                AndromedaVisibilityWidget.new,
    AndromedaWrapWidget.id:                      AndromedaWrapWidget.new,

    // Flutter Layout Advanced Widgets
    AndromedaCustomScrollViewWidget.id:          AndromedaCustomScrollViewWidget.new,
    AndromedaGridViewWidget.id:                  AndromedaGridViewWidget.new,
    AndromedaSliverAppBarWidget.id:              AndromedaSliverAppBarWidget.new,
    AndromedaSliverGridWidget.id:                AndromedaSliverGridWidget.new,
    AndromedaSliverListWidget.id:                AndromedaSliverListWidget.new,

    // Flutter Main Widgets
    AndromedaAppBarWidget.id:                    AndromedaAppBarWidget.new,
    AndromedaDrawerWidget.id:                    AndromedaDrawerWidget.new,
    AndromedaScaffoldWidget.id:                  AndromedaScaffoldWidget.new,

    // Flutter Navigation Widgets
    AndromedaBottomNavigationBarWidget.id:       AndromedaBottomNavigationBarWidget.new,
    AndromedaBottomSheetWidget.id:               AndromedaBottomSheetWidget.new,
    AndromedaTabBarViewWidget.id:                AndromedaTabBarViewWidget.new,
    AndromedaTabBarWidget.id:                    AndromedaTabBarWidget.new,

    // Flutter Utility Widgets
    AndromedaFutureBuilderWidget.id:             AndromedaFutureBuilderWidget.new,
  };

  static AndromedaWidget widget({
    required FWidget fwidget,
    required WidgetInstance parentInstance,
    required Environment environment,
    required ExpressionEvaluator evaluator,
    List<AndromedaWidget> children = const [],
  }) {
    final constructor = _widgets[fwidget.type];
    if (constructor == null) {
      throw Exception('Unknown widget type: ${fwidget.type}');
    }

    return constructor(
      widgetDef: fwidget,
      parentInstance: parentInstance,
      environment: environment,
      evaluator: evaluator,
      children: children,
    );
  }
}