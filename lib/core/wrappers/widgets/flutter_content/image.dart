import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class AndromedaImageProps extends MapTraversable {
  const AndromedaImageProps(super.data);

  String? get asset => get('asset');
  String? get file => get('file');

  String? get url => get('url');
  Map<String, String>? get headers => getMap('headers');

  String? get base64 => get('base64');
  
  bool get isAsset => asset != null;
  bool get isFile => file != null;
  bool get isUrl => url != null;
  bool get isBase64 => base64 != null;
}

class AndromedaImageStyles extends ContextableMapTraversable {
  const AndromedaImageStyles(super.context, super.data);

  AlignmentGeometry get alignment => alignmentGeometryFromString(get('alignment')) ?? Alignment.center;
  BlendMode? get colorBlendMode => blendModeFromString(get('colorBlendMode'));
  FilterQuality get filterQuality => filterQualityFromString(get('filterQuality')) ?? FilterQuality.medium;
  AndromedaStyleRect get centerSlice => AndromedaStyleRect(getMap('centerSlice'));
  BoxFit? get fit => boxFitFromString(get('fit'));
  Color? get color => themeColorFromString(get('color'), context);
  double? get width => get('width');
  double? get height => get('height');
  bool get isAntiAlias => getBool('isAntiAlias', false);
  ImageRepeat get repeat => imageRepeatFromString(get('repeat')) ?? ImageRepeat.noRepeat;
  Animation<double>? get opacity => has('opacity') ? AlwaysStoppedAnimation(get('opacity')) : null;
  double? get scale => get('scale');
  int? get cacheWidth => get('cacheWidth');
  int? get cacheHeight => get('cacheHeight');
  bool get gaplessPlayback => getBool('gaplessPlayback', false);
  bool get matchTextDirection => getBool('matchTextDirection', false);
}

class AndromedaImageWidget extends AndromedaWidget {
  static const String id = 'Image';

  AndromedaImageWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaImageWidgetState createState() => AndromedaImageWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaImageProps(ctx.props);
    final style = AndromedaImageStyles(ctx.context, ctx.styles);

    if (prop.isAsset) {
      return Image.asset(
        prop.asset!,
        alignment: style.alignment,
        filterQuality: style.filterQuality,
        colorBlendMode: style.colorBlendMode,
        scale: style.scale,
        centerSlice: rectFromStyle(style.centerSlice),
        fit: style.fit,
        color: style.color,
        width: style.width,
        height: style.height,
        isAntiAlias: style.isAntiAlias,
        repeat: style.repeat,
        opacity: style.opacity,
        cacheHeight: style.cacheHeight,
        cacheWidth: style.cacheWidth,
        gaplessPlayback: style.gaplessPlayback,
        matchTextDirection: style.matchTextDirection,
        // (BuildContext, Object, StackTrace?)
        // (context,      error,  stackTrace) => Widget
        errorBuilder: ctx.prepareHandler('errorBuilder', 3),
        // (BuildContext, Widget,  int?,   bool)
        // (context,      child,   frame,  wasSynchronouslyLoaded) => Widget
        frameBuilder: ctx.prepareHandler('frameBuilder', 4),
        // TODO: bundle: AssetBundle?
      );
    }

    if (prop.isFile) {
      return Image.file(
        File(prop.file!),
        alignment: style.alignment,
        filterQuality: style.filterQuality,
        scale: style.scale ?? 1.0,
        centerSlice: rectFromStyle(style.centerSlice),
        colorBlendMode: style.colorBlendMode,
        fit: style.fit,
        color: style.color,
        width: style.width,
        height: style.height,
        isAntiAlias: style.isAntiAlias,
        repeat: style.repeat,
        opacity: style.opacity,
        cacheHeight: style.cacheHeight,
        cacheWidth: style.cacheWidth,
        gaplessPlayback: style.gaplessPlayback,
        matchTextDirection: style.matchTextDirection,
        // (BuildContext, Object, StackTrace?)
        // (context,      error,  stackTrace) => Widget
        errorBuilder: ctx.prepareHandler('errorBuilder', 3),
        // (BuildContext, Widget,  int?,   bool)
        // (context,      child,   frame,  wasSynchronouslyLoaded) => Widget
        frameBuilder: ctx.prepareHandler('frameBuilder', 4),
      );
    }

    if (prop.isUrl) {
      return Image.network(
        prop.url!,
        alignment: style.alignment,
        filterQuality: style.filterQuality,
        scale: style.scale ?? 1.0,
        centerSlice: rectFromStyle(style.centerSlice),
        colorBlendMode: style.colorBlendMode,
        fit: style.fit,
        color: style.color,
        width: style.width,
        height: style.height,
        isAntiAlias: style.isAntiAlias,
        repeat: style.repeat,
        opacity: style.opacity,
        cacheHeight: style.cacheHeight,
        cacheWidth: style.cacheWidth,
        gaplessPlayback: style.gaplessPlayback,
        matchTextDirection: style.matchTextDirection,
        headers: prop.headers,
        // (BuildContext, Object, StackTrace?)
        // (context,      error,  stackTrace) => Widget
        errorBuilder: ctx.prepareHandler('errorBuilder', 3),
        // (BuildContext, Widget,  int?,   bool)
        // (context,      child,   frame,  wasSynchronouslyLoaded) => Widget
        frameBuilder: ctx.prepareHandler('frameBuilder', 4),
        // (BuildContext, Widget,  ImageChunkEvent?)
        // (context,      child,   loadingProgress) => Widget
        loadingBuilder: ctx.prepareHandler('loadingBuilder', 3),
        // TODO: wrap ImageChunkEvent to be use it within Andromeda
        // loadingBuilder: (context, child, loadingProgress) {
        //   if (loadingProgress == null) return child;
        //   return Center(
        //     child: CircularProgressIndicator(
        //       value: loadingProgress.expectedTotalBytes != null
        //         ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
        //         : null,
        //     ),
        //   );
        // },
      );
    }

    if (prop.isBase64) {
      return Image.memory(
        base64Decode(prop.base64!),
        alignment: style.alignment,
        filterQuality: style.filterQuality,
        scale: style.scale ?? 1.0,
        centerSlice: rectFromStyle(style.centerSlice),
        colorBlendMode: style.colorBlendMode,
        fit: style.fit,
        color: style.color,
        width: style.width,
        height: style.height,
        isAntiAlias: style.isAntiAlias,
        repeat: style.repeat,
        opacity: style.opacity,
        cacheHeight: style.cacheHeight,
        cacheWidth: style.cacheWidth,
        gaplessPlayback: style.gaplessPlayback,
        matchTextDirection: style.matchTextDirection,
        // (BuildContext, Object, StackTrace?)
        // (context,      error,  stackTrace) => Widget
        errorBuilder: ctx.prepareHandler('errorBuilder', 3),
        // (BuildContext, Widget,  int?,   bool)
        // (context,      child,   frame,  wasSynchronouslyLoaded) => Widget
        frameBuilder: ctx.prepareHandler('frameBuilder', 4),
      );
    }

    return const Icon(Icons.question_mark);
  }
}

class AndromedaImageWidgetState extends AndromedaWidgetState<AndromedaImageWidget> {}