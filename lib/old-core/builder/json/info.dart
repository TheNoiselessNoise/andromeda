// ignore_for_file: overridden_fields
import 'package:andromeda/old-core/core.dart';

class JsonImageTypes {
  static const String asset = 'asset';
  static const String file = 'file';
  static const String url = 'url';
  static const String base64 = 'base64';
}

class JsonStyleTextStyle extends MapTraversable {
  const JsonStyleTextStyle(super.data);

  String get fontFamily => getString('fontFamily', 'Roboto');
  double? get fontSize => get('fontSize');
  String get fontWeight => getString('fontWeight', 'normal');
  String get fontStyle => getString('fontStyle', 'normal');
  double? get letterSpacing => get('letterSpacing');
  String get decoration => getString('decoration', 'none');
  String get align => getString('align', 'left');
  String get color => getString('color', '#000000');
  String? get overflow => get('overflow');
}

class JsonTextInfo extends JsonStyleTextStyle {
  const JsonTextInfo(super.data);

  String? get value => get('value');
}

class JsonSizedBoxInfo extends MapTraversable {
  const JsonSizedBoxInfo(super.data);

  double? get width => get('width');
  double? get height => get('height');
}

class JsonAlignInfo extends MapTraversable {
  const JsonAlignInfo(super.data);

  double? get widthFactor => get('widthFactor');
  double? get heightFactor => get('heightFactor');
  String get alignment => getString('alignment', 'center');
}

class JsonCenterInfo extends MapTraversable {
  const JsonCenterInfo(super.data);

  double? get widthFactor => get('widthFactor');
  double? get heightFactor => get('heightFactor');
}

class JsonExpandedInfo extends MapTraversable {
  const JsonExpandedInfo(super.data);

  int get flex => getInt('flex', 1);
}

class JsonFlexibleInfo extends MapTraversable {
  const JsonFlexibleInfo(super.data);

  int get flex => getInt('flex', 1);
  String get fit => getString('fit', 'loose');
}

class JsonRowInfo extends MapTraversable {
  const JsonRowInfo(super.data);

  String get crossAxisAlignment => getString('crossAxisAlignment', 'center');
  String get mainAxisAlignment => getString('mainAxisAlignment', 'start');
  String get mainAxisSize => getString('mainAxisSize', 'max');
  String? get textBaseline => get('textBaseline');
  String get verticalDirection => getString('verticalDirection', 'down');
}

class JsonColumnInfo extends MapTraversable {
  const JsonColumnInfo(super.data);

  String get crossAxisAlignment => getString('crossAxisAlignment', 'center');
  String get mainAxisAlignment => getString('mainAxisAlignment', 'start');
  String get mainAxisSize => getString('mainAxisSize', 'max');
  String? get textBaseline => get('textBaseline');
  String get verticalDirection => getString('verticalDirection', 'down');
}

class JsonImageInfo extends MapTraversable {
  const JsonImageInfo(super.data);

  String get type => getString('type', 'asset');
  String? get asset => get('asset');
  String? get file => get('file');
  String? get url => get('url');
  String? get base64 => get('base64');

  String get alignment => getString('alignment', 'center');
  String? get blendMode => get('blendMode');
  String get filterQuality => getString('filterQuality', 'low');
  JsonStyleRect get centerSlice => JsonStyleRect(getMap('centerSlice'));
  String? get fit => get('fit');
  String? get color => get('color');
  double? get width => get('width');
  double? get height => get('height');
  bool get isAntiAlias => getBool('isAntiAlias', false);
  String get repeat => getString('repeat', 'noRepeat');
  double? get opacity => get('opacity');
  double? get scale => get('scale');

  bool get isAsset => type == JsonImageTypes.asset;
  bool get hasAsset => isAsset && asset != null;
  bool get isValidAsset => isAsset && hasAsset;

  bool get isFile => type == JsonImageTypes.file;
  bool get hasFile => isFile && file != null;
  bool get isValidFile => isFile && hasFile;

  bool get isUrl => type == JsonImageTypes.url;
  bool get hasUrl => isUrl && url != null;
  bool get isValidUrl => isUrl && hasUrl;

  bool get isBase64 => type == JsonImageTypes.base64;
  bool get hasBase64 => isBase64 && base64 != null;
  bool get isValidBase64 => isBase64 && hasBase64;
}

class JsonCardInfo extends MapTraversable {
  const JsonCardInfo(super.data);

  String? get surfaceTintColor => get('surfaceTintColor');
  double? get elevation => get('elevation');
  String? get color => get('color');
  String? get clipBehavior => get('clipBehavior');
  JsonStyleEdgeInsets get margin => JsonStyleEdgeInsets(getMap('margin'));
  String? get shadowColor => get('shadowColor');
  bool get borderOnForeground => getBool('borderOnForeground', true);
  JsonStyleShapeBorder get shape => JsonStyleShapeBorder(getMap('shape'));
}

class JsonIconInfo extends MapTraversable {
  const JsonIconInfo(super.data);

  String get icon => get('icon', 'question_mark');
  String? get color => get('color');
  double? get size => get('size');
  double? get weight => get('weight');
  String? get textDirection => get('textDirection');
  double? get grade => get('grade');
  double? get opticalSize => get('opticalSize');
  double? get fill => get('fill');
  List<JsonStyleShadow> get shadows => getList('shadows')
    .map((e) => JsonStyleShadow(e)).toList();
  bool? get applyTextScaling => get('applyTextScaling');
}

class JsonDividerInfo extends MapTraversable {
  const JsonDividerInfo(super.data);

