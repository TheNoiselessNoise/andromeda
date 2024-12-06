import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreMapField<K, V> extends CoreBaseFormField<Map<K, V>> {
  final String keyLabel;
  final String valueLabel;
  final K Function(String) parseKey;
  final V Function(String) parseValue;
  final String Function(K) formatKey;
  final String Function(V) formatValue;

  CoreMapField({
    super.key,
    required super.id,
    super.initialValue,
    this.keyLabel = 'Key',
    this.valueLabel = 'Value',
    K Function(String)? parseKey,
    V Function(String)? parseValue,
    String Function(K)? formatKey,
    String Function(V)? formatValue,
  }) : parseKey = parseKey ?? _defaultParser<K>(),
       parseValue = parseValue ?? _defaultParser<V>(),
       formatKey = formatKey ?? _defaultFormatter<K>(),
       formatValue = formatValue ?? _defaultFormatter<V>();

  static K Function(String) _defaultParser<K>() {
    return (String value) {
      if (K == String) {
        return value as K;
      }
      throw UnsupportedError("No default parser for type $K");
    };
  }

  static String Function(K) _defaultFormatter<K>() {
    return (K value) => value.toString();
  }

  @override
  CoreMapFieldState<K, V> createState() => CoreMapFieldState<K, V>();
}

class CoreMapFieldState<K, V> extends CoreBaseFormFieldState<CoreMapField<K, V>> {
  late final CoreFormFieldController<Map<K, V>> _controller;
  final Map<K, V> _currentMap = {};
  final List<MapEntry<TextEditingController, TextEditingController>> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<Map<K, V>>(
      id: widget.id,
      initialValue: widget.initialValue,
    );

    if (widget.initialValue != null) {
      _currentMap.addAll(widget.initialValue!);
      for (final entry in widget.initialValue!.entries) {
        _controllers.add(
          MapEntry(
            TextEditingController(text: widget.formatKey(entry.key)),
            TextEditingController(text: widget.formatValue(entry.value)),
          ),
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  void _addNewEntry() {
    setState(() {
      _controllers.add(
        MapEntry(
          TextEditingController(),
          TextEditingController(),
        ),
      );
    });
  }

  void _removeEntry(int index) {
    setState(() {
      final keyController = _controllers[index].key;
      final valueController = _controllers[index].value;

      try {
        final key = widget.parseKey(keyController.text);
        _currentMap.remove(key);
      } catch (e) {
        // Ignore
      }

      _controllers.removeAt(index);
      keyController.dispose();
      valueController.dispose();

      _updateFormValue();
    });
  }

  void _updateFormValue() {
    _controller.setValue(Map<K, V>.from(_currentMap));
    formScope.controller.updateValue(widget.id, _currentMap);
  }

  void _handleKeyValueChange(int index) {
    try {
      final keyController = _controllers[index].key;
      final valueController = _controllers[index].value;

      final K key = widget.parseKey(keyController.text);
      final V value = widget.parseValue(valueController.text);

      setState(() {
        _currentMap[key] = value;
        _updateFormValue();
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  void dispose() {
    for (final controllers in _controllers) {
      controllers.key.dispose();
      controllers.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Map Field: ${widget.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewEntry,
                  tooltip: 'Add new entry',
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ..._controllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controllers = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllers.key,
                        decoration: InputDecoration(
                          labelText: widget.keyLabel,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => _handleKeyValueChange(index),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: controllers.value,
                        decoration: InputDecoration(
                          labelText: widget.valueLabel,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => _handleKeyValueChange(index),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeEntry(index),
                      tooltip: 'Remove entry',
                    ),
                  ],
                ),
              );
            }),
          ],
        )
      )
    );
  }
}