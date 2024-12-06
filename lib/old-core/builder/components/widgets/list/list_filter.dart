import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ListFilterWidget extends CoreBaseStatefulWidget {
  final String entityType;
  final String field;
  final String fieldType;
  final List<String> searchRanges;
  final CoreBaseFormState formState;
  final EspoPageComponentListBuilderState listState;

  const ListFilterWidget({super.key,
    required this.entityType,
    required this.field,
    required this.fieldType,
    required this.searchRanges,
    required this.formState,
    required this.listState
  });

  @override
  ListFilterWidgetState createState() => ListFilterWidgetState();
}

class ListFilterWidgetState extends CoreBaseState<ListFilterWidget> {
  @override
  bool isComponent() => true;

  @override
  bool useBlocWrapper() => false;

  String get entityType => widget.entityType;
  String get field => widget.field;
  String get fieldType => widget.fieldType;
  List<String> get searchRanges => widget.searchRanges;
  CoreBaseFormState get formState => widget.formState;
  EspoPageComponentListBuilderState get listState => widget.listState;

  String? currentRange;
  List<dynamic>? currentValue;

  @override
  void initState() {
    super.initState();
    currentRange = searchRanges.first;

    if (listState.currentFilterValues[field]?.isNotEmpty ?? false) {
      currentRange = listState.currentFilterValues[field]!.keys.first;
      currentValue = listState.currentFilterValues[field]![currentRange!] ?? [];
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        buildFilterRangeWidget(context),
        ...buildFilterValueWidget(context),
      ],
    );
  }

  Widget buildFilterRangeWidget(BuildContext context) {
    return EspoEnumField(
      id: "${field}_range",
      options: const CoreFieldOptions(
        hintText: '...',
        border: OutlineInputBorder(),
      ),
      initialValue: listState.currentFilterValues[field]?.keys.first,
      mapItems: searchRanges.asMap().map((key, value) {
        return MapEntry(
          value,
          Translator.searchRange(context, fieldType, value),
        );
      }),
      onChanged: (value, fieldState) async {
        setState(() {
          listState.unsetListFilter(field);

          currentRange = value.toString();

          listState.setSettingsAndRequest(() {
            listState.setListFilterValue(field, currentRange!, null);
          });
        });
      },
    );
  }

  List<Widget> buildFilterDateTimeWidget(BuildContext context) {
    bool hasIntInput = [
      SearchRangeType.lastXDays,
      SearchRangeType.nextXDays,
      SearchRangeType.olderThanXDays,
      SearchRangeType.afterXDays,
    ].contains(currentRange);

    if (hasIntInput) {
      return [
        EspoIntField(
          id: field,
          options: const CoreFieldOptions(
            hintText: '...',
            border: OutlineInputBorder(),
          ),
          initialValue: currentValue?[0],
          onChanged: (value, fieldState) async {
            listState.setSettingsAndRequest(() {
              listState.setListFilterValue(field, currentRange!, value);
            });
          },
        ),
      ];
    }

    bool hasDateInput = [
      SearchRangeType.on,
      SearchRangeType.before,
      SearchRangeType.after,
    ].contains(currentRange);

    if (hasDateInput) {
      return [
        EspoDateField(
          id: field,
          options: const CoreFieldOptions(
            hintText: '...',
            border: OutlineInputBorder(),
          ),
          initialValue: currentValue?[0],
          onChanged: (value, fieldState) async {
            listState.setSettingsAndRequest(() {
              listState.setListFilterValue(field, currentRange!, value);
            });
          },
        ),
      ];
    }

    if (currentRange == SearchRangeType.between) {
      String? dateFromString = currentValue?[0];
      DateTime? dateFrom = dateFromString == null ? null : DateTime.tryParse(dateFromString);

      String? dateToString = currentValue?[1];
      DateTime? dateTo = dateToString == null ? null : DateTime.tryParse(dateToString);

      return [
        EspoDateTimeField(
          id: "${field}_from",
          options: const CoreFieldOptions(
            hintText: '...',
            border: OutlineInputBorder(),
          ),
          initialValue: dateFrom,
          onChanged: (value, fieldState) async {
            listState.setSettingsAndRequest(() {
              listState.setListFilterValueAt(field, currentRange!, value, 0);
            });
          },
        ),

        EspoDateTimeField(
          id: "${field}_to",
          options: const CoreFieldOptions(
            hintText: '...',
            border: OutlineInputBorder(),
          ),
          initialValue: dateTo,
          onChanged: (value, fieldState) async {
            listState.setSettingsAndRequest(() {
              listState.setListFilterValueAt(field, currentRange!, value, 1);
            });
          },
        ),
      ];
    }

    return [ Text('Unknown datetime range type: $currentRange') ];
  }

  List<Widget> buildFilterVarcharWidget(BuildContext context) {
    if (!listState.filterControllers.containsKey(field)) {
      listState.filterControllers[field] = CoreEditingController<String>(
        initialValue: currentValue?[0],
      );
    }

    return [
      EspoVarcharField(
        id: field,
        controller: listState.filterControllers[field] as CoreEditingController<String>?,
        options: const CoreFieldOptions(
          hintText: '...',
          border: OutlineInputBorder(),
        ),
        initialValue: currentValue?[0],
        onChanged: (value, fieldState) async {
          listState.setSettingsAndRequest(() {
            listState.setListFilterValue(field, currentRange!, value);
          });
        },
      ),
    ];
  }

  List<Widget> buildFilterEnumWidget(BuildContext context) {
    if (!listState.filterControllers.containsKey(field)) {
      listState.filterControllers[field] = MultiSelectController<String>();
    }

    List<String> enumValues = context.metadata.getEnumStringOptions(entityType, field);
    List<dynamic> values = listState.currentFilterValues[field]?[currentRange] ?? [];
    List<String> selectedOptions = values.map((e) => e.toString()).toList();
    Map<String, String> options = enumValues.asMap().map((key, value) {
      return MapEntry(
        value,
        Translator.fieldOption(context, entityType, field, value),
      );
    });

    return [
      MultiSelectDropDownField<String>(
        msController: listState.filterControllers[field] as MultiSelectController<String>?,
        id: field,
        selectOptions: options,
        selectedOptions: selectedOptions,
        onChanged: (value, fieldState) {
          if (value == null) {
            (listState.filterControllers[field] as MultiSelectController<String>?)?.clearAllSelection(); 
          }

          listState.setSettingsAndRequest(() {
            listState.setListFilterValue(field, currentRange!, value);
          });
        },
      )
    ];
  }


  List<Widget> buildFilterValueWidget(BuildContext context) {
    if (!SearchRanges.hasInputs(currentRange!)) return [];

    if (fieldType == EspoFieldType.Varchar) {
      return buildFilterVarcharWidget(context);
    }

    if (fieldType == EspoFieldType.Enum) {
      return buildFilterEnumWidget(context);
    }

    if (fieldType == EspoFieldType.DateTime) {
      return buildFilterDateTimeWidget(context);
    }

    return [
      Text('Unknown field type: $fieldType'),
    ];
  }
}
