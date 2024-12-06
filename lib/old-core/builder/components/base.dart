import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class ParentContext {
  EspoEntity? parentEntity;
  EspoEntity? entity;

  CoreBaseFormState? formState;

  ParentContext({
    this.parentEntity,
    this.entity,
    this.formState,
  });

  ParentContext copy() {
    return ParentContext(
      parentEntity: parentEntity,
      entity: entity,
      formState: formState,
    );
  }

  ParentContext copyWith({
    CoreBaseFormState? formState,
    EspoEntity? entity,
  }) {
    return ParentContext(
      formState: formState ?? this.formState,
      parentEntity: entity != null ? this.entity ?? parentEntity : parentEntity,
      entity: entity ?? this.entity ?? EspoEntity('entityType', {
        'id': Generator.rNumericString(8, '__new__')
      }),
    );
  }

  ParentContext withEntity(EspoEntity entity) {
    return copyWith(entity: entity);
  }

  ParentContext withFormState(CoreBaseFormState formState) {
    return copyWith(formState: formState);
  }
}

class CWBuilder {
  final BuildContext context;
  
  const CWBuilder(this.context);

  JsonP page(BuildContext context) {
    return context.coreBloc.getCurrentPage();
  }
  
  String? entityType(BuildContext context, JsonC? fromComponent, ParentContext parentContext) {
    if (fromComponent != null && fromComponent.overrideEntityType != null) {
      return fromComponent.overrideEntityType;
    }

    if (parentContext.entity is EspoEntity) {
      return (parentContext.entity as EspoEntity).entityType;
    }

    return page(context).entityType;
  }

