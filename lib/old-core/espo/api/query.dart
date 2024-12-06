
enum QueryOperation {
  notEquals,
  equals,
  isNull,
  isNotNull,
  isEmpty,
  isNotEmpty,
  isNot,
  oneOf,
  notOneOf,
  or,
  and,
  inOp, // in is reserved keyword
  notIn,
  linkedWith,
  isTrue,
  isFalse,
  startsWith,
  contains,
  endsWith,
  like,
  notContains,
  notLike,
  today,
  between,
  lastSevenDays,
  ever,
  currentMonth,
  lastMonth,
  nextMonth,
  currentQuarter,
  lastQuarter,
  currentYear,
  lastYear,
  past,
  future,
  lastXDays, // input: int
  nextXDays, // input: int
  olderThanXDays, // input: int
  afterXDays, // input: int
  on, // input: date
  after, // input: date
  before, // input: date
}

class QueryCondition {
  final QueryOperation operation;
  final String field;
  final List<dynamic> value;

  QueryCondition({
    required this.operation,
    required this.field,
    required this.value
  });

  factory QueryCondition.notEquals(String field, dynamic value) => QueryCondition(operation: QueryOperation.notEquals, field: field, value: value);
  factory QueryCondition.equals(String field, dynamic value) => QueryCondition(operation: QueryOperation.equals, field: field, value: value);
  factory QueryCondition.isNull(String field) => QueryCondition(operation: QueryOperation.isNull, field: field, value: ['']);
  factory QueryCondition.isNotNull(String field) => QueryCondition(operation: QueryOperation.isNotNull, field: field, value: ['']);
  factory QueryCondition.isEmpty(String field) => QueryCondition(operation: QueryOperation.isEmpty, field: field, value: ['']);
  factory QueryCondition.isNotEmpty(String field) => QueryCondition(operation: QueryOperation.isNotEmpty, field: field, value: ['']);
  factory QueryCondition.isNot(String field, dynamic value) => QueryCondition(operation: QueryOperation.isNot, field: field, value: value);
  factory QueryCondition.oneOf(String field, List<dynamic> values) => QueryCondition(operation: QueryOperation.oneOf, field: field, value: values);
  factory QueryCondition.notOneOf(String field, List<dynamic> values) => QueryCondition(operation: QueryOperation.notOneOf, field: field, value: values);
  factory QueryCondition.or(List<QueryCondition> conditions) => QueryCondition(operation: QueryOperation.or, field: '', value: conditions);
  factory QueryCondition.and(List<QueryCondition> conditions) => QueryCondition(operation: QueryOperation.and, field: '', value: conditions);
  factory QueryCondition.inOp(String field, List<dynamic> values) => QueryCondition(operation: QueryOperation.inOp, field: field, value: values);
  factory QueryCondition.notIn(String field, List<dynamic> values) => QueryCondition(operation: QueryOperation.notIn, field: field, value: values);
  factory QueryCondition.linkedWith(String field, List<dynamic> values) => QueryCondition(operation: QueryOperation.linkedWith, field: field, value: values);
  factory QueryCondition.isTrue(String field) => QueryCondition(operation: QueryOperation.isTrue, field: field, value: ['']);
  factory QueryCondition.isFalse(String field) => QueryCondition(operation: QueryOperation.isFalse, field: field, value: ['']);
  factory QueryCondition.startsWith(String field, dynamic value) => QueryCondition(operation: QueryOperation.startsWith, field: field, value: value);
  factory QueryCondition.contains(String field, dynamic value) => QueryCondition(operation: QueryOperation.contains, field: field, value: value);
  factory QueryCondition.endsWith(String field, dynamic value) => QueryCondition(operation: QueryOperation.endsWith, field: field, value: value);
  factory QueryCondition.like(String field, dynamic value) => QueryCondition(operation: QueryOperation.like, field: field, value: value);
  factory QueryCondition.notContains(String field, dynamic value) => QueryCondition(operation: QueryOperation.notContains, field: field, value: value);
  factory QueryCondition.notLike(String field, dynamic value) => QueryCondition(operation: QueryOperation.notLike, field: field, value: value);
  factory QueryCondition.today(String field) => QueryCondition(operation: QueryOperation.today, field: field, value: ['']);
  factory QueryCondition.between(String field, List<dynamic> values) => QueryCondition(operation: QueryOperation.between, field: field, value: values);
  factory QueryCondition.lastSevenDays(String field) => QueryCondition(operation: QueryOperation.lastSevenDays, field: field, value: ['']);
  factory QueryCondition.ever(String field) => QueryCondition(operation: QueryOperation.ever, field: field, value: ['']);
  factory QueryCondition.currentMonth(String field) => QueryCondition(operation: QueryOperation.currentMonth, field: field, value: ['']);
  factory QueryCondition.lastMonth(String field) => QueryCondition(operation: QueryOperation.lastMonth, field: field, value: ['']);
  factory QueryCondition.nextMonth(String field) => QueryCondition(operation: QueryOperation.nextMonth, field: field, value: ['']);
  factory QueryCondition.currentQuarter(String field) => QueryCondition(operation: QueryOperation.currentQuarter, field: field, value: ['']);
  factory QueryCondition.lastQuarter(String field) => QueryCondition(operation: QueryOperation.lastQuarter, field: field, value: ['']);
  factory QueryCondition.currentYear(String field) => QueryCondition(operation: QueryOperation.currentYear, field: field, value: ['']);
  factory QueryCondition.lastYear(String field) => QueryCondition(operation: QueryOperation.lastYear, field: field, value: ['']);
  factory QueryCondition.past(String field) => QueryCondition(operation: QueryOperation.past, field: field, value: ['']);
  factory QueryCondition.future(String field) => QueryCondition(operation: QueryOperation.future, field: field, value: ['']);
  factory QueryCondition.lastXDays(String field, dynamic value) => QueryCondition(operation: QueryOperation.lastXDays, field: field, value: value);
  factory QueryCondition.nextXDays(String field, dynamic value) => QueryCondition(operation: QueryOperation.nextXDays, field: field, value: value);
  factory QueryCondition.olderThanXDays(String field, dynamic value) => QueryCondition(operation: QueryOperation.olderThanXDays, field: field, value: value);
  factory QueryCondition.afterXDays(String field, dynamic value) => QueryCondition(operation: QueryOperation.afterXDays, field: field, value: value);
  factory QueryCondition.on(String field, dynamic value) => QueryCondition(operation: QueryOperation.on, field: field, value: value);
  factory QueryCondition.after(String field, dynamic value) => QueryCondition(operation: QueryOperation.after, field: field, value: value);
  factory QueryCondition.before(String field, dynamic value) => QueryCondition(operation: QueryOperation.before, field: field, value: value);

