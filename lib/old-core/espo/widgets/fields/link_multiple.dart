import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoLinkMultipleField extends CoreBaseField<List<String>, EspoLinkMultipleFieldState> {
  final Future<List<EspoEntity>> Function(String searchTerm) fetchItems;
  final List<EspoEntity>? items;
  final bool isMultiple;
  final VoidCallback? onCreateNew;

  const EspoLinkMultipleField({
    super.key,
    super.id,
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
    this.isMultiple = true,
    this.onCreateNew,
  });

  @override
  EspoLinkMultipleFieldState createState() => EspoLinkMultipleFieldState();
}

class EspoLinkMultipleFieldState extends CoreBaseFieldState<List<String>> {
  List<EspoEntity> _items = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    if ((widget as EspoLinkMultipleField).items != null) {
      _items = (widget as EspoLinkMultipleField).items!;
    } else {
      _loadItems('');
    }
    if (widget.initialValue != null) {
      setValue(widget.initialValue!);
    } else {
      setValue([]);
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
      _items = await (widget as EspoLinkMultipleField).fetchItems(searchTerm);
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            if ((widget as EspoLinkMultipleField).onCreateNew != null)
              ElevatedButton(
                onPressed: (widget as EspoLinkMultipleField).onCreateNew,
                child: const Text('Create New'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isLoading)
          const CircularProgressIndicator()
        else
          Wrap(
            spacing: 8,
            children: _items.map((item) {
              final isSelected = value?.contains(item.id) ?? false;
              return FilterChip(
                label: Text(item.get('name') ?? ''),
                selected: isSelected,
                onSelected: (widget as EspoLinkMultipleField).isMultiple || !isSelected
                    ? (bool selected) {
                        setState(() {
                          if (selected) {
                            if (!(widget as EspoLinkMultipleField).isMultiple) {
                              value?.clear();
                            }
                            value?.add(item.id);
                          } else {
                            value?.remove(item.id);
                          }
                          setValue(List.from(value ?? []));
                        });
                      }
                    : null,
              );
            }).toList(),
          ),
      ],
    );
  }
}
