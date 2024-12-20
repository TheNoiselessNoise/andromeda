import 'package:flutter/material.dart';

class RichEditableText extends EditableText {
  final TextSpan Function(String) getHighlightedSpan;

  RichEditableText({
    super.key,
    required super.controller,
    required super.focusNode,
    required super.style,
    required super.cursorColor,
    required super.backgroundCursorColor,
    required this.getHighlightedSpan,
    required super.onChanged,
    super.maxLines = null,
  }) : super(
    textWidthBasis: TextWidthBasis.longestLine,
    textDirection: TextDirection.ltr,
    strutStyle: const StrutStyle(),
    enableSuggestions: false,
    autocorrect: false,
    selectionColor: Colors.blue.withOpacity(0.3),
    keyboardType: TextInputType.multiline,
    textAlign: TextAlign.left,
    rendererIgnoresPointer: false,
    paintCursorAboveText: true,
    smartDashesType: SmartDashesType.disabled,
    smartQuotesType: SmartQuotesType.disabled,
    enableInteractiveSelection: true,
    showSelectionHandles: true,
    showCursor: true,
    expands: true,
  );

  // EditableText(
  //   controller: _controller,
  //   focusNode: _focusNode,
  //   style: const TextStyle(
  //     fontFamily: 'monospace',
  //     fontSize: 14,
  //     color: Colors.white,
  //   ),
  //   cursorColor: Colors.white,
  //   backgroundCursorColor: Colors.grey,
  //   selectionColor: Colors.blue.withOpacity(0.3),
  //   keyboardType: TextInputType.multiline,
  //   textAlign: TextAlign.left,
  //   onChanged: (text) {
  //     _controller.updateSuggestions(text);
  //     widget.onChanged?.call(text);
  //   },
  //   rendererIgnoresPointer: false,
  //   paintCursorAboveText: true,
  //   maxLines: null,
  //   textDirection: TextDirection.ltr,
  //   strutStyle: const StrutStyle(),
  //   textWidthBasis: TextWidthBasis.parent,
  //   obscureText: false,
  //   autocorrect: false,
  //   smartDashesType: SmartDashesType.disabled,
  //   smartQuotesType: SmartQuotesType.disabled,
  //   enableSuggestions: false,
  //   enableInteractiveSelection: true,
  //   textScaler: MediaQuery.textScalerOf(context),
  //   showSelectionHandles: true,
  //   showCursor: true,
  // ),

  @override
  EditableTextState createState() => _RichEditableTextState();
}

class _RichEditableTextState extends EditableTextState {
  TextSpan Function(String) get getHighlightedSpan => 
      (widget as RichEditableText).getHighlightedSpan;

  @override
  TextSpan buildTextSpan() {
    return getHighlightedSpan(widget.controller.text);
  }
}