import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/chat/message.dart';

enum FileMessageType {
  file,
  image,
}

class FileMessageModel extends MessageModel {
  FileMessageModel({
    required super.id,
    required super.content,
    required super.senderID,
    required super.creationDate,
    required super.target,
    required super.chatID,
    required super.type,
    required this.files,
    super.snapshot,
  }) : assert(type == MessageType.file);
  final List<FileModel> files;

  factory FileMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    DateTime? time;

    if (snapshot['creation_date'] != null) {
      time = snapshot['creation_date'].toDate();
    }

    return FileMessageModel(
        files: _fieldToFileList(snapshot['files'].cast<Map<String, dynamic>>()),
        type: MessageType.file,
        target: snapshot['target'],
        snapshot: snapshot,
        id: snapshot.id,
        content: snapshot['content'],
        senderID: snapshot['sender'],
        chatID: snapshot['chat'],
        creationDate: time ?? DateTime.now());
  }
}

MessageModel getMessageModel(DocumentSnapshot snapshot) {
  if (MessageType.values[snapshot['type']] == MessageType.file) {
    return FileMessageModel.fromSnapshot(snapshot);
  }
  return MessageModel.fromSnapshot(snapshot);
}

class FileModel {
  final String url;
  final String basename;
  final FileMessageType type;

  FileModel({
    required this.url,
    required this.type,
    required this.basename,
  });
}

List<FileModel> _fieldToFileList(List<Map<String, dynamic>> maps) {
  List<FileModel> models = [];
  for (var map in maps) {
    models.add(FileModel(
      url: map['url'],
      type: FileMessageType.values[map['type']],
      basename: map['basename'],
    ));
  }
  return models;
}
