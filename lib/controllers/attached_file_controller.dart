import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:quote_tiger/services/storage/storage.dart';
import 'package:path/path.dart' as path;

class FileController {
  List<File> files = [];

  // remove all the files from the list
  void clear() {
    files = [];
  }

  void removeByPath(String path) {
    for (var file in files) {
      if (file.path == path) {
        files.remove(file);
        break;
      }
    }
  }

  List<String> get fileNames {
    List<String> filenames = [];
    for (var item in files) {
      filenames.add(path.basename(item.path));
    }
    return filenames;
  }
  
  List<String> get extensions {
    List<String> extensions = [];
    for (var item in files) {
      extensions.add(path.extension(item.path));
    }
    return extensions;
  }

  List<String> get filePaths {
    List<String> filenames = [];
    for (var item in files) {
      filenames.add(item.path);
    }
    return filenames;
  }

  bool _checkIfAlreadyIn(String? path) {
    if (path == null) {
      return false;
    }

    for (var file in files) {
      if (path == file.path) {
        return true;
      }
    }

    return false;
  }

  Future<void> pickFiles({int? limit}) async {
    try {
      if (await perm.Permission.storage.isDenied) {
        await perm.Permission.storage.request();
        if (await perm.Permission.storage.isDenied) {
          return;
        }
      }

      var result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;
      if (limit != null) {
        if (result.files.length > limit) {
          throw ErrorHint("You can't open more than $limit files at a time");
        }
      }

      for (var file in result.files) {
        if (!_checkIfAlreadyIn(file.path)) {
          files.add(File(file.path!));
        }
      }
    } on PlatformException {
      debugPrint("Permission denied");
    }
  }

  Future<void> removeFile(String filepath) async {
    for (var file in files) {
      if (file.path == filepath) {
        files.remove(file);
        break;
      }
    }
  }

  Future<List<String>> uploadAll(String folderPath) async {
    return await StorageService().uploadFilesToFolder(files, folderPath);
  }
}