  Widget applyPadding(JsonC component, Widget child) {
    JsonStylePadding padding = component.info.paddingStyle;

    if (padding.hasLTRB) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          padding.left,
          padding.top,
          padding.right,
          padding.bottom,
        ),
        child: child,
      );
    }

    if (padding.hasAll) {
      return Padding(
        padding: EdgeInsets.all(padding.all),
        child: child,
      );
    }

    if (padding.hasVerticalHorizontal) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: padding.vertical,
          horizontal: padding.horizontal,
        ),
        child: child,
      );
    }

    return child;
  }

  Widget buildCanBeWithoutInnerComponent(BuildContext context, JsonC component, ParentContext parentContext) {
    Widget inner = buildComponent(context, component.innerComponent, parentContext);

    if (component.isButton) {
      JsonButtonInfo buttonInfo = component.info.buttonInfo;

      return EspoTextButton(
        styleOptions: buttonStyleOptionsFromStyle(buttonInfo.style),
        onPressed: ActionBuilder.directFunctionWithArg(context, buttonInfo.onPressed, parentContext),
        onLongPress: ActionBuilder.directFunctionWithArg(context, buttonInfo.onLongPress, parentContext),
        child: inner
      );
    }

    if (component.isSizedBox) {
      return SizedBox(
        width: component.info.sizedBoxInfo.width,
        height: component.info.sizedBoxInfo.height,
        child: inner,
      );
    }

    if (component.isAlign) {
      return Align(
        widthFactor: component.info.alignInfo.widthFactor,
        heightFactor: component.info.alignInfo.heightFactor,
        alignment: alignmentGeometryFromString(component.info.alignInfo.alignment) ?? Alignment.center,
        child: inner,
      );
    }

    if (component.isCard) {
      JsonCardInfo cardInfo = component.info.cardInfo;

      return Card(
        borderOnForeground: cardInfo.borderOnForeground,
        clipBehavior: clipFromString(cardInfo.clipBehavior),
        color: themeColorFromString(cardInfo.color, context),
        elevation: cardInfo.elevation,
        margin: edgeInsetsFromStyle(cardInfo.margin),
        shadowColor: themeColorFromString(cardInfo.shadowColor, context),
        // TODO: this
        // shape: shapeBorderFromString(cardInfo.shape),
        surfaceTintColor: themeColorFromString(cardInfo.surfaceTintColor, context),
        child: inner,
      );
    }

    if (component.isClipRRect) {
      return ClipRRect(
        clipBehavior: clipFromString(component.info.clipRRectInfo.clipBehavior) ?? Clip.antiAlias,
        borderRadius: borderRadiusGeometryFromStyle(component.info.clipRRectInfo.borderRadius) ?? BorderRadius.zero,
        child: inner,
      );
    }

    if (component.isClipOval) {
      return ClipOval(
        clipBehavior: clipFromString(component.info.clipRRectInfo.clipBehavior) ?? Clip.antiAlias,
        child: inner,
      );
    }

    if (component.isClipRect) {
      return ClipRect(
        clipBehavior: clipFromString(component.info.clipRRectInfo.clipBehavior) ?? Clip.antiAlias,
        child: inner,
      );
    }

    if (component.isOpacity) {
      return Opacity(
        opacity: component.info.opacityInfo.opacity,
        child: inner,
      );
    }

    if (component.isColoredBox) {
      return ColoredBox(
        color: themeColorFromString(component.info.coloredBoxInfo.color, context) ?? Colors.transparent,
        child: inner,
      );
    }

    if (component.isBanner) {
      JsonBannerInfo bannerInfo = component.info.bannerInfo;

      return Banner(
        location: bannerLocationFromString(bannerInfo.location) ?? BannerLocation.topStart,
        message: bannerInfo.message,
        color: themeColorFromString(bannerInfo.bannerColor, context) ?? themeColorFromString("#B71C1C", context)!,
        textStyle: textStyleFromStyle(bannerInfo),
        child: inner,
      );
    }

    if (component.isConstrainedBox) {
      return ConstrainedBox(
        constraints: boxConstraintsFromStyle(component.info.constrainedBoxInfo.constraints) ?? const BoxConstraints(),
        child: inner,
      );
    }

    if (component.isIntrinsicHeight) {
      return IntrinsicHeight(
        child: inner,
      );
    }

    if (component.isIntrinsicWidth) {
      return IntrinsicWidth(
        stepHeight: component.info.intrinsicWidthInfo.stepHeight,
        stepWidth: component.info.intrinsicWidthInfo.stepWidth,
        child: inner,
      );
    }

    if (component.isContainer) {
      JsonContainerInfo containerInfo = component.info.containerInfo;

      return Container(
        alignment: alignmentGeometryFromString(containerInfo.alignment),
        clipBehavior: clipFromString(containerInfo.clipBehavior) ?? Clip.none,
        color: themeColorFromString(containerInfo.color, context),
        constraints: boxConstraintsFromStyle(containerInfo.constraints),
        decoration: decorationFromStyle(containerInfo.decoration, context),
        foregroundDecoration: decorationFromStyle(containerInfo.foregroundDecoration, context),
        height: containerInfo.height,
        width: containerInfo.width,
        margin: edgeInsetsFromStyle(containerInfo.margin),
        padding: edgeInsetsFromStyle(containerInfo.padding),
        transformAlignment: alignmentGeometryFromString(containerInfo.transformAlignment),
        child: inner,
      );
    }

    if (component.isGestureDetector) {
      JsonGestureDetectorInfo gdInfo = component.info.gestureDetectorInfo;

      return GestureDetector(
        onTapDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onTapDown, parentContext),
        onTapUp: ActionBuilder.directFunctionWithArg(context, gdInfo.onTapUp, parentContext),
        onTap: ActionBuilder.directFunction(context, gdInfo.onTap, parentContext),
        onTapCancel: ActionBuilder.directFunction(context, gdInfo.onTapCancel, parentContext),
        onSecondaryTap: ActionBuilder.directFunction(context, gdInfo.onSecondaryTap, parentContext),
        onSecondaryTapDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onSecondaryTapDown, parentContext),
        onSecondaryTapUp: ActionBuilder.directFunctionWithArg(context, gdInfo.onSecondaryTapUp, parentContext),
        onSecondaryTapCancel: ActionBuilder.directFunction(context, gdInfo.onSecondaryTapCancel, parentContext),
        onTertiaryTapDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onTertiaryTapDown, parentContext),
        onTertiaryTapUp: ActionBuilder.directFunctionWithArg(context, gdInfo.onTertiaryTapUp, parentContext),
        onTertiaryTapCancel: ActionBuilder.directFunction(context, gdInfo.onTertiaryTapCancel, parentContext),
        onDoubleTapDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onDoubleTapDown, parentContext),
        onDoubleTap: ActionBuilder.directFunction(context, gdInfo.onDoubleTap, parentContext),
        onDoubleTapCancel: ActionBuilder.directFunction(context, gdInfo.onDoubleTapCancel, parentContext),
        onLongPressDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onLongPressDown, parentContext),
        onLongPressCancel: ActionBuilder.directFunction(context, gdInfo.onLongPressCancel, parentContext),
        onLongPress: ActionBuilder.directFunction(context, gdInfo.onLongPress, parentContext),
        onLongPressStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onLongPressStart, parentContext),
        onLongPressMoveUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onLongPressMoveUpdate, parentContext),
        onLongPressUp: ActionBuilder.directFunction(context, gdInfo.onLongPressUp, parentContext),
        onLongPressEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onLongPressEnd, parentContext),
        onSecondaryLongPressDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onSecondaryLongPressDown, parentContext),
        onSecondaryLongPressCancel: ActionBuilder.directFunction(context, gdInfo.onSecondaryLongPressCancel, parentContext),
        onSecondaryLongPress: ActionBuilder.directFunction(context, gdInfo.onSecondaryLongPress, parentContext),
        onSecondaryLongPressStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onSecondaryLongPressStart, parentContext),
        onSecondaryLongPressMoveUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onSecondaryLongPressMoveUpdate, parentContext),
        onSecondaryLongPressUp: ActionBuilder.directFunction(context, gdInfo.onSecondaryLongPressUp, parentContext),
        onSecondaryLongPressEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onSecondaryLongPressEnd, parentContext),
        onTertiaryLongPressDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onTertiaryLongPressDown, parentContext),
        onTertiaryLongPressCancel: ActionBuilder.directFunction(context, gdInfo.onTertiaryLongPressCancel, parentContext),
        onTertiaryLongPress: ActionBuilder.directFunction(context, gdInfo.onTertiaryLongPress, parentContext),
        onTertiaryLongPressStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onTertiaryLongPressStart, parentContext),
        onTertiaryLongPressMoveUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onTertiaryLongPressMoveUpdate, parentContext),
        onTertiaryLongPressUp: ActionBuilder.directFunction(context, gdInfo.onTertiaryLongPressUp, parentContext),
        onTertiaryLongPressEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onTertiaryLongPressEnd, parentContext),
        onVerticalDragDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onVerticalDragDown, parentContext),
        onVerticalDragStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onVerticalDragStart, parentContext),
        onVerticalDragUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onVerticalDragUpdate, parentContext),
        onVerticalDragEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onVerticalDragEnd, parentContext),
        onVerticalDragCancel: ActionBuilder.directFunction(context, gdInfo.onVerticalDragCancel, parentContext),
        onHorizontalDragDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onHorizontalDragDown, parentContext),
        onHorizontalDragStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onHorizontalDragStart, parentContext),
        onHorizontalDragUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onHorizontalDragUpdate, parentContext),
        onHorizontalDragEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onHorizontalDragEnd, parentContext),
        onHorizontalDragCancel: ActionBuilder.directFunction(context, gdInfo.onHorizontalDragCancel, parentContext),
        onForcePressStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onForcePressStart, parentContext),
        onForcePressPeak: ActionBuilder.directFunctionWithArg(context, gdInfo.onForcePressPeak, parentContext),
        onForcePressUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onForcePressUpdate, parentContext),
        onForcePressEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onForcePressEnd, parentContext),
        onPanDown: ActionBuilder.directFunctionWithArg(context, gdInfo.onPanDown, parentContext),
        onPanStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onPanStart, parentContext),
        onPanUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onPanUpdate, parentContext),
        onPanEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onPanEnd, parentContext),
        onPanCancel: ActionBuilder.directFunction(context, gdInfo.onPanCancel, parentContext),
        onScaleStart: ActionBuilder.directFunctionWithArg(context, gdInfo.onScaleStart, parentContext),
        onScaleUpdate: ActionBuilder.directFunctionWithArg(context, gdInfo.onScaleUpdate, parentContext),
        onScaleEnd: ActionBuilder.directFunctionWithArg(context, gdInfo.onScaleEnd, parentContext),
        // dragStartBehavior: dragStartBehaviorFromString(gestureDetectorInfo.dragStartBehavior) ?? DragStartBehavior.start,
        // behavior: hitTestBehaviorFromString(gestureDetectorInfo.behavior),
        child: inner
      );
    }

    if (component.isForm) {
      JsonFormInfo formInfo = component.info.formInfo;

      return CoreBaseForm(
        id: formInfo.id,
        builder: (p0, p1, p2) => inner,
        onSubmit: ActionBuilder.directFunctionWithArg(context, formInfo.onSubmit, parentContext),
      );
    }

    if (component.isTab) {
      JsonTabInfo tabInfo = component.info.tabInfo;

      return Tab(
        height: tabInfo.height,
        icon: tabInfo.hasIcon ? iconFromComponent(tabInfo.icon, context) : null,
        iconMargin: edgeInsetsFromStyle(tabInfo.iconMargin),
        text: tabInfo.text,
        child: inner
      );
    }

    if (component.isSingleChildScrollView) {
      JsonSingleChildScrollViewInfo scsvInfo = component.info.singleChildScrollViewInfo;

      return SingleChildScrollView(
        clipBehavior: clipFromString(scsvInfo.clipBehavior) ?? Clip.hardEdge,
        dragStartBehavior: dragStartBehaviorFromString(scsvInfo.dragStartBehavior) ?? DragStartBehavior.start,
        padding: edgeInsetsFromStyle(scsvInfo.padding),
        primary: scsvInfo.primary,
        reverse: scsvInfo.reverse,
        scrollDirection: axisFromString(scsvInfo.scrollDirection) ?? Axis.vertical,
        child: inner,
      );
    }

    if (component.isDrawer) {
      JsonDrawerInfo drawerInfo = component.info.drawerInfo;

      return Drawer(
        backgroundColor: themeColorFromString(drawerInfo.backgroundColor, context),
        clipBehavior: clipFromString(drawerInfo.clipBehavior),
        elevation: drawerInfo.elevation,
        shadowColor: themeColorFromString(drawerInfo.shadowColor, context),
        // shape: shapeBorderFromString(drawerInfo.shape),
        surfaceTintColor: themeColorFromString(drawerInfo.surfaceTintColor, context),
        width: drawerInfo.width,
        child: Builder(builder: (context) => buildComponent(context, component.innerComponent, parentContext)),
      );
    }

    if (component.isPadding) {
      return Padding(
        padding: edgeInsetsFromStyle(component.info.paddingInfo.padding) ?? EdgeInsets.zero,
        child: inner,
      );
    }

    return Text("Unknown can be without inner component: ${component.type}");
  }

  Widget buildMustHaveInnerComponent(BuildContext context, JsonC component, ParentContext parentContext) {
    Widget inner = buildComponent(context, component.innerComponent, parentContext);

    if (component.isCenter) {
      return Center(
        widthFactor: component.info.centerInfo.widthFactor,
        heightFactor: component.info.centerInfo.heightFactor,
        child: inner
      );
    }

    if (component.isExpanded) {
      return Expanded(
        flex: component.info.expandedInfo.flex,
        child: inner
      );
    }

    if (component.isFlexible) {
      return Flexible(
        fit: flexFitFromString(component.info.flexibleInfo.fit) ?? FlexFit.loose,
        flex: component.info.flexibleInfo.flex,
        child: inner,
      );
    }

    if (component.isSafeArea) {
      return SafeArea(
        left: component.info.safeAreaInfo.left,
        top: component.info.safeAreaInfo.top,
        right: component.info.safeAreaInfo.right,
        bottom: component.info.safeAreaInfo.bottom,
        maintainBottomViewPadding: component.info.safeAreaInfo.maintainBottomViewPadding,
        minimum: (edgeInsetsFromStyle(component.info.safeAreaInfo.minimum) as EdgeInsets?) ?? EdgeInsets.zero,
        child: inner,
      );
    }

    if (component.isDefaultTabController) {
      JsonDefaultTabControllerInfo dtcInfo = component.info.defaultTabControllerInfo;

      return DefaultTabController(
        length: dtcInfo.length,
        animationDuration: durationFromStyle(dtcInfo.animationDuration),
        initialIndex: dtcInfo.initialIndex,
        child: inner,
      );
    }

    if (component.isPositioned) {
      JsonPositionedInfo pInfo = component.info.positionedInfo;

      return Positioned(
        left: pInfo.left,
        top: pInfo.top,
        right: pInfo.right,
        bottom: pInfo.bottom,
        width: pInfo.width,
        height: pInfo.height,
        child: inner,
      );
    }

    return Text('Unknown must have inner component type: ${component.type}');    
  }

  Widget buildInnerComponentWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    // MUST HAVE INNER COMPONENT

    if (!component.hasNoChild && !component.canBeWithoutInnerComponent) {
      return buildMustHaveInnerComponent(context, component, parentContext);
    }

    // CAN BE WITHOUT INNER COMPONENT

    if (!component.hasNoChild && component.canBeWithoutInnerComponent) {
      return buildCanBeWithoutInnerComponent(context, component, parentContext);
    }

    return Text('No inner component for ${component.type}');
  }

  Widget buildInnerComponentsWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    List<Widget> children = component.innerComponents!
      .map((e) => buildComponentWidget(context, e, parentContext))
      .toList();

    if (component.isRow) {
      JsonRowInfo rowInfo = component.info.rowInfo;

      return Row(
        crossAxisAlignment: crossAxisAlignmentFromString(rowInfo.crossAxisAlignment) ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignmentFromString(rowInfo.mainAxisAlignment) ?? MainAxisAlignment.start,
        mainAxisSize: mainAxisSizeFromString(rowInfo.mainAxisSize) ?? MainAxisSize.max,
        textBaseline: textBaselineFromString(rowInfo.textBaseline),
        verticalDirection: verticalDirectionFromString(rowInfo.verticalDirection) ?? VerticalDirection.down,
        children: children
      );
    }

    if (component.isColumn) {
      JsonColumnInfo columnInfo = component.info.columnInfo;

      return Column(
        crossAxisAlignment: crossAxisAlignmentFromString(columnInfo.crossAxisAlignment) ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignmentFromString(columnInfo.mainAxisAlignment) ?? MainAxisAlignment.start,
        mainAxisSize: mainAxisSizeFromString(columnInfo.mainAxisSize) ?? MainAxisSize.max,
        textBaseline: textBaselineFromString(columnInfo.textBaseline),
        verticalDirection: verticalDirectionFromString(columnInfo.verticalDirection) ?? VerticalDirection.down,
        children: children
      );
    }

    if (component.isWrap) {
      JsonWrapInfo wrapInfo = component.info.wrapInfo;

      return Wrap(
        alignment: wrapAlignmentFromString(wrapInfo.alignment) ?? WrapAlignment.start,
        crossAxisAlignment: wrapCrossAlignmentFromString(wrapInfo.crossAxisAlignment) ?? WrapCrossAlignment.start,
        direction: axisFromString(wrapInfo.direction) ?? Axis.horizontal,
        runAlignment: wrapAlignmentFromString(wrapInfo.runAlignment) ?? WrapAlignment.start,
        runSpacing: wrapInfo.runSpacing,
        spacing: wrapInfo.spacing,
        verticalDirection: verticalDirectionFromString(wrapInfo.verticalDirection) ?? VerticalDirection.down,
        clipBehavior: clipFromString(wrapInfo.clipBehavior) ?? Clip.none,
        children: children
      );
    }

    if (component.isTabBarView) {
      JsonTabBarViewInfo tbvInfo = component.info.tabBarViewInfo;

      return TabBarView(
        clipBehavior: clipFromString(tbvInfo.clipBehavior) ?? Clip.hardEdge,
        dragStartBehavior: dragStartBehaviorFromString(tbvInfo.dragStartBehavior) ?? DragStartBehavior.start,
        viewportFraction: tbvInfo.viewportFraction,
        children: children,
      );
    }

    if (component.isExpansionTile) {
      JsonExpansionTileInfo etInfo = component.info.expansionTileInfo;

      return ExpansionTile(
        title: etInfo.hasTitle ? buildComponent(context, etInfo.title, parentContext) : const Text('ExpansionTile'),
        leading: etInfo.hasLeading ? buildComponent(context, etInfo.leading, parentContext) : null,
        subtitle: etInfo.hasSubtitle ? buildComponent(context, etInfo.subtitle, parentContext) : null,
        trailing: etInfo.hasTrailing ? buildComponent(context, etInfo.trailing, parentContext) : null,
        backgroundColor: themeColorFromString(etInfo.backgroundColor, context),
        childrenPadding: edgeInsetsFromStyle(etInfo.childrenPadding),
        clipBehavior: clipFromString(etInfo.clipBehavior),
        collapsedBackgroundColor: themeColorFromString(etInfo.collapsedBackgroundColor, context),
        collapsedIconColor: themeColorFromString(etInfo.collapsedIconColor, context),
        collapsedTextColor: themeColorFromString(etInfo.collapsedTextColor, context),
        controlAffinity: listTileControlAffinityFromString(etInfo.controlAffinity),
        dense: etInfo.dense,
        enableFeedback: etInfo.enableFeedback,
        enabled: etInfo.enabled,
        // expandedAlignment: Alignment?,
        expandedCrossAxisAlignment: crossAxisAlignmentFromString(etInfo.expandedCrossAxisAlignment),
        iconColor: themeColorFromString(etInfo.iconColor, context),
        initiallyExpanded: etInfo.initiallyExpanded,
        maintainState: etInfo.maintainState,
        minTileHeight: etInfo.minTileHeight,
        textColor: themeColorFromString(etInfo.textColor, context),
        tilePadding: edgeInsetsFromStyle(etInfo.tilePadding),
        visualDensity: visualDensityFromString(etInfo.visualDensity),
        // shape: ShapeBorder?,
        // collapsedShape: ShapeBorder?,
        onExpansionChanged: ActionBuilder.directFunctionWithArg(context, etInfo.onExpansionChanged, parentContext),
        children: children,
      );
    }

    if (component.isListView) {
      JsonListViewInfo lvInfo = component.info.listViewInfo;

      return ListView(
        prototypeItem: lvInfo.hasPrototypeItem ? buildComponent(context, lvInfo.prototypeItem, parentContext) : null,
        addAutomaticKeepAlives: lvInfo.addAutomaticKeepAlives,
        addRepaintBoundaries: lvInfo.addRepaintBoundaries,
        addSemanticIndexes: lvInfo.addSemanticIndexes,
        cacheExtent: lvInfo.cacheExtent,
        clipBehavior: clipFromString(lvInfo.clipBehavior) ?? Clip.hardEdge,
        dragStartBehavior: dragStartBehaviorFromString(lvInfo.dragStartBehavior) ?? DragStartBehavior.start,
        itemExtent: lvInfo.itemExtent,
        keyboardDismissBehavior: scrollViewKeyboardDismissBehaviorFromString(lvInfo.keyboardDismissBehavior) ?? ScrollViewKeyboardDismissBehavior.manual,
        padding: edgeInsetsFromStyle(lvInfo.padding),
        primary: lvInfo.primary,
        reverse: lvInfo.reverse,
        scrollDirection: axisFromString(lvInfo.scrollDirection) ?? Axis.vertical,
        shrinkWrap: false,
        children: children,
      );
    }

    if (component.isStack) {
      JsonStackInfo stackInfo = component.info.stackInfo;

      return Stack(
        alignment: alignmentGeometryFromString(stackInfo.alignment) ?? AlignmentDirectional.topStart,
        clipBehavior: clipFromString(stackInfo.clipBehavior) ?? Clip.hardEdge,
        fit: stackFitFromString(stackInfo.fit) ?? StackFit.loose,
        children: children,
      );
    }

    return Text('Unknown inner components type: ${component.type}');
  }

  Widget buildSpecialComponentWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    if (component.isEspoTabList) {
      return buildComponent(context,
        LBuilder(context.metadata).buildDrawerTabList(),    
        parentContext
      );
    }

    if (component.isEspoLoginForm) {
      return EspoLoginFormWidgetBuilder.buildCoreEspoLoginForm(
        context, component, parentContext,
      );
    }

    if (component.isCamera) {
      return CameraWidgetBuilder.buildCoreCameraWidget(
        context, component, parentContext,
      );
    }

    if (component.isZebraScanner) {
      return ZebraScannerWidgetBuilder.buildCoreZebraScannerWidget(
        context, component, parentContext,
      );
    }

    return Text('Unknown special component type: ${component.type}');
  }

  Widget buildFormInputWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    if (component.type == CTypes.formInputText) {
      JsonFormInputTextInfo info = component.info.formInputTextInfo;

      return EspoVarcharField(
        id: info.id,
        initialValue: info.defaultValue,
        // NOTE: maybe this? but the value won't change for some reason as i tested
        // initialValue: info.parseValue ?
        //   ArgumentParser.parse(context, info.defaultValue, parentContext) :
        //   info.defaultValue,
        readOnly: info.readOnly,
        required: info.required,
        onChanged: ActionBuilder.directFunctionWithTwoArgs(context, info.onChanged, parentContext),
        onSaved: ActionBuilder.directFunctionWithArg(context, info.onSaved, parentContext),
      );
    }

    if (component.type == CTypes.formInputInt) {
      JsonFormInputIntInfo info = component.info.formInputIntInfo;

      return EspoIntField(
        id: info.id,
        initialValue: info.defaultValue,
        readOnly: info.readOnly,
        required: info.required,
        onChanged: ActionBuilder.directFunctionWithTwoArgs(context, info.onChanged, parentContext),
        onSaved: ActionBuilder.directFunctionWithArg(context, info.onSaved, parentContext),
      );
    }

    if (component.type == CTypes.formInputDouble) {
      JsonFormInputDoubleInfo info = component.info.formInputDoubleInfo;

      return EspoFloatField(
        id: info.id,
        initialValue: info.defaultValue,
        readOnly: info.readOnly,
        required: info.required,
        onChanged: ActionBuilder.directFunctionWithTwoArgs(context, info.onChanged, parentContext),
        onSaved: ActionBuilder.directFunctionWithArg(context, info.onSaved, parentContext),
      );
    }

    if (component.type == CTypes.formInputEnum) {
      JsonFormInputEnumInfo info = component.info.formInputEnumInfo;

      return EspoEnumField(
        id: info.id,
        items: info.items,
        // NOTE: what to do with this? another string format? §{{key}} §{{value}}
        // itemLabelBuilder: info.itemLabelBuilder,
        initialValue: info.defaultValue,
        readOnly: info.readOnly,
        required: info.required,
        onChanged: ActionBuilder.directFunctionWithTwoArgs(context, info.onChanged, parentContext),
        onSaved: ActionBuilder.directFunctionWithArg(context, info.onSaved, parentContext),
      );
    }

    return Text('Unknown form input type: ${component.type}');
  }

  Widget buildHasNoChildComponentWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    if (component.isList) {
      return EspoPageComponentListBuilder(
        component: component,
        parentContext: parentContext,
      );
    }

    if (component.isCircularProgressIndicator) {
      JsonCircularProgressIndicatorInfo cpiInfo = component.info.circularProgressIndicatorInfo;

      return CircularProgressIndicator(
        backgroundColor: themeColorFromString(cpiInfo.backgroundColor, context),
        color: themeColorFromString(cpiInfo.color, context),
        strokeAlign: cpiInfo.strokeAlign ?? CircularProgressIndicator.strokeAlignCenter,
        strokeCap: strokeCapFromString(cpiInfo.strokeCap),
        strokeWidth: cpiInfo.strokeWidth ?? 4.0,
        value: cpiInfo.value,
        // valueColor: cpiInfo.valueColor != null ?
        //   AlwaysStoppedAnimation<Color>(themeColorFromString(cpiInfo.valueColor!, context) ?? CoreTheme.of(context).primary) :
        //   null,
      );
    }

    if (component.isLinearProgressIndicator) {
      JsonLinearProgressIndicatorInfo lpiInfo = component.info.linearProgressIndicatorInfo;

      return LinearProgressIndicator(
        backgroundColor: themeColorFromString(lpiInfo.backgroundColor, context),
        color: themeColorFromString(lpiInfo.color, context),
        minHeight: lpiInfo.minHeight,
        value: lpiInfo.value,
        // valueColor: lpiInfo.valueColor != null ?
        //   AlwaysStoppedAnimation<Color>(themeColorFromString(lpiInfo.valueColor!, context) ?? CoreTheme.of(context).primary) :
        //   null,
        borderRadius: borderRadiusGeometryFromStyle(lpiInfo.borderRadius) ?? BorderRadius.zero,
      );
    }

    if (component.isText) {
      return textFromComponent(context, component, parentContext);
    }

    if (component.isImage) {
      return imageFromComponent(component, context) ??
        Text('[image] Unsupported image type: ${component.info.imageInfo.type}');
    }

    if (component.isIcon) {
      return iconFromComponent(component, context);
    }

    if (component.isIconButton) {
      return iconButtonFromComponent(context, component, parentContext) ??
        Text('[iconButton] Unsupported IconButton: ${component.info.iconButtonInfo.icon}');
    }

    if (component.isDivider) {
      return Divider(
        height: component.info.dividerInfo.height,
        thickness: component.info.dividerInfo.thickness,
        indent: component.info.dividerInfo.indent,
        endIndent: component.info.dividerInfo.endIndent,
        color: themeColorFromString(component.info.dividerInfo.color, context),
      );
    }

    if (component.isVerticalDivider) {
      return VerticalDivider(
        width: component.info.verticalDividerInfo.width,
        thickness: component.info.verticalDividerInfo.thickness,
        indent: component.info.verticalDividerInfo.indent,
        endIndent: component.info.verticalDividerInfo.endIndent,
        color: themeColorFromString(component.info.verticalDividerInfo.color, context),
      );
    }

    if (component.isSpacer) {
      return Spacer(
        flex: component.info.spacerInfo.flex,
      );
    }

    if (component.isFieldLabel) {
      return textSimpleFromComponent(
        component,
        context.metadata.getI18nField(entityType(context, component, parentContext) ?? component.overrideEntityType!, component.name),
        context
      );
    }

    if (component.isField) {
      return buildFieldComponentWidget(context, component, parentContext);
    }

    if (component.isTransField) {
      return buildTranslatableField(context, component, parentContext);
    }

    if (component.isFormInput) {
      return buildFormInputWidget(context, component, parentContext);
    }

    if (component.isScaffold) {
      JsonScaffoldInfo scaffoldInfo = component.info.scaffoldInfo;

      return Scaffold(
        appBar: scaffoldInfo.hasAppBar ? buildComponent(context, scaffoldInfo.appBar, parentContext) as PreferredSizeWidget : null,
        backgroundColor: themeColorFromString(scaffoldInfo.backgroundColor, context),
        body: scaffoldInfo.hasBody ? buildComponent(context, scaffoldInfo.body, parentContext) : null,
        bottomNavigationBar: scaffoldInfo.hasBottomNavigationBar ? buildComponent(context, scaffoldInfo.bottomNavigationBar, parentContext) : null,
        drawer: scaffoldInfo.hasDrawer ? buildComponent(context, scaffoldInfo.drawer, parentContext) : null,
        endDrawer: scaffoldInfo.hasEndDrawer ? buildComponent(context, scaffoldInfo.endDrawer, parentContext) : null,
        floatingActionButton: scaffoldInfo.hasFloatingActionButton ? buildComponent(context, scaffoldInfo.floatingActionButton, parentContext) : null,
        floatingActionButtonLocation: floatingActionButtonLocationFromString(scaffoldInfo.floatingActionButtonLocation),
        bottomSheet: scaffoldInfo.hasBottomSheet ? buildComponent(context, scaffoldInfo.bottomSheet, parentContext) : null,
        persistentFooterButtons: scaffoldInfo.persistentFooterButtons.map((e) => buildComponent(context, e, parentContext)).toList(),
        primary: scaffoldInfo.primary,
        resizeToAvoidBottomInset: scaffoldInfo.resizeToAvoidBottomInset,
        drawerDragStartBehavior: dragStartBehaviorFromString(scaffoldInfo.drawerDragStartBehavior) ?? DragStartBehavior.start,
        drawerEdgeDragWidth: scaffoldInfo.drawerEdgeDragWidth,
        drawerScrimColor: themeColorFromString(scaffoldInfo.drawerScrimColor, context),
        extendBody: scaffoldInfo.extendBody,
        extendBodyBehindAppBar: scaffoldInfo.extendBodyBehindAppBar,
        drawerEnableOpenDragGesture: scaffoldInfo.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: scaffoldInfo.endDrawerEnableOpenDragGesture,
        persistentFooterAlignment: alignmentDirectionalFromString(scaffoldInfo.persistentFooterAlignment) ?? AlignmentDirectional.centerEnd,
        onDrawerChanged: ActionBuilder.directFunctionWithArg(context, scaffoldInfo.onDrawerChanged, parentContext),
        onEndDrawerChanged: ActionBuilder.directFunctionWithArg(context, scaffoldInfo.onEndDrawerChanged, parentContext),
      );
    }

    if (component.isAppBar) {
      JsonAppBarInfo appBarInfo = component.info.appBarInfo;

      return AppBar(
        actions: appBarInfo.actions.map((e) => buildComponent(context, e, parentContext)).toList(),
        automaticallyImplyLeading: appBarInfo.automaticallyImplyLeading,
        backgroundColor: themeColorFromString(appBarInfo.backgroundColor, context),
        bottom: appBarInfo.hasBottom ? buildComponent(context, appBarInfo.bottom, parentContext) as PreferredSizeWidget : null,
        bottomOpacity: appBarInfo.bottomOpacity,
        centerTitle: appBarInfo.centerTitle,
        clipBehavior: clipFromString(appBarInfo.clipBehavior),
        elevation: appBarInfo.elevation,
        flexibleSpace: appBarInfo.hasFlexibleSpace ? buildComponent(context, appBarInfo.flexibleSpace, parentContext) : null,
        forceMaterialTransparency: appBarInfo.forceMaterialTransparency,
        foregroundColor: themeColorFromString(appBarInfo.foregroundColor, context),
        leading: appBarInfo.hasLeading ?
          Builder(builder: (context) => build(context, appBarInfo.leading, parentContext)) :
          null,
        leadingWidth: appBarInfo.leadingWidth,
        primary: appBarInfo.primary,
        scrolledUnderElevation: appBarInfo.scrolledUnderElevation,
        shadowColor: themeColorFromString(appBarInfo.shadowColor, context),
        // shape: shapeBorderFromString(appBarInfo.shape),
        surfaceTintColor: themeColorFromString(appBarInfo.surfaceTintColor, context),
        title: appBarInfo.hasTitle ? buildComponent(context, appBarInfo.title, parentContext) : null,
        titleSpacing: appBarInfo.titleSpacing,
        titleTextStyle: textStyleFromStyle(appBarInfo.titleTextStyle),
        toolbarHeight: appBarInfo.toolbarHeight,
        toolbarOpacity: appBarInfo.toolbarOpacity,
        toolbarTextStyle: textStyleFromStyle(appBarInfo.toolbarTextStyle),
      );
    }

    if (component.isListTile) {
      JsonListTileInfo listTileInfo = component.info.listTileInfo;

      return ListTile(
        autofocus: listTileInfo.autofocus,
        contentPadding: edgeInsetsFromStyle(listTileInfo.contentPadding),
        dense: listTileInfo.dense,
        enableFeedback: listTileInfo.enableFeedback,
        enabled: listTileInfo.enabled,
        focusColor: themeColorFromString(listTileInfo.focusColor, context),
        horizontalTitleGap: listTileInfo.horizontalTitleGap,
        hoverColor: themeColorFromString(listTileInfo.hoverColor, context),
        iconColor: themeColorFromString(listTileInfo.iconColor, context),
        isThreeLine: listTileInfo.isThreeLine,
        leading: listTileInfo.hasLeading ? buildComponent(context, listTileInfo.leading, parentContext) : null,
        leadingAndTrailingTextStyle: textStyleFromStyle(listTileInfo.leadingAndTrailingTextStyle),
        minLeadingWidth: listTileInfo.minLeadingWidth,
        minTileHeight: listTileInfo.minTileHeight,
        minVerticalPadding: listTileInfo.minVerticalPadding,
        selected: listTileInfo.selected,
        selectedColor: themeColorFromString(listTileInfo.selectedColor, context),
        selectedTileColor: themeColorFromString(listTileInfo.selectedTileColor, context),
        // shape: shapeBorderFromString(listTileInfo.shape),
        splashColor: themeColorFromString(listTileInfo.splashColor, context),
        subtitle: listTileInfo.hasSubtitle ? buildComponent(context, listTileInfo.subtitle, parentContext) : null,
        subtitleTextStyle: textStyleFromStyle(listTileInfo.subtitleTextStyle),
        textColor: themeColorFromString(listTileInfo.textColor, context),
        tileColor: themeColorFromString(listTileInfo.tileColor, context),
        title: listTileInfo.hasTitle ? buildComponent(context, listTileInfo.title, parentContext) : null,
        titleAlignment: listTileTitleAlignmentFromString(listTileInfo.titleAlignment),
        style: listTileStyleFromString(listTileInfo.style),
        titleTextStyle: textStyleFromStyle(listTileInfo.titleTextStyle),
        trailing: listTileInfo.hasTrailing ? buildComponent(context, listTileInfo.trailing, parentContext) : null,
        visualDensity: visualDensityFromString(listTileInfo.visualDensity),
        onFocusChange: ActionBuilder.directFunctionWithArg(context, listTileInfo.onFocusChange, parentContext),
        onLongPress: ActionBuilder.directFunction(context, listTileInfo.onLongPress, parentContext),
        onTap: ActionBuilder.directFunction(context, listTileInfo.onTap, parentContext),
      );
    }

    if (component.isTabBar) {
      JsonTabBarInfo tabBarInfo = component.info.tabBarInfo;

      return TabBar(
        tabs: tabBarInfo.tabs.map((e) => buildComponent(context, e, parentContext)).toList(),
        automaticIndicatorColorAdjustment: tabBarInfo.automaticIndicatorColorAdjustment,
        dividerColor: themeColorFromString(tabBarInfo.dividerColor, context),
        dividerHeight: tabBarInfo.dividerHeight,
        dragStartBehavior: dragStartBehaviorFromString(tabBarInfo.dragStartBehavior) ?? DragStartBehavior.start,
        enableFeedback: tabBarInfo.enableFeedback,
        indicator: decorationFromStyle(tabBarInfo.indicator, context),
        indicatorColor: themeColorFromString(tabBarInfo.indicatorColor, context),
        indicatorPadding: edgeInsetsFromStyle(tabBarInfo.indicatorPadding) ?? EdgeInsets.zero,
        indicatorSize: tabBarIndicatorSizeFromString(tabBarInfo.indicatorSize),
        indicatorWeight: tabBarInfo.indicatorWeight,
        isScrollable: tabBarInfo.isScrollable,
        labelColor: themeColorFromString(tabBarInfo.labelColor, context),
        labelPadding: edgeInsetsFromStyle(tabBarInfo.labelPadding),
        labelStyle: textStyleFromStyle(tabBarInfo.labelStyle),
        padding: edgeInsetsFromStyle(tabBarInfo.padding),
        splashBorderRadius: borderRadiusFromStyle(tabBarInfo.splashBorderRadius),
        tabAlignment: tabAlignmentFromString(tabBarInfo.tabAlignment),
        unselectedLabelColor: themeColorFromString(tabBarInfo.unselectedLabelColor, context),
        unselectedLabelStyle: textStyleFromStyle(tabBarInfo.unselectedLabelStyle),
        onTap: ActionBuilder.directFunctionWithArg(context, tabBarInfo.onTap, parentContext),
      );
    }

    if (component.isFaIcon) {
      return faIconFromComponent(context, component);
    }
    
    if (component.isBuilder) {
      return Builder(
        builder: (context) => buildComponent(context, 
          component.info.builderInfo.component,
          parentContext
        )
      );
    }

    return Text("Unknown has no child component: ${component.type}");
  }

  Widget buildFieldComponentWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    JsonFieldInfo fieldInfo = component.info.fieldInfo;
    String? eType = entityType(context, component, parentContext);

    dynamic debug = "(${component.name}) -> entity: ${parentContext.entity?.entityType} -> parent: ${parentContext.parentEntity?.entityType}";

    if (eType == null) {
      return Text("No entity type for '$debug'");
    }

    if (fieldInfo.editable) {
      if (parentContext.formState == null) {
        return Text("No form state for '$debug'");
      }

      if (parentContext.entity == null && !fieldInfo.newEntity) {
        return Text("No entity for editable '$debug'");
      }

      if (fieldInfo.readOnly || component.name == 'id') {
        print("Building read only field '$debug'");

        return ReadOnlyComponentField(
          component: component,
          parentContext: parentContext,
        );
      }

      print("Building editable field '$debug'");

      return EditableComponentField(
        component: component,
        entity: parentContext.entity!,
        formState: parentContext.formState!,
      );
    }

    if (parentContext.entity is EspoEntity) {
      print("Building read only field based on entity '$debug'");

      return ReadOnlyComponentField(
        component: component,
        parentContext: parentContext,
      );
    }

    return Text("No entity for '$debug'");
  }

  Widget buildCustomComponentWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    JsonCustomInfo customInfo = component.info.customInfo;

    if ((context.espoState.metadata?.customComponents ?? {}).containsKey(customInfo.name)) {
      return buildComponent(context,
        JsonC(
          ArgumentParser.parseMapFormat(
            context,
            context.espoState.metadata?.customComponents[customInfo.name],
            parentContext,
            component.additionalData
          )
        ), parentContext);
    } else {
      return Text('Unknown custom component: ${customInfo.name}');
    }
  }
  
  Widget buildComponentWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    if (component.isSpecial) {
      return buildSpecialComponentWidget(context, component, parentContext);
    }

    if (component.isDetail) {
      return EspoPageComponentDetailBuilder(
        component: component,
        parentContext: parentContext,
      );
    }

    if (component.hasInnerComponent) {
      return buildInnerComponentWidget(context, component, parentContext);
    }

    if (component.hasInnerComponents) {
      return buildInnerComponentsWidget(context, component, parentContext);
    }

    if (component.isCustom) {
      return buildCustomComponentWidget(context, component, parentContext);
    }

    if (component.hasNoChild) {
      return buildHasNoChildComponentWidget(context, component, parentContext);
    }

    return Text('Unknown component type: ${component.type}');
  }

  Widget buildTranslatableField(BuildContext context, JsonC component, ParentContext parentContext) {
    String? transFieldEntityType = entityType(context, component, parentContext);
    
    if (parentContext.entity is EspoEntity) {
      transFieldEntityType = parentContext.entity!.entityType;
    }

    if (transFieldEntityType == null) {
      return Text("[transField] No entity type for ${component.name}");
    }

    String? fieldType = context.metadata.getFieldType(transFieldEntityType, component.name);

    if (fieldType == null) {
      return Text("[transField] No field type for ${component.name}");
    }

    dynamic value = parentContext.entity?.get(component.name);

    if (value == null) {
      return Text("[transField] No value for ${component.name}");
    }

    if (fieldType == EspoFieldType.Enum) {
      String? option = context.metadata.getI18nFieldOption(entityType(context, component, parentContext)!, component.name, value);

      if (option == null) {
        return Text("[transField] No option for ${component.name} value $value");
      }

      return textSimpleFromComponent(component, option, context);
    }

    return Text('[transField] Unsupported field type: $fieldType');
  }

  Widget buildComponent(BuildContext context, JsonC component, ParentContext parentContext) {
    Widget widget = buildComponentWidget(context, component, parentContext);
    widget = applyPadding(component, widget);

    return widget;
  }

  static Widget build(BuildContext context, JsonC component, ParentContext parentContext) {
    return CWBuilder(context).buildComponent(context, component, parentContext);
  }
}
