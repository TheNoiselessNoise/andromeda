import 'package:andromeda/old-core/core.dart';

class SearchRangeType {
  static const String equals = 'equals';
  static const String notEquals = 'notEquals';
  static const String greaterThan = 'greaterThan';
  static const String lessThan = 'lessThan';
  static const String greaterThanOrEquals = 'greaterThanOrEquals';
  static const String lessThanOrEquals = 'lessThanOrEquals';
  static const String between = 'between';
  static const String contains = 'contains';
  static const String startsWith = 'startsWith';
  static const String endsWith = 'endsWith';
  static const String like = 'like';
  static const String notContains = 'notContains';
  static const String notLike = 'notLike';
  static const String anyOf = 'anyOf';
  static const String noneOf = 'noneOf';
  static const String allOf = 'allOf';
  static const String isEmpty = 'isEmpty';
  static const String isNotEmpty = 'isNotEmpty';
  static const String isTrue = 'isTrue';
  static const String isFalse = 'isFalse';
  static const String any = 'any';
  static const String lastSevenDays = 'lastSevenDays';
  static const String ever = 'ever';
  static const String currentMonth = 'currentMonth';
  static const String lastMonth = 'lastMonth';
  static const String nextMonth = 'nextMonth';
  static const String currentQuarter = 'currentQuarter';
  static const String lastQuarter = 'lastQuarter';
  static const String currentYear = 'currentYear';
  static const String lastYear = 'lastYear';
  static const String today = 'today';
  static const String past = 'past';
  static const String future = 'future';
  static const String lastXDays = 'lastXDays';
  static const String nextXDays = 'nextXDays';
  static const String olderThanXDays = 'olderThanXDays';
  static const String afterXDays = 'afterXDays';
  static const String on = 'on';
  static const String after = 'after';
  static const String before = 'before';
}

class SearchRanges {
  static List<String> get varcharLike => [
    'startsWith', 'contains', 'equals', 'endsWith', 'like', 'notContains', 'notEquals', 'notLike', 'isEmpty', 'isNotEmpty'
  ];
  static List<String> get varcharLikeFields => [
    'varchar', 'barcode', 'foreign', 'number', 'sequenceNumber', 'url', 'vatId'
  ];

  static bool isVarcharLike(String fieldType) => varcharLikeFields.contains(fieldType);

  static List<String> get arrayLike => [
    'anyOf', 'noneOf', 'allOf', 'isEmpty', 'isNotEmpty'
  ];
  static List<String> get arrayLikeFields => [
    'array', 'checklist', 'dynamicChecklist', 'multiEnum', 'urlMultiple'
  ];

  static bool isArrayLike(String fieldType) => arrayLikeFields.contains(fieldType);

  static List<String> get linkLike => [
    'isNotEmpty', 'isEmpty'
  ];
  static List<String> get linkLikeFields => [
    'attachmentMultiple', 'file', 'image'
  ];

  static bool isLinkLike(String fieldType) => linkLikeFields.contains(fieldType);

  static List<String> get numberLike => [
    'isNotEmpty', 'isEmpty', 'equals', 'notEquals', 'greaterThan', 'lessThan', 'greaterThanOrEquals', 'lessThanOrEquals', 'between'
  ];
  static List<String> get numberLikeFields => [
    'autoincrement', 'currency', 'float', 'int'
  ];

  static bool isNumberLike(String fieldType) => numberLikeFields.contains(fieldType);

  static List<String> get textLike => [
    'contains', 'startsWith', 'equals', 'endsWith', 'like', 'notContains', 'notLike', 'isEmpty', 'isNotEmpty'
  ];
  static List<String> get textLikeFields => [
    'text', 'wysiwyg'
  ];

  static bool isTextLike(String fieldType) => textLikeFields.contains(fieldType);

