import 'dart:io';
import 'dart:typed_data';
import 'package:andromeda/old-core/core.dart';

class EspoApiBridge {
  static Future<EspoMetadata?> metadata({
    Map<String, String>? headers
  }) async {
    final response = await EspoApi.metadata(headers);
    if (response == null) return null;

    final jsonObject = response.toJsonMap();
    if (jsonObject == null) return null;

    return EspoMetadata(jsonObject);
  }

  static Future<Uint8List?> imageBytesFromAttachment(String attachmentId, {
    Map<String, String>? headers
  }) async {
    EspoEntity? attachment = await EspoApiEntityBridge('Attachment').get(id: attachmentId);
    if (attachment == null) return null;

    String? type = attachment.get('type');
    if (type == null) return null;
    if (!MimeTypeSpecifier.isImage(type)) return null;

    String url = "?entryPoint=download&id=$attachmentId";
    return await EspoApi.bytes(url, headers: headers);
  }

  static Future<Map<String, Uint8List?>> imageBytesFromAttachments(List<String> attachmentIds, {
    Map<String, String>? headers
  }) async {
    Map<String, Uint8List?> result = {};

    for (String attachmentId in attachmentIds) {
      Uint8List? bytes = await imageBytesFromAttachment(attachmentId, headers: headers);
      result[attachmentId] = bytes;
    }

    return result;
  }

  static Future<Map<String, File>> imageFilesFromAttachments(List<String> attachmentIds, {
    Map<String, String>? headers
  }) async {
    Map<String, Uint8List?> imageBytes = await imageBytesFromAttachments(attachmentIds, headers: headers);
    Map<String, File> result = {};
    for (String attachmentId in imageBytes.keys) {
      Uint8List? bytes = imageBytes[attachmentId] ?? Uint8List(0);
      result[attachmentId] = FS.fileFromBytes(attachmentId, bytes);
    }
    return result;
  }
}