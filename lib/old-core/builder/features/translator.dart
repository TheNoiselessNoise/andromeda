import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class Translator {
  static String field(BuildContext context, String entityType, String field, [String? lang]) {
    lang ??= AppConfig.currentLanguage;

    String? translated = context.espoState.metadata?.getI18nField(entityType, field, lang);
    translated ??= mapListWalker(context.metadata.customMetadata, 'i18n.$lang.$entityType.fields.$field');
    return translated ?? field;
  }

  static String fieldOption(BuildContext context, String entityType, String field, String option, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    
    String? translated = context.espoState.metadata?.getI18nFieldOption(entityType, field, option, lang);
    translated ??= mapListWalker(context.metadata.customMetadata, 'i18n.$lang.$entityType.options.$field.$option');
    return translated ?? option;
  }

  static String entitySingular(BuildContext context, String entityType, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    
    String? translated = context.espoState.metadata?.getI18nEntitySingular(entityType, lang);
    translated ??= mapListWalker(context.metadata.customMetadata, 'i18n.$lang.Global.scopeNames.$entityType');
    return translated ?? entityType;
  }

  static String entityPlural(BuildContext context, String entityType, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    
    String? translated = context.espoState.metadata?.getI18nEntityPlural(entityType, lang);
    translated ??= mapListWalker(context.metadata.customMetadata, 'i18n.$lang.Global.scopeNamesPlural.$entityType');
    return translated ?? entityType;
  }

  static Map<String, dynamic> searchRanges(BuildContext context, String fieldType, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    
    return context.metadata.getI18nSearchRanges(fieldType, lang);
  }

  static String searchRange(BuildContext context, String fieldType, String range, [String? lang]) {
    lang ??= AppConfig.currentLanguage;
    
    Map<String, dynamic> ranges = searchRanges(context, fieldType, lang);
    return ranges[range] ?? range;
  }
}