  static List<String> get dateLike => [
    'lastSevenDays', 'ever', 'isEmpty', 'currentMonth', 'lastMonth', 'nextMonth', 'currentQuarter', 'lastQuarter', 'currentYear', 'lastYear', 'today', 'past', 'future', 'lastXDays', 'nextXDays', 'olderThanXDays', 'afterXDays', 'on', 'after', 'before', 'between'
  ];
  static List<String> get dateLikeFields => [
    'date', 'datetime'
  ];

  static bool isDateLike(String fieldType) => dateLikeFields.contains(fieldType);

  static List<String> get boolLike => [
    'isTrue', 'isFalse', 'any'
  ];
  static List<String> get boolLikeFields => [
    'bool'
  ];

  static bool isBoolLike(String fieldType) => boolLikeFields.contains(fieldType);

  static List<String> get enumLike => [
    'anyOf', 'noneOf', 'isEmpty', 'isNotEmpty'
  ];
  static List<String> get enumLikeFields => [
    'enum'
  ];

  static bool isEnumLike(String fieldType) => enumLikeFields.contains(fieldType);

  static List<String> getSearchRanges(String fieldType) {
    if (varcharLikeFields.contains(fieldType)) return varcharLike;
    if (arrayLikeFields.contains(fieldType)) return arrayLike;
    if (linkLikeFields.contains(fieldType)) return linkLike;
    if (numberLikeFields.contains(fieldType)) return numberLike;
    if (textLikeFields.contains(fieldType)) return textLike;
    if (dateLikeFields.contains(fieldType)) return dateLike;
    if (boolLikeFields.contains(fieldType)) return boolLike;
    if (enumLikeFields.contains(fieldType)) return enumLike;
    return [];
  }

  static bool hasInputs(String range) {
    return ![
      'isEmpty', 'isNotEmpty', 'isTrue', 'isFalse', 'any', 'lastSevenDays',
      'ever', 'currentMonth', 'lastMonth', 'nextMonth', 'currentQuarter',
      'lastQuarter', 'currentYear', 'lastYear', 'today', 'past', 'future'
    ].contains(range);
  }
}

class EspoMetadata extends MapTraversable {
  final String __backupLanguage = 'en_US';

  const EspoMetadata(super.data);

  String? get lastSaved => get('lastSaved');
  DateTime get lastSavedDateTime => lastSaved != null ? DateTime.parse(lastSaved!) : DateTime.now();

  Map<String, dynamic> get appSettings => getMap('appSettings');
  Map<String, dynamic> get customMetadata => getMap('customMetadata')
    ..addAll(getMap('customMetadataLocal'));
  Map<String, dynamic> get customValues => getMap('customValues')
    ..addAll(getMap('customValuesLocal'));
  Map<String, dynamic> get customComponents => getMap('customComponents')
    ..addAll(getMap('customComponentsLocal'));
  Map<String, dynamic> get pageDefinitions => getMap('pageDefinitions')
    ..addAll(getMap('pageDefinitionsLocal'));

  Map<String, dynamic>? get metadata => get('metadata');
  Map<String, dynamic>? get i18n => get('i18n');
  Map<String, dynamic>? get layouts => get('layouts');
  Map<String, dynamic>? get tabList => get('tabList');

  Map<String, dynamic>? get app => getMetadata('app');
  Map<String, dynamic>? get authenticationMethods => getMetadata('authenticationMethods');
  Map<String, dynamic>? get clientDefs => getMetadata('clientDefs');
  Map<String, dynamic>? get dashlets => getMetadata('dashlets');
  Map<String, dynamic>? get entityAcl => getMetadata('entityAcl');
  Map<String, dynamic>? get entityDefs => getMetadata('entityDefs');
  Map<String, dynamic>? get fields => getMetadata('fields');
  Map<String, dynamic>? get integrations => getMetadata('integrations');
  Map<String, dynamic>? get recordDefs => getMetadata('recordDefs');
  Map<String, dynamic>? get scopes => getMetadata('scopes');
  Map<String, dynamic>? get themes => getMetadata('themes');
  Map<String, dynamic>? get streamDefs => getMetadata('streamDefs');
  Map<String, dynamic>? get aggregationFunctions => getMetadata('aggregationFunctions');
  Map<String, dynamic>? get formula => getMetadata('formula');