  Map<String, dynamic> toMap() {
    switch (operation) {
      case QueryOperation.notEquals:
        return {'type': 'notEquals', 'attribute': field, 'value': value[0]};
      case QueryOperation.equals:
        return {'type': 'equals', 'attribute': field, 'value': value[0]};
      case QueryOperation.isNull:
        return {'type': 'isNull', 'attribute': field, 'value': ''};
      case QueryOperation.isNotNull:
        return {'type': 'isNotNull', 'attribute': field, 'value': ''};
      case QueryOperation.isEmpty:
        return QueryCondition.or([
          QueryCondition.isNull(field),
          QueryCondition.equals(field, '')
        ]).toMap();
      case QueryOperation.isNotEmpty:
        return QueryCondition.and([
          QueryCondition.isNotNull(field),
          QueryCondition.notEquals(field, '')
        ]).toMap();
      case QueryOperation.isNot:
        return {'type': 'isNot', 'attribute': field, 'value': value[0]};
      case QueryOperation.oneOf:
        return {'type': 'in', 'attribute': field, 'value': value};
      case QueryOperation.notOneOf:
        return QueryCondition.or([
          QueryCondition.notIn(field, value),
          QueryCondition.isNull(field)
        ]).toMap();
      case QueryOperation.or:
        return {'type': 'or', 'value': (value as List<QueryCondition>).map((e) => e.toMap()).toList()};
      case QueryOperation.and:
        return {'type': 'and', 'value': (value as List<QueryCondition>).map((e) => e.toMap()).toList()};
      case QueryOperation.inOp:
        return {'type': 'in', 'attribute': field, 'value': value};
      case QueryOperation.notIn:
        return {'type': 'notIn', 'attribute': field, 'value': value};
      case QueryOperation.linkedWith:
        return {'type': 'linkedWith', 'attribute': field, 'value': value};
      case QueryOperation.isTrue:
        return {'type': 'isTrue', 'attribute': field, 'value': ''};
      case QueryOperation.isFalse:
        return {'type': 'isFalse', 'attribute': field, 'value': ''};
      case QueryOperation.startsWith:
        return {'type': 'startsWith', 'attribute': field, 'value': value[0]};
      case QueryOperation.contains:
        return {'type': 'contains', 'attribute': field, 'value': value[0]};
      case QueryOperation.endsWith:
        return {'type': 'endsWith', 'attribute': field, 'value': value[0]};
      case QueryOperation.like:
        return {'type': 'like', 'attribute': field, 'value': value[0]};
      case QueryOperation.notContains:
        return {'type': 'notContains', 'attribute': field, 'value': value[0]};
      case QueryOperation.notLike:
        return {'type': 'notLike', 'attribute': field, 'value': value[0]};
      case QueryOperation.today:
        return {'type': 'today', 'attribute': field, 'value': ''};
      case QueryOperation.between:
        return {'type': 'between', 'attribute': field, 'value': value, 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.lastSevenDays:
        return {'type': 'lastSevenDays', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.ever:
        return {'type': 'ever', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.currentMonth:
        return {'type': 'currentMonth', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.lastMonth:
        return {'type': 'lastMonth', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.nextMonth:
        return {'type': 'nextMonth', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.currentQuarter:
        return {'type': 'currentQuarter', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.lastQuarter:
        return {'type': 'lastQuarter', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.currentYear:
        return {'type': 'currentYear', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.lastYear:
        return {'type': 'lastYear', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.past:
        return {'type': 'past', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.future:
        return {'type': 'future', 'attribute': field, 'value': '', 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.lastXDays:
        return {'type': 'lastXDays', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.nextXDays:
        return {'type': 'nextXDays', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.olderThanXDays:
        return {'type': 'olderThanXDays', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.afterXDays:
        return {'type': 'afterXDays', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.on:
        return {'type': 'on', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.after:
        return {'type': 'after', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      case QueryOperation.before:
        return {'type': 'before', 'attribute': field, 'value': value[0], 'dateTime': 'true', 'timeZone': 'UTC'};
      default:
        throw UnimplementedError('QueryOperation $operation is not implemented');
    }
  }
}

class EspoApiQueryParamBuilder {
  static Map<String, dynamic> fromTypeFieldValue(String type, String field, List<dynamic> value) {
    switch (type) {
      case 'notEquals': return QueryCondition.notEquals(field, value).toMap();
      case 'equals': return QueryCondition.equals(field, value).toMap();
      case 'isNull': return QueryCondition.isNull(field).toMap();
      case 'isNotNull': return QueryCondition.isNotNull(field).toMap();
      case 'isEmpty': return QueryCondition.isEmpty(field).toMap();
      case 'isNotEmpty': return QueryCondition.isNotEmpty(field).toMap();
      case 'isNot': return QueryCondition.isNot(field, value).toMap();
      case 'oneOf': return QueryCondition.oneOf(field, value).toMap();
      case 'notIn': return QueryCondition.notIn(field, value).toMap();
      case 'notOneOf': return QueryCondition.notOneOf(field, value).toMap();
      case 'linkedWith': return QueryCondition.linkedWith(field, value).toMap();
      case 'isTrue': return QueryCondition.isTrue(field).toMap();
      case 'isFalse': return QueryCondition.isFalse(field).toMap();
      case 'startsWith': return QueryCondition.startsWith(field, value).toMap();
      case 'contains': return QueryCondition.contains(field, value).toMap();
      case 'endsWith': return QueryCondition.endsWith(field, value).toMap();
      case 'like': return QueryCondition.like(field, value).toMap();
      case 'notContains': return QueryCondition.notContains(field, value).toMap();
      case 'notLike': return QueryCondition.notLike(field, value).toMap();
      case 'today': return QueryCondition.today(field).toMap();      
      case 'between': return QueryCondition.between(field, value).toMap();
      case 'lastSevenDays': return QueryCondition.lastSevenDays(field).toMap();
      case 'ever': return QueryCondition.ever(field).toMap();
      case 'currentMonth': return QueryCondition.currentMonth(field).toMap();
      case 'lastMonth': return QueryCondition.lastMonth(field).toMap();
      case 'nextMonth': return QueryCondition.nextMonth(field).toMap();
      case 'currentQuarter': return QueryCondition.currentQuarter(field).toMap();
      case 'lastQuarter': return QueryCondition.lastQuarter(field).toMap();
      case 'currentYear': return QueryCondition.currentYear(field).toMap();
      case 'lastYear': return QueryCondition.lastYear(field).toMap();
      case 'past': return QueryCondition.past(field).toMap();
      case 'future': return QueryCondition.future(field).toMap();
      case 'lastXDays': return QueryCondition.lastXDays(field, value).toMap();
      case 'nextXDays': return QueryCondition.nextXDays(field, value).toMap();
      case 'olderThanXDays': return QueryCondition.olderThanXDays(field, value).toMap();
      case 'afterXDays': return QueryCondition.afterXDays(field, value).toMap();
      case 'on': return QueryCondition.on(field, value).toMap();
      case 'after': return QueryCondition.after(field, value).toMap();
      case 'before': return QueryCondition.before(field, value).toMap();
      default: return QueryCondition.equals(field, value).toMap();
    }
  }
}

class EspoApiQueryBuilder {
  String? entityType;

  Map<String, dynamic> query = {
    'where': [],
    // this is the max size Espo is allowing
    // counts of all records of all entities is returned via module
    'maxSize': 200,
    'offset': 0,
  };

  EspoApiQueryBuilder([
    this.entityType
  ]);

  EspoApiQueryBuilder select(List<String> fields) {
    query['select'] = fields.join(',');
    return this;
  }

  EspoApiQueryBuilder addWhere(QueryCondition condition) {
    (query['where'] as List).add(condition.toMap());
    return this;
  }

  EspoApiQueryBuilder addAllWhere(List<QueryCondition> conditions) {
    (query['where'] as List).addAll(conditions.map((e) => e.toMap()));
    return this;
  }

  EspoApiQueryBuilder addAllWhereMap(List<Map<String, dynamic>> conditions) {
    (query['where'] as List).addAll(conditions);
    return this;
  }

  EspoApiQueryBuilder where(List<QueryCondition> conditions) {
    query['where'] = conditions.map((e) => e.toMap()).toList();
    return this;
  }

  EspoApiQueryBuilder notEquals(String field, dynamic value) {
    return addWhere(QueryCondition.notEquals(field, value));
  }

  EspoApiQueryBuilder equals(String field, dynamic value) {
    return addWhere(QueryCondition.equals(field, value));
  }

  EspoApiQueryBuilder isNull(String field) {
    return addWhere(QueryCondition.isNull(field));
  }

  EspoApiQueryBuilder isNotNull(String field) {
    return addWhere(QueryCondition.isNotNull(field));
  }

  EspoApiQueryBuilder isEmpty(String field) {
    return addWhere(QueryCondition.isEmpty(field));
  }

  EspoApiQueryBuilder isNotEmpty(String field) {
    return addWhere(QueryCondition.isNotEmpty(field));
  }

  EspoApiQueryBuilder isNot(String field, dynamic value) {
    return addWhere(QueryCondition.isNot(field, value));
  }

  EspoApiQueryBuilder oneOf(String field, List<dynamic> values) {
    return addWhere(QueryCondition.oneOf(field, values));
  }

  EspoApiQueryBuilder notIn(String field, List<dynamic> values) {
    return addWhere(QueryCondition.notIn(field, values));
  }

  EspoApiQueryBuilder notOneOf(String field, List<dynamic> values) {
    return addWhere(QueryCondition.notOneOf(field, values));
  }

  EspoApiQueryBuilder linkedWith(String field, String value) {
    return addWhere(QueryCondition.linkedWith(field, [value]));
  }

  EspoApiQueryBuilder linkedWithMany(String field, List<String> values) {
    return addWhere(QueryCondition.linkedWith(field, values));
  }

  EspoApiQueryBuilder isTrue(String field) {
    return addWhere(QueryCondition.isTrue(field));
  }

  EspoApiQueryBuilder isFalse(String field) {
    return addWhere(QueryCondition.isFalse(field));
  }

  EspoApiQueryBuilder startsWith(String field, String value) {
    return addWhere(QueryCondition.startsWith(field, value));
  }

  EspoApiQueryBuilder contains(String field, String value) {
    return addWhere(QueryCondition.contains(field, value));
  }

  EspoApiQueryBuilder endsWith(String field, String value) {
    return addWhere(QueryCondition.endsWith(field, value));
  }

  EspoApiQueryBuilder like(String field, String value) {
    return addWhere(QueryCondition.like(field, value));
  }

  EspoApiQueryBuilder notContains(String field, String value) {
    return addWhere(QueryCondition.notContains(field, value));
  }

  EspoApiQueryBuilder notLike(String field, String value) {
    return addWhere(QueryCondition.notLike(field, value));
  }

  EspoApiQueryBuilder today(String field) {
    return addWhere(QueryCondition.today(field));
  }
  
  EspoApiQueryBuilder between(String field, dynamic dFrom, dynamic dTo) {
    return addWhere(QueryCondition.between(field, [dFrom, dTo]));
  }

  EspoApiQueryBuilder lastSevenDays(String field) {
    return addWhere(QueryCondition.lastSevenDays(field));
  }

  EspoApiQueryBuilder ever(String field) {
    return addWhere(QueryCondition.ever(field));
  }

  EspoApiQueryBuilder currentMonth(String field) {
    return addWhere(QueryCondition.currentMonth(field));
  }

  EspoApiQueryBuilder lastMonth(String field) {
    return addWhere(QueryCondition.lastMonth(field));
  }

  EspoApiQueryBuilder nextMonth(String field) {
    return addWhere(QueryCondition.nextMonth(field));
  }

  EspoApiQueryBuilder currentQuarter(String field) {
    return addWhere(QueryCondition.currentQuarter(field));
  }

  EspoApiQueryBuilder lastQuarter(String field) {
    return addWhere(QueryCondition.lastQuarter(field));
  }

  EspoApiQueryBuilder currentYear(String field) {
    return addWhere(QueryCondition.currentYear(field));
  }

  EspoApiQueryBuilder lastYear(String field) {
    return addWhere(QueryCondition.lastYear(field));
  }

  EspoApiQueryBuilder past(String field) {
    return addWhere(QueryCondition.past(field));
  }

  EspoApiQueryBuilder future(String field) {
    return addWhere(QueryCondition.future(field));
  }

  EspoApiQueryBuilder lastXDays(String field, int days) {
    return addWhere(QueryCondition.lastXDays(field, days));
  }

  EspoApiQueryBuilder nextXDays(String field, int days) {
    return addWhere(QueryCondition.nextXDays(field, days));
  }

  EspoApiQueryBuilder olderThanXDays(String field, int days) {
    return addWhere(QueryCondition.olderThanXDays(field, days));
  }

  EspoApiQueryBuilder afterXDays(String field, int days) {
    return addWhere(QueryCondition.afterXDays(field, days));
  }

  EspoApiQueryBuilder on(String field, DateTime date) {
    return addWhere(QueryCondition.on(field, date));
  }

  EspoApiQueryBuilder after(String field, DateTime date) {
    return addWhere(QueryCondition.after(field, date));
  }
  
  EspoApiQueryBuilder before(String field, DateTime date) {
    return addWhere(QueryCondition.before(field, date));
  }

  EspoApiQueryBuilder limit([
    int? maxSize = 20,
    int offset = 0
  ]) {
    if (maxSize != null) {
      query['maxSize'] = maxSize;
    }
    query['offset'] = offset;
    return this;
  }

  EspoApiQueryBuilder offset(int offset) {
    query['offset'] = offset;
    return this;
  }

  EspoApiQueryBuilder orderBy(String? field, [String? direction = 'asc']) {
    if (field == null) return this;
    query['orderBy'] = field;
    query['order'] = direction;
    return this;
  }

  String build() {
    String? encode(dynamic value, String prefix) {
      if (value is Map) {
        if (value.isEmpty) return null;
        return value.keys.map((key) {
          final fullKey = '$prefix[$key]';
          return encode(value[key], fullKey);
        }).join('&');
      } else if (value is List) {
        if (value.isEmpty) return null;
        return value.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isScalar = item is! Map && item is! List;
          final fullKey = isScalar ? '$prefix[]' : '$prefix[$index]';
          return encode(item, fullKey);
        }).join('&');
      } else {
        return '$prefix=${value.toString()}';
      }
    }

    return Uri.encodeFull(query.keys
      .map((key) => encode(query[key], key))
      .where((element) => element != null)
      .join('&'));
  }
}