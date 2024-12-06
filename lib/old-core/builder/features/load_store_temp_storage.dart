import 'package:andromeda/old-core/core.dart';

class TemporaryStorage extends MapTraversable {
  String storageKey = 'tempStorage';

  TemporaryStorage(super.data);

  // Future<void> toStorage([StorageService? storageService]) async {
  //   storageService ??= StorageService.instance;
  //   await storageService.set('tempStorage', storage);
  // }

  // Future<void> fromStorage([StorageService? storageService]) async {
  //   storageService ??= StorageService.instance;
  //   storage = await storageService.get('tempStorage') ?? {};
  // }
}