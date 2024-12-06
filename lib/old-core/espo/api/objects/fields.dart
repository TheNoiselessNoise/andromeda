// ignore_for_file: non_constant_identifier_names

class EspoFieldType {
  static String Address = 'address';
  static String Bool = 'bool';
  static String Date = 'date';
  static String DateTime = 'datetime';
  static String Email = 'email';
  static String Enum = 'enum';
  static String File = 'file';
  static String Float = 'float';
  static String Image = 'image';
  static String Int = 'int';
  static String MultiEnum = 'multiEnum';
  static String Number = 'number';
  static String Password = 'password';
  static String Phone = 'phone';
  static String Text = 'text';
  static String Time = 'time';
  static String Varchar = 'varchar';
  static String Link = 'link';
  static String LinkMultiple = 'linkMultiple';
  static String AttachmentMultiple = 'attachmentMultiple';
  static String Foreign = 'foreign'; 
  static String LinkParent = 'linkParent'; 
}

class EntityFieldAttachment {
  String id;
  String name;
  String type;

  EntityFieldAttachment({
    required this.id,
    required this.name,
    required this.type
  });
}

class EntityFieldAttachments {
  List<String> ids = [];
  Map<String, String> names = {};
  Map<String, String> types = {};

  EntityFieldAttachments({
    this.ids = const [],
    this.names = const {},
    this.types = const {}
  });
}

class EntityFieldLinkMultiple {
  List<String> ids = [];
  Map<String, dynamic> names = {};

  EntityFieldLinkMultiple({
    this.ids = const [],
    this.names = const {}
  });
}

class EntityFieldLink {
  String id;
  String name;

  EntityFieldLink({
    required this.id,
    required this.name
  });
}

class EntityFieldFile {
  String id;
  String name;

  EntityFieldFile({
    required this.id,
    required this.name
  });
}

class EntityFieldImage {
  String id;
  String name;

  EntityFieldImage({
    required this.id,
    required this.name
  });
}

class EntityFieldRelated {
  String id;
  String name;
  String type;

  EntityFieldRelated({
    required this.id,
    required this.name,
    required this.type
  });
}