  String? get color => get('color');
  double? get endIndent => get('endIndent');
  double? get height => get('height');
  double? get indent => get('indent');
  double? get thickness => get('thickness');
}

class JsonVerticalDividerInfo extends MapTraversable {
  const JsonVerticalDividerInfo(super.data);

  String? get color => get('color');
  double? get endIndent => get('endIndent');
  double? get width => get('width');
  double? get indent => get('indent');
  double? get thickness => get('thickness');
}

class JsonClipRRectInfo extends MapTraversable {
  const JsonClipRRectInfo(super.data);

  String? get clipBehavior => get('clipBehavior');
  JsonStyleBorderRadius get borderRadius => JsonStyleBorderRadius(getMap('borderRadius'));
}

class JsonClipOvalInfo extends MapTraversable {
  const JsonClipOvalInfo(super.data);

  String? get clipBehavior => get('clipBehavior');
}

class JsonClipRectInfo extends MapTraversable {
  const JsonClipRectInfo(super.data);

  String? get clipBehavior => get('clipBehavior');
}

class JsonOpacityInfo extends MapTraversable {
  const JsonOpacityInfo(super.data);

  double get opacity => getDouble('opacity', 1);
}

class JsonSpacerInfo extends MapTraversable {
  const JsonSpacerInfo(super.data);

  int get flex => getInt('flex', 1);
}

class JsonWrapInfo extends MapTraversable {
  const JsonWrapInfo(super.data);

  String? get alignment => get('alignment');
  String? get crossAxisAlignment => get('crossAxisAlignment');
  String? get direction => get('direction');
  String? get runAlignment => get('runAlignment');
  double get runSpacing => getDouble('runSpacing', 0);
  double get spacing => getDouble('spacing', 0);
  String? get verticalDirection => get('verticalDirection');
  String? get clipBehavior => get('clipBehavior');
}

class JsonColoredBoxInfo extends MapTraversable {
  const JsonColoredBoxInfo(super.data);

  String get color => getString('color', '#000000');
}

class JsonBannerInfo extends JsonStyleTextStyle {
  const JsonBannerInfo(super.data);

  String get message => getString('message', 'BANNER TEXT');
  String? get bannerColor => get('bannerColor');
  String? get location => get('location');
}

class JsonConstrainedBoxInfo extends MapTraversable {
  const JsonConstrainedBoxInfo(super.data);

  JsonStyleBoxConstraints get constraints => JsonStyleBoxConstraints(getMap('constraints'));
}

class JsonIconButtonInfo extends MapTraversable {
  const JsonIconButtonInfo(super.data);

  JsonC get icon => JsonC.from(getMap('icon'));
  String? get alignment => get('alignment');
  bool get autofocus => getBool('autofocus', false);
  String? get color => get('color');
  JsonStyleBoxConstraints get constraints => JsonStyleBoxConstraints(getMap('constraints'));
  String? get disabledColor => get('disabledColor');
  bool? get enableFeedback => get('enableFeedback');
  String? get focusColor => get('focusColor');
  String? get highlightColor => get('highlightColor');
  double? get iconSize => get('iconSize');
  String? get hoverColor => get('hoverColor');
  bool? get isSelected => get('isSelected');
  JsonStyleEdgeInsets get padding => JsonStyleEdgeInsets(getMap('padding'));
  JsonC get selectedIcon => JsonC.from(getMap('selectedIcon'));
  String? get splashColor => get('splashColor');
  double? get splashRadius => get('splashRadius');
  String? get tooltip => get('tooltip');
  String? get style => get('style');
  String? get visualDensity => get('visualDensity');

  List<JsonA> get onPressed => getList('onPressed')
    .map((e) => JsonA.from(e)).toList();

  bool get hasIcon => icon.hasData;
}

class JsonListInfo extends MapTraversable {
  const JsonListInfo(super.data);

  String get mode => getString('mode', ListModes.custom);
  bool get useParentContext => getBool('useParentContext', false);
  JsonListQuery get query => JsonListQuery(getMap('query'));
  JsonListSettings get settings => JsonListSettings(getMap('settings'));
  JsonC get headerComponent => JsonC.from(getMap('headerComponent'));
  List<JsonA> get onItemTap => getList('onItemTap')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onItemDoubleTap => getList('onItemDoubleTap')
    .map((e) => JsonA.from(e)).toList();
  JsonC get itemComponent => JsonC.from(getMap('itemComponent'));
  List<Map<String, dynamic>> get customData => getList('customData');
  JsonC get divideBy => JsonC.from(getMap('divideBy'));
  JsonListRefresh get refresh => JsonListRefresh(getMap('refresh'));
  JsonListWhenEmpty get whenEmpty => JsonListWhenEmpty(getMap('whenEmpty'));

  bool get isCustomMode => mode == ListModes.custom;
  bool get isCompactMode => mode == ListModes.compact;
  bool get isExpandedMode => mode == ListModes.expanded;

  bool get hasCustomData => customData.isNotEmpty;
  bool get hasDivideBy => divideBy.data.isNotEmpty;
  bool get hasHeaderComponent => headerComponent.data.isNotEmpty;
  bool get hasItemComponent => itemComponent.data.isNotEmpty;
}

class JsonIntrinsicHeightInfo extends MapTraversable {
  const JsonIntrinsicHeightInfo(super.data);
}

class JsonIntrinsicWidthInfo extends MapTraversable {
  const JsonIntrinsicWidthInfo(super.data);

  double? get stepHeight => get('stepHeight');
  double? get stepWidth => get('stepWidth');
}

