import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoLinkField extends CoreBaseField<String, EspoLinkFieldState> {
  final String entityType;
  final Future<List<EspoEntity>> Function(String searchTerm) fetchItems;
  final List<EspoEntity>? items;

  const EspoLinkField({
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
    required this.entityType,
    required this.fetchItems,
    this.items,
  });

  @override
  EspoLinkFieldState createState() => EspoLinkFieldState();
}

class EspoLinkFieldState extends CoreBaseFieldState<String> {
  List<EspoEntity> _items = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    if ((widget as EspoLinkField).items != null) {
      _items = (widget as EspoLinkField).items!;
    } else {
      _loadItems('');
    }
    if (widget.initialValue != null) {
      setValue(widget.initialValue!);
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
      _items = await (widget as EspoLinkField).fetchItems(searchTerm);
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
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 8),
        if (_isLoading)
          const CircularProgressIndicator()
        else
          DropdownButtonFormField<String>(
            value: _items.any((item) => item.id == value) ? value : null,
            onChanged: (String? newValue) {
              setValue(newValue);
            },
            items: _items.map<DropdownMenuItem<String>>((EspoEntity item) {
              return DropdownMenuItem<String>(
                value: item.id,
                child: Text(item.get('name') ?? ''),
              );
            }).toList(),
            decoration: widget.buildInputDecoration(),
            style: widget.options?.textStyle,
          ),
      ],
    );
  }
}
