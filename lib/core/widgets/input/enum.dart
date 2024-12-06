import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreEnumField<T> extends CoreBaseFormField<T> {
  final List<T> options;
  final String Function(T) labelBuilder;
  final String? placeholder;
  final bool? enableSearch;

  CoreEnumField({
    super.key,
    required super.id,
    super.initialValue,
    required this.options,
    String Function(T)? labelBuilder,
    this.placeholder,
    this.enableSearch,
  }) : labelBuilder = labelBuilder ?? ((T value) => value.toString());

  @override
  CoreEnumFieldState<T> createState() => CoreEnumFieldState<T>();
}

class CoreEnumFieldState<T> extends CoreBaseFormFieldState<CoreEnumField<T>> {
  late final CoreFormFieldController<T> _controller;
  final LayerLink _layerLink = LayerLink();
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  String _searchQuery = '';

  bool get enableSearch => widget.enableSearch ?? false;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<T>(
      id: widget.id,
      initialValue: widget.initialValue,
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_isOpen) {
        _showOverlay();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    _searchQuery = '';
    _searchController.clear();
  }

  void _selectOption(T? value) {
    setState(() {
      _controller.setValue(value);
      formScope.controller.updateValue(widget.id, value);
      _hideOverlay();
    });
    
    _focusNode.unfocus();
  }

  List<T> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;
    return widget.options.where((option) {
      final label = widget.labelBuilder(option).toLowerCase();
      return label.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 300,
                minWidth: size.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (enableSearch) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                        _overlayEntry?.markNeedsBuild();
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      itemCount: _filteredOptions.length,
                      itemBuilder: (context, index) {
                        final option = _filteredOptions[index];
                        final isSelected = _controller.value == option;
                        return ListTile(
                          dense: true,
                          selected: isSelected,
                          title: Text(widget.labelBuilder(option)),
                          onTap: () => _selectOption(option),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = _controller.value != null
        ? widget.labelBuilder(_controller.value as T)
        : widget.placeholder ?? 'Select an option';

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _focusNode,
        controller: TextEditingController(text: displayText),
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.value != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _selectOption(null),
                ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}