class JsonDetailInfo extends MapTraversable {
  const JsonDetailInfo(super.data);

  bool get noForm => getBool('noForm', false);

  String? get formId => get('formId');
  List<JsonA> get onFormSubmit => getList('onFormSubmit')
    .map((e) => JsonA.from(e)).toList();

  JsonDetailSettings get settings => JsonDetailSettings(getMap('settings'));
}

class JsonContainerInfo extends MapTraversable {
  const JsonContainerInfo(super.data);

  String? get alignment => get('alignment');
  String? get clipBehavior => get('clipBehavior');
  String? get color => get('color');
  JsonStyleBoxConstraints get constraints => JsonStyleBoxConstraints(getMap('constraints'));
  JsonStyleEdgeInsets get margin => JsonStyleEdgeInsets(getMap('margin'));
  JsonStyleEdgeInsets get padding => JsonStyleEdgeInsets(getMap('padding'));
  JsonStyleDecoration get decoration => JsonStyleDecoration(getMap('decoration'));
  JsonStyleDecoration get foregroundDecoration => JsonStyleDecoration(getMap('foregroundDecoration'));
  double? get height => get('height');
  double? get width => get('width');
  String? get transformAlignment => get('transformAlignment');
}

class JsonFieldInfo extends MapTraversable {
  const JsonFieldInfo(super.data);

  bool get editable => getBool('editable');
  bool get newEntity => getBool('newEntity');
  bool get translatable => getBool('translatable');
  bool get readOnly => getBool('readOnly');
}

class JsonExtendedWidgetInfo extends MapTraversable {  
  const JsonExtendedWidgetInfo(super.data);

  final Map<String, String> definedOutputs = const {};
  Map<String, String> get outputs => getMap('outputs');
  Map<String, String> get defaultOutputs => {
    ...definedOutputs,
    ...outputs
  };

  JsonC get headerComponent => JsonC.from(getMap('headerComponent'));
  JsonC get footerComponent => JsonC.from(getMap('footerComponent'));

  bool get hasHeaderComponent => headerComponent.data.isNotEmpty;
  bool get hasFooterComponent => footerComponent.data.isNotEmpty;
}

class JsonCameraInfo extends JsonExtendedWidgetInfo {
  const JsonCameraInfo(super.data);

  @override
  final Map<String, String> definedOutputs = const {
    'photoFile': 'photoFile',
  };

  String? get defaultCamera => get('defaultCamera');
  String? get flashMode  => get('flashMode');
  List<JsonA> get onPhotoTaken => getList('onPhotoTaken')
    .map((e) => JsonA.from(e)).toList();

  JsonC get topComponent => JsonC.from(getMap('topComponent'));
  JsonC get topWhenPhotoTakenComponent => JsonC.from(getMap('topWhenPhotoTakenComponent'));
  JsonC get buttonsComponent => JsonC.from(getMap('buttonsComponent'));
  JsonC get takePhotoComponent => JsonC.from(getMap('takePhotoComponent'));
  JsonC get loadingComponent => JsonC.from(getMap('loadingComponent'));
  JsonC get noCameraComponent => JsonC.from(getMap('noCameraComponent'));

  bool get hasTopComponent => topComponent.data.isNotEmpty;
  bool get hasTopWhenPhotoTakenComponent => topWhenPhotoTakenComponent.data.isNotEmpty;
  bool get hasButtonsComponent => buttonsComponent.data.isNotEmpty;
  bool get hasTakePhotoComponent => takePhotoComponent.data.isNotEmpty;
  bool get hasLoadingComponent => loadingComponent.data.isNotEmpty;
  bool get hasNoCameraComponent => noCameraComponent.data.isNotEmpty;
}

class JsonZebraScannerInfo extends JsonExtendedWidgetInfo {
  const JsonZebraScannerInfo(super.data);

  @override
  final Map<String, String> definedOutputs = const {
    'barcodeString': 'barcodeString',
    'barcodeSymbology': 'barcodeSymbology',
    'scanTime': 'scanTime'
  };

  List<JsonA> get onScan => getList('onScan')
    .map((e) => JsonA.from(e)).toList();
}

class JsonEspoLoginFormInfo extends JsonExtendedWidgetInfo {
  const JsonEspoLoginFormInfo(super.data);

  List<JsonA> get onLoggedIn => getList('onLoggedIn')
    .map((e) => JsonA.from(e)).toList();
}

class JsonGestureDetectorInfo extends MapTraversable {
  const JsonGestureDetectorInfo(super.data);

