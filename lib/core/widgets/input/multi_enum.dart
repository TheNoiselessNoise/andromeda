import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreMultiEnumFieldDisplayMode {
  static const String chips = 'chips';
  static const String string = 'string';
}

class CoreMultiEnumField<T> extends CoreBaseFormField<List<T>> {
  final List<T> options;
  final String Function(T) labelBuilder;
  final String? placeholder;
  final bool enableSearch;
  final String displayMode;

  CoreMultiEnumField({
    super.key,
    required super.id,
    super.initialValue,
    required this.options,
    String Function(T)? labelBuilder,
    this.placeholder,
    this.enableSearch = true,
    this.displayMode = CoreMultiEnumFieldDisplayMode.string,
  }) : labelBuilder = labelBuilder ?? ((T value) => value.toString());

  @override
  CoreMultiEnumFieldState<T> createState() => CoreMultiEnumFieldState<T>();
}

class CoreMultiEnumFieldState<T> extends CoreBaseFormFieldState<CoreMultiEnumField<T>> {
  late final CoreFormFieldController<List<T>> _controller;
  final LayerLink _layerLink = LayerLink();
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<List<T>>(
      id: widget.id,
      initialValue: widget.initialValue ?? [],
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

  void _removeValue(T value) {
    final currentValues = List<T>.from(_controller.value ?? []);
    currentValues.remove(value);
    _controller.setValue(currentValues);
    formScope.controller.updateValue(widget.id, currentValues);
    setState(() {});
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

  void _toggleOption(T value) {
    final currentValues = List<T>.from(_controller.value ?? []);
    if (currentValues.contains(value)) {
      currentValues.remove(value);
    } else {
      currentValues.add(value);
    }
    _controller.setValue(currentValues);
    formScope.controller.updateValue(widget.id, currentValues);
    _overlayEntry?.markNeedsBuild();
    setState(() {});
  }

  List<T> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;
    return widget.options.where((option) {
      final label = widget.labelBuilder(option).toLowerCase();
      return label.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildChipsDisplay() {
    final values = _controller.value ?? [];
    if (values.isEmpty) {
      return Text(
        widget.placeholder ?? 'Select options',
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: values.map((value) {
        return Chip(
          label: Text(widget.labelBuilder(value)),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () => _removeValue(value),
        );
      }).toList(),
    );
  }

  Widget _buildStringDisplay() {
    final values = _controller.value ?? [];
    if (values.isEmpty) {
      return Text(
        widget.placeholder ?? 'Select options',
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    }

    return Text(values.map(widget.labelBuilder).join(', '));
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
                  if (widget.enableSearch) Padding(
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
                        final isSelected = (_controller.value ?? []).contains(option);
                        return ListTile(
                          dense: true,
                          selected: isSelected,
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleOption(option),
                          ),
                          title: Text(widget.labelBuilder(option)),
                          onTap: () => _toggleOption(option),
                        );
                      },
                    ),
                  ),
                  OverflowBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          _hideOverlay();
                          _focusNode.unfocus();
                          setState(() {});
                        },
                        child: const Text('Done'),
                      ),
                    ],
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
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          _focusNode.requestFocus();
          if (!_isOpen) {
            _showOverlay();
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((_controller.value ?? []).isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.setValue([]);
                      formScope.controller.updateValue(widget.id, []);
                      setState(() {});
                    },
                  ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          child: widget.displayMode == CoreMultiEnumFieldDisplayMode.chips
              ? _buildChipsDisplay()
              : _buildStringDisplay(),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return CompositedTransformTarget(
  //     link: _layerLink,
  //     child: TextFormField(
  //       focusNode: _focusNode,
  //       controller: TextEditingController(
  //         text: (_controller.value ?? []).isEmpty
  //             ? ''
  //             : (_controller.value ?? [])
  //                 .map(widget.labelBuilder)
  //                 .join(', '),
  //       ),
  //       readOnly: true,
  //       decoration: InputDecoration(
  //         hintText: widget.placeholder ?? 'Select options',
  //         suffixIcon: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             if ((_controller.value ?? []).isNotEmpty)
  //               IconButton(
  //                 icon: const Icon(Icons.clear),
  //                 onPressed: () {
  //                   _controller.setValue([]);
  //                   formScope.controller.updateValue(widget.id, []);
  //                   _overlayEntry?.markNeedsBuild();
  //                 },
  //               ),
  //             const Icon(Icons.arrow_drop_down),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}