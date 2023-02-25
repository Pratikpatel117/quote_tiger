import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import 'batch_service.dart';

class StorageService {
  var storage = FirebaseStorage.instance;
  final random = const Uuid();

  /// uploads file to storage and returns downloadURL
  Future<String?> uploadFile(File file,
      {String? name, String parentPath = ''}) async {
    var path = '$parentPath/${name ?? random.v1()}.jpg'.replaceAll('//', '/');

    var snap = await storage.ref(path).putFile(file);
    return await snap.ref.getDownloadURL();
  }

  Future<void> deleteFile(String url) async {
    await storage.refFromURL(url).delete();
  }

  Future<String?> replaceFile(String oldURL, File newFile,
      {String? newName}) async {
    if (oldURL !=
        'https://firebasestorage.googleapis.com/v0/b/pietrocka-ranking.appspot.com/o/user_not_found.jpg?alt=media&token=05a0e15f-47dd-4b22-bfcf-988fb8c5806e') {
      storage.refFromURL(oldURL).delete();
    }
    return await uploadFile(newFile, name: newName);
  }

  Future<void> deleteFolder(
      String folderPath, BatchService batchService) async {
    var items = (await (storage.ref(folderPath)).listAll()).items;
    for (var item in items) {
      await item.delete();
    }
  }

  Future<String> uploadFileAdvanced(File file, String targetFolderPath) async {
    var snap = await storage
        .ref('$targetFolderPath/${path.basename(file.path)}')
        .putFile(file);

    return await snap.ref.getDownloadURL();
  }

  Future<List<String>> uploadFilesToFolder(
    List<File> files,
    String targetFolder,
  ) async {
    List<String> urls = [];
    for (var file in files) {
      urls.add(await uploadFileAdvanced(file, targetFolder));
    }

    return urls;
  }

  String getFileName(String url) {
    return storage.refFromURL(url).name;
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      //print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<File> downloadFile(String url) async {
    var reference = storage.refFromURL(url);
    final dir = await getDownloadPath();

    final file = File('$dir/${reference.name}');
    //if (path.extension(file.path) == '.jpeg' ||
    //    path.extension(file.path) == '.png') {
    //  print('true');
    //  await GallerySaver.saveImage(
    //    '${dir}/${reference.name}',
    //  );
    //} else {
    //  print(path.extension(file.path));
    //}

    var thing = await reference.getData();
    if (thing != null) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
      }

      await file.writeAsBytes(thing.toList());
    }

    return file;
  }
}
