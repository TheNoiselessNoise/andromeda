import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoLinkParentField extends CoreBaseField<String, EspoLinkParentFieldState> {
  final Future<List<EspoEntity>> Function(String searchTerm) fetchItems;
  final String? initialEntityType;
  final List<EspoEntity>? items;

  const EspoLinkParentField({
    super.key,
    super.id,
    this.initialEntityType,
    super.initialValue,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required,
    super.readOnly,
    required this.fetchItems,
    this.items,
  });

  @override
  EspoLinkParentFieldState createState() => EspoLinkParentFieldState();
}

class EspoLinkParentFieldState extends CoreBaseFieldState<String> {
  List<EspoEntity> _items = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEntityType;
  EspoEntity? _selectedEntity;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    if ((widget as EspoLinkParentField).items != null) {
      _items = (widget as EspoLinkParentField).items!;
    } else {
      _loadItems('');
    }
    if (widget.initialValue != null) {
      setValue(widget.initialValue!);
    } else {
      setValue(null);
    }
    if ((widget as EspoLinkParentField).initialEntityType != null) {
      _selectedEntityType = (widget as EspoLinkParentField).initialEntityType;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _loadItems(_searchController.text);
  }

  Future<void> _loadItems(String searchTerm) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _items = await (widget as EspoLinkParentField).fetchItems(searchTerm);
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void setEntityType(dynamic value, CoreBaseFieldState fieldState) {
    setState(() {
      _selectedEntityType = value;
      _selectedEntity = null;
      setValue(null);
      if (value != null) {
        _loadItems('');
      }
    });
  }

  void setEntity(EspoEntity? entity) {
    setState(() {
      _selectedEntity = entity;
      setValue(entity?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> entityTypes = (widget as EspoLinkParentField).items?.map((e) => e.entityType).toSet().toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: EspoEnumField(
                id: "${widget.id}_entityType",
                items: entityTypes,
                initialValue: _selectedEntityType,
                onChanged: setEntityType,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedEntityType != null)
          if (_isLoading)
            const CircularProgressIndicator()
          else
            DropdownButtonFormField<EspoEntity>(
              value: _selectedEntity,
              items: _items
                  .where((item) => item.entityType == _selectedEntityType)
                  .map((item) => DropdownMenuItem<EspoEntity>(
                        value: item,
                        child: Text(item.get('name') ?? ''),
                      ))
                  .toList(),
              onChanged: (EspoEntity? newValue) {
                setEntity(newValue);
              },
              decoration: const InputDecoration(
                labelText: 'Select Entity',
              ),
            ),
      ],
    );
  }
}
