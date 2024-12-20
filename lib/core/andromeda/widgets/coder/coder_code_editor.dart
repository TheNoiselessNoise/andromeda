import 'package:flutter/material.dart';
import 'coder_rich_editable.dart';

class CodeHighlighter {
  static TextSpan getHighlightedSpan(String text, TextStyle style) {
    final keywords = RegExp(
      r'\b(if|else|for|foreach|fn|class)\b',
      caseSensitive: true,
    );

    // Define regex patterns for different elements
    final widgets = RegExp(
      r'\b(Text|Container|Row|Column|Button|Image)\s*{',
      caseSensitive: true,
    );
    
    // Match numbers (including decimals) and booleans
    final literalValues = RegExp(
      r'\b(true|false|\d+\.?\d*)\b',
      caseSensitive: true,
    );
    
    // Match variables in the format $variableName
    final variables = RegExp(r'\$[a-zA-Z_][a-zA-Z0-9_]*');
    
    // Match strings in quotes
    final strings = RegExp(r'"[^"]*"');

    // Comments start with '//'
    final comments = RegExp(r'//.*');

    // '#<functionName>'
    final builtinFunctions = RegExp(r'#\w+');
    
    List<TextSpan> spans = [];
    String remaining = text;
    
    while (remaining.isNotEmpty) {
      if (remaining.startsWith(keywords)) {
        final match = keywords.firstMatch(remaining)!;
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.orange),
        ));
        remaining = remaining.substring(match.end);
      } else if (remaining.startsWith(widgets)) {
        final match = widgets.firstMatch(remaining)!;
        // Get just the widget name without the '{'
        final widgetName = match.group(1);
        spans.add(TextSpan(
          text: widgetName,
          style: const TextStyle(color: Colors.pink),
        ));
        // Add the '{' with default color
        spans.add(TextSpan(
          text: remaining.substring(widgetName!.length, match.end),
        ));
        remaining = remaining.substring(match.end);
      } else if (remaining.startsWith(literalValues)) {
        final match = literalValues.firstMatch(remaining)!;
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.blue),
        ));
        remaining = remaining.substring(match.end);
      } else if (remaining.startsWith(variables)) {
        final match = variables.firstMatch(remaining)!;
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.yellow),
        ));
        remaining = remaining.substring(match.end);
      } else if (remaining.startsWith(strings)) {
        final match = strings.firstMatch(remaining)!;
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.green),
        ));
        remaining = remaining.substring(match.end);
      } else if (remaining.startsWith(comments)) {
        final match = comments.firstMatch(remaining)!;
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.grey),
        ));
        remaining = remaining.substring(match.end);
      } else if (remaining.startsWith(builtinFunctions)) {
        final match = builtinFunctions.firstMatch(remaining)!;
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.purple),
        ));
        remaining = remaining.substring(match.end);
      } else {
        spans.add(TextSpan(
          text: remaining[0],
          style: const TextStyle(color: Colors.white),
        ));
        remaining = remaining.substring(1);
      }
    }
    
    return TextSpan(
      children: spans,
      style: style
    );
  }
}

class CodeEditingController extends TextEditingController {
  List<String> suggestions = [];
  final VoidCallback onSuggestionsChanged;

  CodeEditingController({required this.onSuggestionsChanged});

  void updateSuggestions(String text) {
    // Get cursor position and current word
    final cursorPos = selection.baseOffset;
    if (cursorPos < 0) return;

    final textBeforeCursor = text.substring(0, cursorPos);
    final lastWord = textBeforeCursor.split(RegExp(r'[\s\n]')).last;

    // Update suggestions based on current word
    if (lastWord.isNotEmpty) {
      suggestions = _getSuggestions(lastWord);
      onSuggestionsChanged();
    } else {
      suggestions = [];
      onSuggestionsChanged();
    }
  }

  List<String> _getSuggestions(String word) {
    // Example suggestions - extend this based on your DSL
    final allSuggestions = [
      'widget',
      'container',
      'row',
      'column',
      'text',
      'button',
      'image',
      'padding',
      'margin',
      'color',
      'size',
    ];

    return allSuggestions
        .where((suggestion) =>
            suggestion.toLowerCase().startsWith(word.toLowerCase()))
        .toList();
  }

  void applySuggestion(String suggestion) {
    final cursorPos = selection.baseOffset;
    if (cursorPos < 0) return;

    final textBeforeCursor = text.substring(0, cursorPos);
    final textAfterCursor = text.substring(cursorPos);
    
    // Find the start of the current word
    final lastSpaceIndex = textBeforeCursor.lastIndexOf(RegExp(r'[\s\n]'));
    final startOfWord = lastSpaceIndex + 1;
    
    // Replace current word with suggestion
    final newText = textBeforeCursor.substring(0, startOfWord) +
        suggestion +
        textAfterCursor;
    
    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: startOfWord + suggestion.length,
      ),
    );

    // Clear suggestions after applying
    suggestions = [];
    onSuggestionsChanged();
  }
}

class CodeEditor extends StatefulWidget {
  final String initialCode;
  final void Function(String)? onChanged;
  final TextStyle style;

  const CodeEditor({
    super.key,
    this.initialCode = '',
    this.onChanged,
    required this.style
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late CodeEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _lineNumberScrollController = ScrollController();
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = CodeEditingController(
      onSuggestionsChanged: () {
        setState(() {});
      },
    )..text = widget.initialCode;
    _updateLineCount();

    _editorScrollController.addListener(_syncScroll);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _editorScrollController.removeListener(_syncScroll);
    _editorScrollController.dispose();
    _horizontalScrollController.dispose();
    _lineNumberScrollController.dispose();
    super.dispose();
  }

  void _syncScroll() {
    _lineNumberScrollController.jumpTo(_editorScrollController.offset);
  }

  void _updateLineCount() {
    setState(() {
      _lineCount = '\n'.allMatches(_controller.text).length + 1;
    });
  }

  Widget _buildLineNumbers() {
    return SizedBox(
      width: 48,
      child: ListView.builder(
        controller: _lineNumberScrollController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _lineCount,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 16,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[900],
                  child: _buildLineNumbers(),
                ),
                Container(
                  width: 1,
                  color: Colors.grey[700],
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _editorScrollController,
                    thumbVisibility: true,
                    child: Scrollbar(
                      controller: _horizontalScrollController,
                      thumbVisibility: true,
                      notificationPredicate: (notification) => notification.depth == 1,
                      child: SingleChildScrollView(
                        controller: _editorScrollController,
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicWidth(
                            child: RichEditableText(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: widget.style,
                              maxLines: null,
                              cursorColor: Colors.white,
                              backgroundCursorColor: Colors.white,
                              getHighlightedSpan: (code) => 
                                  CodeHighlighter.getHighlightedSpan(code, widget.style),
                              onChanged: (text) {
                                _controller.updateSuggestions(text);
                                _updateLineCount();
                                widget.onChanged?.call(text);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_controller.suggestions.isNotEmpty)
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _controller.suggestions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label: Text(suggestion),
                    onPressed: () {
                      _controller.applySuggestion(suggestion);
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}