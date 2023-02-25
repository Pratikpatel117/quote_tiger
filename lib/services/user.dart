import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/utils/globals.dart';

/// all services required
class UserService {
  /// create user based on the [auth id] and the [username]
  static Future<void> createUser({
    required String id,
    required String username,
    required String displayName,
    required String location,
    required String email,
    required List<String> sectorPaths,
    String? company,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      "sectors": sectorPaths,
      "display_name": displayName,
      "username": username,
      "company": company,
      "is_admin": false,
      'image': null,
      "tags": [],
      'saved_requests': [],
      'chats': [],
      'location': location,
      'about': null,
      'email': email,
    });
  }

  /// retrieve an user model based on an user id [String id]
  static Future<UserModel> getUserById(String id,
      {bool getSectors = true}) async {
    var document =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    // if it doesn't exist stop here and return a placeholder
    if (!document.exists) {
      return UserModelPlaceholder().instance;
    }

    return UserModel.fromSnapshot(document);
  }

  static Future<UserModel?> getUserByUsername(
    String username,
  ) async {
    var documents = (await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .limit(1)
            .get())
        .docs;
    if (documents.isEmpty) {
      return null;
    }

    var document = documents[0];
    // if it doesn't exist stop here and return null
    if (!document.exists) {
      return null;
    }

    return UserModel.fromSnapshot(document);
  }

  static Future<bool> checkIfUsernameInUse(String username) async {
    var userWithUsername = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (userWithUsername.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<bool> checkIfEmailInUse(String email) async {
    var userWithTheEmail = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (userWithTheEmail.docs.isNotEmpty) {
      return true;
    }
    return false;
  }
}