  Map<String, dynamic>? getMetadata(String key) {
    return get('metadata.$key');
  }

  Map<String, dynamic>? getI18n(String key) {
    return get('i18n.$key');
  }

  Map<String, dynamic> getFields(String entityType) {
    return getMap('metadata.entityDefs.$entityType.fields');
  }

  Map<String, dynamic> getLinks(String entityType) {
    return getMap('metadata.entityDefs.$entityType.links');
  }

  Map<String, dynamic>? getField(String entityType, String field) {
    return getFields(entityType)[field];
  }

  Map<String, dynamic>? getLink(String entityType, String field) {
    return getLinks(entityType)[field];
  }

  dynamic getLinkParam(String entityType, String field, String param) {
    return getLink(entityType, field)?[param];
  }

  dynamic getFieldParam(String entityType, String field, String param, [dynamic defaultValue]) {
    return getField(entityType, field)?[param] ?? defaultValue;
  }

  String? getFieldType(String entityType, String field) {
    return getField(entityType, field)?['type'];
  }

  List<String> getEnumStringOptions(String entityType, String field) {
    return getEnumOptions(entityType, field).map((e) => e.toString()).toList();
  }

  bool getFieldReadOnly(String entityType, String field) {
    return getField(entityType, field)?['readOnly'] ?? false;
  }

  List<dynamic> getEnumOptions(String entityType, String field) {
    return getField(entityType, field)?['options'] ?? [];
  }

  String getI18nField(String entityType, String field, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    String? translated = get('i18n.$lang.$entityType.fields.$field');
    return translated ?? get('i18n.$lang.Global.fields.$field') ?? field;
  }

  String? getI18nFieldOption(String entityType, String field, String option, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    return get('i18n.$lang.$entityType.options.$field.$option');
  }

  String? getI18nEntitySingular(String entityType, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    return get('i18n.$lang.Global.scopeNames.$entityType');
  }

  String? getI18nEntityPlural(String entityType, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    return get('i18n.$lang.Global.scopeNamesPlural.$entityType');
  }

  // TODO: is there any other way to get search ranges for specific field type?
  // NOTE: do we want to implement this?
  Map<String, dynamic> getI18nSearchRanges(String fieldType, [String? lang]) {
    lang ??= AppConfig.currentLanguage;

    Map<String, dynamic> defaultRanges = getMap('i18n.$lang.Global.options.searchRanges');

    if (defaultRanges.isEmpty) {
      defaultRanges = getMap('i18n.$__backupLanguage.Global.options.searchRanges');
    }

    Map<String, dynamic> ranges = getMap('i18n.$lang.Global.options.${fieldType}SearchRanges');

    if (ranges.isEmpty) {
      ranges = getMap('i18n.$__backupLanguage.Global.options.${fieldType}SearchRanges');
    }

    if (ranges.isEmpty && fieldType == EspoFieldType.DateTime) {
      return getI18nSearchRanges("date", lang);
    }

    return ranges.isNotEmpty ? ranges : defaultRanges;
  }

  factory EspoMetadata.fromString(String jsonString) {
    return EspoMetadata(Map<String, dynamic>.from(jsonDecode(jsonString) ?? {}));
  }

  String toJson() {
    return jsonEncode(data);
  }

  static Future<EspoMetadata?> fromStorage(String key, [StorageService? storage]) async {
    String? jsonString = await (storage ?? AppConfig.defaultDataStorage).getString(key);
    if (jsonString.isEmpty) return null;
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject == null) return null;
    return EspoMetadata(jsonObject);
  }

  Future<void> toStorage(String key, [StorageService? storage]) async {
    Map<String, dynamic> storableData = {
      'lastSaved': DateTime.now().toIso8601String(),
      ...data
    };

    return await (storage ?? AppConfig.defaultDataStorage).setString(key, jsonEncode(storableData));
  }
}