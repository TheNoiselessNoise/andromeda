import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoChangesBottomSheet extends CoreBaseStatefulWidget {
  const EspoChangesBottomSheet({super.key});

  @override
  EspoChangesBottomSheetState createState() => EspoChangesBottomSheetState();
}

class EspoChangesBottomSheetState extends CoreBaseState<EspoChangesBottomSheet> {
  @override
  bool isComponent() => true;

  Map<String, List<EspoEntityChange>> getSortedEntityChanges([
    EspoEntityChangeType? type
  ]) {
    Map<String, List<EspoEntityChange>> sortedChanges = {};

    for (EspoEntityChange change in espoState.entityChanges?.values ?? {}) {
      if (change.isCreate && type != EspoEntityChangeType.create) continue;
      if (change.isUpdate && type != EspoEntityChangeType.update) continue;
      if (change.isDelete && type != EspoEntityChangeType.delete) continue;

      EspoEntity entity = change.entity;
      if (sortedChanges[entity.entityType] == null) {
        sortedChanges[entity.entityType] = [];
      }
      sortedChanges[entity.entityType]!.add(change);
    }

    return sortedChanges;
  }

  List<Widget> buildEntityFieldChangeInformationListItems(EspoEntityChange change, EspoEntity entity, [Map<String, dynamic> dataChanges = const {}]) {
    List<Widget> widgets = [];

    for (String field in dataChanges.keys) {
      final originalValue = entity.data[field]?.toString() ?? "null";
      final changedValue = dataChanges[field]?.toString() ?? "null";

      String? espoType = metadata.getFieldType(entity.entityType, field);
      // String dartType = entity.get(field).runtimeType.toString();
      String fieldName = metadata.getI18nField(entity.entityType, field);
      
      if (field == 'id') espoType = 'varchar';
      espoType ??= "?";

      widgets.add(Card(
        child: ListTile(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fieldName).bold(),
              // Text(" $dartType => $espoType"),
            ],
          ),
          subtitle: Column(
            children: [
              if (change.isCreate && originalValue == changedValue)
                Text(changedValue)
              else ...[
                Text(originalValue),
                const Icon(Icons.arrow_downward),
                Text(changedValue),
              ],
            ],
          ),
        ),
      ));
    }
    return widgets;
  }

  List<Widget> buildEntityFieldChangesList(List<EspoEntityChange> changes) {
    List<Widget> widgets = [];

    for (EspoEntityChange change in changes) {
      EspoEntity entity = change.entity;
      Map<String, dynamic> dataChanges = change.changeData;

      widgets.add(
        Card(
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            title: Text(entity.id).bold(),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(change.changedAt.stringDateTime()).bold(),
                Text(dataChanges.length == 1
                  ? "1 change"
                  : "${dataChanges.length} changes")
              ],
            ),
            // trailing: IconButton(
            //   icon: Icon(Icons.delete),
            //   onPressed: () {
            //   },
            // ),
            children: [
              Column(
                children: buildEntityFieldChangeInformationListItems(change, entity, dataChanges)
              )
            ],
          ),
        )
      );
    }

    return widgets;
  }
    
  Widget buildEntityChangesItemList(String entityType, List<EspoEntityChange> changes) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      title: Text("$entityType (${changes.length})").bold(),
      children: buildEntityFieldChangesList(changes),
    );
  }

  Widget buildSection(EspoEntityChangeType type) {
    Map<String, List<EspoEntityChange>> sortedChanges = getSortedEntityChanges(type);

    if (sortedChanges.isEmpty) return noChangesWidget(context);

    return Column(
      children: [
        for (String changeId in sortedChanges.keys)
          Card(
            child: buildEntityChangesItemList(changeId, sortedChanges[changeId]!),
          ),
      ],
    );
  }

  Widget noChangesWidget(BuildContext context, [String message = "No changes"]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(message),
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    if ((espoState.entities ?? {}).isEmpty) return noChangesWidget(context);   
    
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.change_circle), text: "Změny"),
                Tab(icon: Icon(Icons.create), text: "Nové"),
                Tab(icon: Icon(Icons.delete), text: "Smazané"),
              ]
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(child: buildSection(EspoEntityChangeType.update)),
                  SingleChildScrollView(child: buildSection(EspoEntityChangeType.create)),
                  SingleChildScrollView(child: buildSection(EspoEntityChangeType.delete)),
                ]
              ),
            ),
          ],
        )
      ),
    );
  }
}