  List<JsonA> get onTapDown => getList('onTapDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTapUp => getList('onTapUp')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTap => getList('onTap')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTapCancel => getList('onTapCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryTap => getList('onSecondaryTap')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryTapDown => getList('onSecondaryTapDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryTapUp => getList('onSecondaryTapUp')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryTapCancel => getList('onSecondaryTapCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryTapDown => getList('onTertiaryTapDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryTapUp => getList('onTertiaryTapUp')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryTapCancel => getList('onTertiaryTapCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onDoubleTapDown => getList('onDoubleTapDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onDoubleTap => getList('onDoubleTap')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onDoubleTapCancel => getList('onDoubleTapCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPressDown => getList('onLongPressDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPressCancel => getList('onLongPressCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPress => getList('onLongPress')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPressStart => getList('onLongPressStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPressMoveUpdate => getList('onLongPressMoveUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPressUp => getList('onLongPressUp')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPressEnd => getList('onLongPressEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPressDown => getList('onSecondaryLongPressDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPressCancel => getList('onSecondaryLongPressCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPress => getList('onSecondaryLongPress')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPressStart => getList('onSecondaryLongPressStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPressMoveUpdate => getList('onSecondaryLongPressMoveUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPressUp => getList('onSecondaryLongPressUp')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSecondaryLongPressEnd => getList('onSecondaryLongPressEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPressDown => getList('onTertiaryLongPressDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPressCancel => getList('onTertiaryLongPressCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPress => getList('onTertiaryLongPress')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPressStart => getList('onTertiaryLongPressStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPressMoveUpdate => getList('onTertiaryLongPressMoveUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPressUp => getList('onTertiaryLongPressUp')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTertiaryLongPressEnd => getList('onTertiaryLongPressEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onVerticalDragDown => getList('onVerticalDragDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onVerticalDragStart => getList('onVerticalDragStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onVerticalDragUpdate => getList('onVerticalDragUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onVerticalDragEnd => getList('onVerticalDragEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onVerticalDragCancel => getList('onVerticalDragCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onHorizontalDragDown => getList('onHorizontalDragDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onHorizontalDragStart => getList('onHorizontalDragStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onHorizontalDragUpdate => getList('onHorizontalDragUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onHorizontalDragEnd => getList('onHorizontalDragEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onHorizontalDragCancel => getList('onHorizontalDragCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onForcePressStart => getList('onForcePressStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onForcePressPeak => getList('onForcePressPeak')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onForcePressUpdate => getList('onForcePressUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onForcePressEnd => getList('onForcePressEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onPanDown => getList('onPanDown')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onPanStart => getList('onPanStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onPanUpdate => getList('onPanUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onPanEnd => getList('onPanEnd')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onPanCancel => getList('onPanCancel')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onScaleStart => getList('onScaleStart')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onScaleUpdate => getList('onScaleUpdate')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onScaleEnd => getList('onScaleEnd')
    .map((e) => JsonA.from(e)).toList();
}

class JsonCircularProgressIndicatorInfo extends MapTraversable {
  const JsonCircularProgressIndicatorInfo(super.data);

  String? get backgroundColor => get('backgroundColor');
  String? get color => get('color');
  double? get strokeAlign => get('strokeAlign');
  String? get strokeCap => get('strokeCap');
  double? get strokeWidth => get('strokeWidth');
  double? get value => get('value');
  String? get valueColor => get('valueColor');
}

class JsonLinearProgressIndicatorInfo extends MapTraversable {
  const JsonLinearProgressIndicatorInfo(super.data);

  String? get backgroundColor => get('backgroundColor');
  String? get color => get('color');
  double? get minHeight => get('minHeight');
  double? get value => get('value');
  String? get valueColor => get('valueColor');
  JsonStyleBorderRadius get borderRadius => JsonStyleBorderRadius(getMap('borderRadius'));
}

class JsonButtonInfo extends MapTraversable {
  const JsonButtonInfo(super.data);

  JsonStyleButton get style => JsonStyleButton(getMap('style'));

  List<JsonA> get onPressed => getList('onPressed')
    .map((e) => JsonA.from(e)).toList();

  List<JsonA> get onLongPress => getList('onLongPress')
    .map((e) => JsonA.from(e)).toList();
}

class JsonCustomInfo extends MapTraversable {
  const JsonCustomInfo(super.data);

  String? get name => get('name');
}

class JsonInputInfo extends MapTraversable {
  const JsonInputInfo(super.data);

  String get id => getString('id');
  bool get readOnly => getBool('readOnly', false);
  bool get required => getBool('required', false);
  List<JsonA> get onChanged => getList('onChanged')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onSaved => getList('onSaved')
    .map((e) => JsonA.from(e)).toList();
}

class JsonFormInfo extends MapTraversable {
  const JsonFormInfo(super.data);

  String get id => getString('id');
  List<JsonA> get onSubmit => getList('onSubmit')
    .map((e) => JsonA.from(e)).toList();
}

class JsonFormInputTextInfo extends JsonInputInfo {
  const JsonFormInputTextInfo(super.data);

  String? get defaultValue => get('defaultValue');
}

class JsonFormInputIntInfo extends JsonInputInfo {
  const JsonFormInputIntInfo(super.data);

  int? get defaultValue => get('defaultValue');
}

class JsonFormInputDoubleInfo extends JsonInputInfo {
  const JsonFormInputDoubleInfo(super.data);

  double? get defaultValue => get('defaultValue');
}

class JsonFormInputEnumInfo extends JsonInputInfo {
  const JsonFormInputEnumInfo(super.data);

  List<dynamic> get items => getList('items');
  dynamic get defaultValue => get('defaultValue');
}

class JsonScaffoldInfo extends MapTraversable {
  const JsonScaffoldInfo(super.data);

  JsonC get appBar => JsonC.from(getMap('appBar'));
  String? get backgroundColor => get('backgroundColor');
  JsonC get body => JsonC.from(getMap('body'));
  JsonC get bottomNavigationBar => JsonC.from(getMap('bottomNavigationBar'));
  JsonC get bottomSheet => JsonC.from(getMap('bottomSheet'));
  JsonC get drawer => JsonC.from(getMap('drawer'));
  String get drawerDragStartBehavior => getString('drawerDragStartBehavior', 'start');
  double? get drawerEdgeDragWidth => get('drawerEdgeDragWidth');
  bool get drawerEnableOpenDragGesture => getBool('drawerEnableOpenDragGesture', true);
  String? get drawerScrimColor => get('drawerScrimColor');
  JsonC get endDrawer => JsonC.from(getMap('endDrawer'));
  bool get endDrawerEnableOpenDragGesture => getBool('endDrawerEnableOpenDragGesture', true);
  bool get extendBody => getBool('extendBody', false);
  bool get extendBodyBehindAppBar => getBool('extendBodyBehindAppBar', false);
  JsonC get floatingActionButton => JsonC.from(getMap('floatingActionButton'));
  String? get floatingActionButtonLocation => get('floatingActionButtonLocation');
  String get persistentFooterAlignment => getString('persistentFooterAlignment', 'centerEnd');
  bool get primary => getBool('primary', true);
  bool? get resizeToAvoidBottomInset => get('resizeToAvoidBottomInset');
  List<JsonC> get persistentFooterButtons => getList('persistentFooterButtons')
    .map((e) => JsonC.from(e)).toList();
  List<JsonA> get onDrawerChanged => getList('onDrawerChanged')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onEndDrawerChanged => getList('onEndDrawerChanged')
    .map((e) => JsonA.from(e)).toList();

  bool get hasAppBar => appBar.data.isNotEmpty;
  bool get hasBody => body.data.isNotEmpty;
  bool get hasBottomNavigationBar => bottomNavigationBar.data.isNotEmpty;
  bool get hasBottomSheet => bottomSheet.data.isNotEmpty;
  bool get hasDrawer => drawer.data.isNotEmpty;
  bool get hasEndDrawer => endDrawer.data.isNotEmpty;
  bool get hasFloatingActionButton => floatingActionButton.data.isNotEmpty;
}

class JsonAppBarInfo extends MapTraversable {
  const JsonAppBarInfo(super.data);

  List<JsonC> get actions => getList('actions')
    .map((e) => JsonC.from(e)).toList();
  JsonC get title => JsonC.from(getMap('title'));
  JsonC get leading => JsonC.from(getMap('leading'));
  JsonC get bottom => JsonC.from(getMap('bottom'));
  bool get automaticallyImplyLeading => getBool('automaticallyImplyLeading', true);
  String? get backgroundColor => get('backgroundColor');
  double get bottomOpacity => getDouble('bottomOpacity', 1.0);
  bool? get centerTitle => get('centerTitle');
  String? get clipBehavior => get('clipBehavior');
  double? get elevation => get('elevation');
  bool get forceMaterialTransparency => getBool('forceMaterialTransparency', false);
  String? get foregroundColor => get('foregroundColor');
  JsonC get flexibleSpace => JsonC.from(getMap('flexibleSpace'));
  double? get leadingWidth => get('leadingWidth');
  bool get primary => getBool('primary', true);
  double? get scrolledUnderElevation => get('scrolledUnderElevation');
  String? get shadowColor => get('shadowColor');
  JsonStyleShapeBorder get shape => JsonStyleShapeBorder(getMap('shape'));
  String? get surfaceTintColor => get('surfaceTintColor');
  double? get titleSpacing => get('titleSpacing');
  JsonStyleTextStyle get titleTextStyle => JsonStyleTextStyle(getMap('titleTextStyle'));
  double? get toolbarHeight => get('toolbarHeight');
  double get toolbarOpacity => getDouble('toolbarOpacity', 1.0);
  JsonStyleTextStyle get toolbarTextStyle => JsonStyleTextStyle(getMap('toolbarTextStyle'));

  bool get hasTitle => title.data.isNotEmpty;
  bool get hasLeading => leading.data.isNotEmpty;
  bool get hasBottom => bottom.data.isNotEmpty;
  bool get hasFlexibleSpace => flexibleSpace.data.isNotEmpty;
}

class JsonSafeAreaInfo extends MapTraversable {
  const JsonSafeAreaInfo(super.data);

  bool get left => getBool('left', true);
  bool get top => getBool('top', true);
  bool get bottom => getBool('bottom', true);
  bool get right => getBool('right', true);
  bool get maintainBottomViewPadding => getBool('maintainBottomViewPadding', false);
  JsonStyleEdgeInsets get minimum => JsonStyleEdgeInsets(getMap('minimum'));

  bool get hasMinimum => minimum.data.isNotEmpty;
}

class JsonListTileInfo extends MapTraversable {
  const JsonListTileInfo(super.data);

  bool get autofocus => getBool('autofocus', false);
  JsonStyleEdgeInsets get contentPadding => JsonStyleEdgeInsets(getMap('contentPadding'));
  bool? get dense => get('dense');
  bool? get enableFeedback => get('enableFeedback');
  bool get enabled => getBool('enabled', true);
  String? get focusColor => get('focusColor');
  double? get horizontalTitleGap => get('horizontalTitleGap');
  String? get hoverColor => get('hoverColor');
  String? get iconColor => get('iconColor');
  bool get isThreeLine => getBool('isThreeLine', false);
  JsonC get leading => JsonC.from(getMap('leading'));
  JsonStyleTextStyle get leadingAndTrailingTextStyle => JsonStyleTextStyle(getMap('leadingAndTrailingTextStyle'));
  double? get minLeadingWidth => get('minLeadingWidth');
  double? get minTileHeight => get('minTileHeight');
  double? get minVerticalPadding => get('minVerticalPadding');
  List<JsonA> get onFocusChange => getList('onFocusChange')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onLongPress => getList('onLongPress')
    .map((e) => JsonA.from(e)).toList();
  List<JsonA> get onTap => getList('onTap')
    .map((e) => JsonA.from(e)).toList();
  bool get selected => getBool('selected', false);
  String? get selectedColor => get('selectedColor');
  String? get selectedTileColor => get('selectedTileColor');
  JsonStyleShapeBorder get shape => JsonStyleShapeBorder(getMap('shape'));
  String? get splashColor => get('splashColor');
  JsonC get subtitle => JsonC.from(getMap('subtitle'));
  JsonStyleTextStyle get subtitleTextStyle => JsonStyleTextStyle(getMap('subtitleTextStyle'));
  String? get textColor => get('textColor');
  String? get tileColor => get('tileColor');
  JsonC get title => JsonC.from(getMap('title'));
  String? get titleAlignment => get('titleAlignment');
  String? get style => get('style');
  JsonStyleTextStyle get titleTextStyle => JsonStyleTextStyle(getMap('titleTextStyle'));
  JsonC get trailing => JsonC.from(getMap('trailing'));
  String? get visualDensity => get('visualDensity');

  bool get hasLeading => leading.data.isNotEmpty;
  bool get hasSubtitle => subtitle.data.isNotEmpty;
  bool get hasTitle => title.data.isNotEmpty;
  bool get hasTrailing => trailing.data.isNotEmpty;
}

class JsonDefaultTabControllerInfo extends MapTraversable {
  const JsonDefaultTabControllerInfo(super.data);

  int get length => getInt('length', 0);
  JsonStyleDuration get animationDuration => JsonStyleDuration(getMap('animationDuration'));
  int get initialIndex => getInt('initialIndex', 0);
}

class JsonTabInfo extends MapTraversable {
  const JsonTabInfo(super.data);

  double? get height => get('height');
  JsonC get icon => JsonC.from(getMap('icon'));
  JsonStyleEdgeInsets get iconMargin => JsonStyleEdgeInsets(getMap('iconMargin'));
  String? get text => get('text');

  bool get hasIcon => icon.data.isNotEmpty;
}

class JsonTabBarInfo extends MapTraversable {
  const JsonTabBarInfo(super.data);

  List<JsonC> get tabs => getList('tabs')
    .map((e) => JsonC.from(e)).toList();

  bool get automaticIndicatorColorAdjustment => getBool('automaticIndicatorColorAdjustment', true);
  String? get dividerColor => get('dividerColor');
  double? get dividerHeight => get('dividerHeight');
  String get dragStartBehavior => getString('dragStartBehavior', 'start');
  bool? get enableFeedback => get('enableFeedback');
  JsonStyleDecoration get indicator => JsonStyleDecoration(getMap('indicator'));
  String? get indicatorColor => get('indicatorColor');
  JsonStyleEdgeInsets get indicatorPadding => JsonStyleEdgeInsets(getMap('indicatorPadding'));
  String? get indicatorSize => get('indicatorSize');
  double get indicatorWeight => getDouble('indicatorWeight', 2.0);
  bool get isScrollable => getBool('isScrollable', false);
  String? get labelColor => get('labelColor');
  JsonStyleEdgeInsets get labelPadding => JsonStyleEdgeInsets(getMap('labelPadding'));
  JsonStyleTextStyle get labelStyle => JsonStyleTextStyle(getMap('labelStyle'));
  JsonStyleEdgeInsets get padding => JsonStyleEdgeInsets(getMap('padding'));
  JsonStyleBorderRadius get splashBorderRadius => JsonStyleBorderRadius(getMap('splashBorderRadius'));
  String? get tabAlignment => get('tabAlignment');
  String? get unselectedLabelColor => get('unselectedLabelColor');
  JsonStyleTextStyle get unselectedLabelStyle => JsonStyleTextStyle(getMap('unselectedLabelStyle'));

  List<JsonA> get onTap => getList('onTap')
    .map((e) => JsonA.from(e)).toList();
}

class JsonTabBarViewInfo extends MapTraversable {
  const JsonTabBarViewInfo(super.data);

  String get clipBehavior => getString('clipBehavior', 'hardEdge');
  String get dragStartBehavior => getString('dragStartBehavior', 'start');
  double get viewportFraction => getDouble('viewportFraction', 1.0);
}

class JsonSingleChildScrollViewInfo extends MapTraversable {
  const JsonSingleChildScrollViewInfo(super.data);

  String get clipBehavior => getString('clipBehavior', 'hardEdge');
  String get dragStartBehavior => getString('dragStartBehavior', 'start');
  JsonStyleEdgeInsets get padding => JsonStyleEdgeInsets(getMap('padding'));
  bool get primary => getBool('primary', false);
  bool get reverse => getBool('reverse', false);
  String get scrollDirection => getString('scrollDirection', 'vertical');
}

class JsonExpansionTileInfo extends MapTraversable {
  const JsonExpansionTileInfo(super.data);

  JsonC get title => JsonC.from(getMap('title'));
  JsonC get leading => JsonC.from(getMap('leading'));
  JsonC get subtitle => JsonC.from(getMap('subtitle'));
  JsonC get trailing => JsonC.from(getMap('trailing'));
  String? get backgroundColor => get('backgroundColor');
  JsonStyleEdgeInsets get childrenPadding => JsonStyleEdgeInsets(getMap('childrenPadding'));
  String? get clipBehavior => get('clipBehavior');
  String? get collapsedBackgroundColor => get('collapsedBackgroundColor');
  String? get collapsedIconColor => get('collapsedIconColor');
  String? get collapsedTextColor => get('collapsedTextColor');
  String? get controlAffinity => get('controlAffinity');
  bool? get dense => get('dense');
  bool? get enableFeedback => get('enableFeedback');
  bool get enabled => getBool('enabled', true);
  // JsonStyleAlignment get expandedAlignment => JsonStyleAlignment(getMap('expandedAlignment'));
  String? get expandedCrossAxisAlignment => get('expandedCrossAxisAlignment');
  String? get iconColor => get('iconColor');
  bool get initiallyExpanded => getBool('initiallyExpanded', false);
  bool get maintainState => getBool('maintainState', false);
  double? get minTileHeight => get('minTileHeight');
  String? get textColor => get('textColor');
  JsonStyleEdgeInsets get tilePadding => JsonStyleEdgeInsets(getMap('tilePadding'));
  String? get visualDensity => get('visualDensity');
  JsonStyleShapeBorder get shape => JsonStyleShapeBorder(getMap('shape'));
  JsonStyleShapeBorder get collapsedShape => JsonStyleShapeBorder(getMap('collapsedShape'));
  List<JsonA> get onExpansionChanged => getList('onExpansionChanged')
    .map((e) => JsonA.from(e)).toList();

  bool get hasTitle => title.data.isNotEmpty;
  bool get hasLeading => leading.data.isNotEmpty;
  bool get hasSubtitle => subtitle.data.isNotEmpty;
  bool get hasTrailing => trailing.data.isNotEmpty;
}

class JsonListViewInfo extends MapTraversable {
  const JsonListViewInfo(super.data);

  JsonC get prototypeItem => JsonC.from(getMap('prototypeItem'));
  bool get addAutomaticKeepAlives => getBool('addAutomaticKeepAlives', true);
  bool get addRepaintBoundaries => getBool('addRepaintBoundaries', true);
  bool get addSemanticIndexes => getBool('addSemanticIndexes', true);
  double? get cacheExtent => get('cacheExtent');
  String get clipBehavior => getString('clipBehavior', 'hardEdge');
  String get dragStartBehavior => getString('dragStartBehavior', 'start');
  double? get itemExtent => get('itemExtent');
  String get keyboardDismissBehavior => getString('keyboardDismissBehavior', 'manual');
  JsonStyleEdgeInsets get padding => JsonStyleEdgeInsets(getMap('padding'));
  bool get primary => getBool('primary', false);
  bool get reverse => getBool('reverse', false);
  String get scrollDirection => getString('scrollDirection', 'vertical');
  bool get shrinkWrap => getBool('shrinkWrap', false);

  bool get hasPrototypeItem => prototypeItem.data.isNotEmpty;
}

class JsonDrawerInfo extends MapTraversable {
  const JsonDrawerInfo(super.data);

  String? get backgroundColor => get('backgroundColor');
  String? get clipBehavior => get('clipBehavior');
  double? get elevation => get('elevation');
  String? get shadowColor => get('shadowColor');
  JsonStyleShapeBorder get shape => JsonStyleShapeBorder(getMap('shape'));
  String? get surfaceTintColor => get('surfaceTintColor');
  double? get width => get('width');
}

class JsonFaIconInfo extends MapTraversable {
  const JsonFaIconInfo(super.data);

  String get icon => getString('icon', 'solidCircleQuestion');
  String? get color => get('color');
  double? get size => get('size');
  List<JsonStyleShadow> get shadows => getList('shadows')
    .map((e) => JsonStyleShadow(e)).toList();
  String? get textDirection => get('textDirection');
}

class JsonPaddingInfo extends MapTraversable {
  const JsonPaddingInfo(super.data);

  JsonStyleEdgeInsets get padding => JsonStyleEdgeInsets(getMap('padding'));
}

class JsonPositionedInfo extends MapTraversable {
  const JsonPositionedInfo(super.data);

  double? get left => get('left');
  double? get top => get('top');
  double? get bottom => get('bottom');
  double? get right => get('right');
  double? get width => get('width');
  double? get height => get('height');
}

class JsonStackInfo extends MapTraversable {
  const JsonStackInfo(super.data);

  String get fit => getString('fit', 'loose');
  String get alignment => getString('alignment', 'topStart');
  String get clipBehavior => getString('clipBehavior', 'hardEdge');
  String get dragStartBehavior => getString('dragStartBehavior', 'start');
}

class JsonBuilderInfo extends MapTraversable {
  const JsonBuilderInfo(super.data);

  JsonC get component => JsonC.from(getMap('component'));
}

class JsonEspoTabListInfo extends MapTraversable {
  const JsonEspoTabListInfo(super.data);
}

class JsonCInfo extends MapTraversable {
  const JsonCInfo(super.data);

  JsonStylePadding get paddingStyle => JsonStylePadding(getMap('paddingStyle'));

  JsonCustomInfo get customInfo => JsonCustomInfo(getMap('custom'));
  JsonFieldInfo get fieldInfo => JsonFieldInfo(getMap('field'));
  JsonFieldInfo get transFieldInfo => JsonFieldInfo(getMap('transField'));
  JsonTextInfo get textInfo => JsonTextInfo(getMap('text'));
  JsonSizedBoxInfo get sizedBoxInfo => JsonSizedBoxInfo(getMap('sizedBox'));
  JsonAlignInfo get alignInfo => JsonAlignInfo(getMap('align'));
  JsonCenterInfo get centerInfo => JsonCenterInfo(getMap('center'));
  JsonExpandedInfo get expandedInfo => JsonExpandedInfo(getMap('expanded'));
  JsonFlexibleInfo get flexibleInfo => JsonFlexibleInfo(getMap('flexible'));
  JsonRowInfo get rowInfo => JsonRowInfo(getMap('row'));
  JsonColumnInfo get columnInfo => JsonColumnInfo(getMap('column'));
  JsonImageInfo get imageInfo => JsonImageInfo(getMap('image'));
  JsonIconInfo get iconInfo => JsonIconInfo(getMap('icon'));
  JsonCardInfo get cardInfo => JsonCardInfo(getMap('card'));
  JsonDividerInfo get dividerInfo => JsonDividerInfo(getMap('divider'));
  JsonVerticalDividerInfo get verticalDividerInfo => JsonVerticalDividerInfo(getMap('verticalDivider'));
  JsonClipRRectInfo get clipRRectInfo => JsonClipRRectInfo(getMap('clipRRect'));
  JsonClipOvalInfo get clipOvalInfo => JsonClipOvalInfo(getMap('clipOval'));
  JsonClipRectInfo get clipRectInfo => JsonClipRectInfo(getMap('clipRect'));
  JsonOpacityInfo get opacityInfo => JsonOpacityInfo(getMap('opacity'));
  JsonSpacerInfo get spacerInfo => JsonSpacerInfo(getMap('spacer'));
  JsonWrapInfo get wrapInfo => JsonWrapInfo(getMap('wrap'));
  JsonColoredBoxInfo get coloredBoxInfo => JsonColoredBoxInfo(getMap('coloredBox'));
  JsonBannerInfo get bannerInfo => JsonBannerInfo(getMap('banner'));
  JsonConstrainedBoxInfo get constrainedBoxInfo => JsonConstrainedBoxInfo(getMap('constrainedBox'));
  JsonIconButtonInfo get iconButtonInfo => JsonIconButtonInfo(getMap('iconButton'));
  JsonIntrinsicHeightInfo get intrinsicHeightInfo => JsonIntrinsicHeightInfo(getMap('intrinsicHeight'));
  JsonIntrinsicWidthInfo get intrinsicWidthInfo => JsonIntrinsicWidthInfo(getMap('intrinsicWidth'));
  JsonContainerInfo get containerInfo => JsonContainerInfo(getMap('container'));
  JsonButtonInfo get buttonInfo => JsonButtonInfo(getMap('button'));
  JsonGestureDetectorInfo get gestureDetectorInfo => JsonGestureDetectorInfo(getMap('gestureDetector'));
  JsonCircularProgressIndicatorInfo get circularProgressIndicatorInfo => JsonCircularProgressIndicatorInfo(getMap('circularProgressIndicator'));
  JsonLinearProgressIndicatorInfo get linearProgressIndicatorInfo => JsonLinearProgressIndicatorInfo(getMap('linearProgressIndicator'));
  JsonListTileInfo get listTileInfo => JsonListTileInfo(getMap('listTile'));
  JsonSingleChildScrollViewInfo get singleChildScrollViewInfo => JsonSingleChildScrollViewInfo(getMap('singleChildScrollView'));
  JsonExpansionTileInfo get expansionTileInfo => JsonExpansionTileInfo(getMap('expansionTile'));
  JsonListViewInfo get listViewInfo => JsonListViewInfo(getMap('listView'));
  JsonFaIconInfo get faIconInfo => JsonFaIconInfo(getMap('faIcon'));
  JsonPaddingInfo get paddingInfo => JsonPaddingInfo(getMap('padding'));
  JsonPositionedInfo get positionedInfo => JsonPositionedInfo(getMap('positioned'));
  
  JsonScaffoldInfo get scaffoldInfo => JsonScaffoldInfo(getMap('scaffold'));
  JsonAppBarInfo get appBarInfo => JsonAppBarInfo(getMap('appBar'));
  JsonSafeAreaInfo get safeAreaInfo => JsonSafeAreaInfo(getMap('safeArea'));
  JsonStackInfo get stackInfo => JsonStackInfo(getMap('stack'));
  JsonDrawerInfo get drawerInfo => JsonDrawerInfo(getMap('drawer'));

  JsonBuilderInfo get builderInfo => JsonBuilderInfo(getMap('builder'));

  JsonDefaultTabControllerInfo get defaultTabControllerInfo => JsonDefaultTabControllerInfo(getMap('defaultTabController'));
  JsonTabInfo get tabInfo => JsonTabInfo(getMap('tab'));
  JsonTabBarInfo get tabBarInfo => JsonTabBarInfo(getMap('tabBar'));
  JsonTabBarViewInfo get tabBarViewInfo => JsonTabBarViewInfo(getMap('tabBarView'));

  JsonFormInfo get formInfo => JsonFormInfo(getMap('form'));
  JsonFormInputTextInfo get formInputTextInfo => JsonFormInputTextInfo(getMap('formInputText'));
  JsonFormInputIntInfo get formInputIntInfo => JsonFormInputIntInfo(getMap('formInputInt'));
  JsonFormInputDoubleInfo get formInputDoubleInfo => JsonFormInputDoubleInfo(getMap('formInputDouble'));
  JsonFormInputEnumInfo get formInputEnumInfo => JsonFormInputEnumInfo(getMap('formInputEnum'));

  JsonListInfo get listInfo => JsonListInfo(getMap('list'));
  JsonDetailInfo get detailInfo => JsonDetailInfo(getMap('detail'));

  JsonEspoTabListInfo get espoTabListInfo => JsonEspoTabListInfo(getMap('espoTabList'));
  JsonEspoLoginFormInfo get espoLoginFormInfo => JsonEspoLoginFormInfo(getMap('espoLoginForm'));
  JsonCameraInfo get cameraInfo => JsonCameraInfo(getMap('camera'));
  JsonZebraScannerInfo get zebraScannerInfo => JsonZebraScannerInfo(getMap('zebraScanner'));

  void get testingEnvDontUseMe {
    // just some space for converting to my JSON magic
  }
}
