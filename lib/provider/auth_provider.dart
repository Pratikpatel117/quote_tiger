import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/controllers/sector_picker_controller.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

/// the possible states of the user
enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated
}

/// Manage:
/// 1. times_opened (how many times the app has been opened)

class AuthProvider extends ChangeNotifier {
  String? currentChat;

  // statuses
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;

  //userparts
  User? _firebaseUser;
  UserModel? model;
  User? get user => _firebaseUser;

  //controllers
  // primary

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // secondary
  TextEditingController locationController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  //toher
  SectorPickerController sectorPickerController = SectorPickerController();

  void setChat(String newChat) {
    currentChat = newChat;
    notifyListeners();
  }

  void clearControllers() {
    passwordController.clear();
    usernameController.clear();
    emailController.clear();
    usernameController.clear();
    locationController.clear();
    fullnameController.clear();
    companyController.clear();
    sectorPickerController.clear();
  }

  Future<UserModel> updateUser({
    String? fullName,
    String? image,
    String? location,
    String? website,
    String? company,
    String? email,
    String? description,
    String? instagram,
    String? facebook,
    String? twitter,
    String? linkedin,
  }) async {
    UserModel oldUser = model!;
    UserModel newUser = UserModel(
      id: oldUser.id,
      instagram: instagram,
      facebook: facebook,
      twitter: twitter,
      linkedin: linkedin,
      username: oldUser.username,
      isSuperUser: oldUser.isSuperUser,
      fullName: fullName ?? oldUser.fullName,
      savedRequestIds: oldUser.savedRequestIds,
      image: image ?? oldUser.image,
      location: location ?? oldUser.location,
      sectors: oldUser.sectors,
      savedProfiles: oldUser.savedProfiles,
      description: description ?? oldUser.description,
      company: company ?? oldUser.company,
      email: email ?? oldUser.email,
      website: website ?? oldUser.website,
    );

    await FirebaseFirestore.instance.collection('users').doc(model!.id).update({
      'instagram': instagram,
      'facebook': facebook,
      'twitter': twitter,
      'linkedin': linkedin,
      "display_name": fullName ?? model!.fullName,
      "company": company ?? model!.company,
      'image': image ?? model!.image,
      'location': location ?? model!.location,
      'about': description ?? model!.location,
      'email': email ?? model!.email,
    });
    model = newUser;
    notifyListeners();
    return newUser;
  }

  AuthProvider.initialize() {
    FirebaseAuth.instance.authStateChanges().listen(
          _onStateChanged,
        );
  }

  Future<String?> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        await prefs.setString("id", value.user!.uid);
      });

      return null;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> signInWithTwitter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      var userCredential = await _signInWithTwitter();
      await prefs.setString("id", userCredential.user!.uid);

      return null;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      var userCredential = await _signInWithGoogle();
      await prefs.setString("id", userCredential.user!.uid);

      return null;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> createAccount() async {
    try {
      await UserService.createUser(
          sectorPaths: sectorPickerController.getSectorPaths,
          company: companyController.text,
          email: user!.email ?? 'no email provided',
          id: user!.uid,
          username: usernameController.text.trim().toLowerCase(),
          displayName: usernameController.text.trim(),
          location: locationController.text);

      /// save the user id in local storage;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("id", user!.uid);

      model = await UserService.getUserById(user!.uid, getSectors: true);
      _status = AuthStatus.authenticated;

      notifyListeners();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUp() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      if (await UserService.checkIfUsernameInUse(
          usernameController.text.trim().toLowerCase())) {
        return 'Username already used. Pick another one';
      }

      if (await UserService.checkIfEmailInUse(emailController.text)) {
        return 'Email already in use. Pick another one';
      }
      if (locationController.text.isEmpty) {
        return 'You need to provide a location';
      }

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then(
        (result) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("id", result.user!.uid);

          UserService.createUser(
              sectorPaths: sectorPickerController.getSectorPaths,
              company: companyController.text,
              email: result.user!.email!,
              id: result.user!.uid,
              username: usernameController.text.trim().toLowerCase(),
              displayName: usernameController.text.trim(),
              location: locationController.text);
        },
      );
      clearControllers();
      return null;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return e.toString().split(']').last.trim();
    }
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    _status = AuthStatus.unauthenticated;
    model = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void _onStateChanged(User? firebaseUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _firebaseUser = firebaseUser;
      await prefs.setString("id", firebaseUser.uid);

      if (model == null) {
        model = await UserService.getUserById(user!.uid, getSectors: true);
      } else {
        model = await model!.getSyncedModel();
      }

      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }
}

Future<UserCredential> _signInWithGoogle() async {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
  // If the user has logged in with google before, it won't show the account picker.
  // Because of that, we need to make sure the user has logged out first
  if (await googleSignIn.isSignedIn()) {
    await googleSignIn.disconnect();
  }

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  final email = googleUser?.email;

  if (googleUser == null) {
    throw Exception("User canceled authentication");
  }
  if (email == null) {
    throw Exception(
        "The email of the google account is null. This shouldn't happen though");
  }

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> _signInWithTwitter() async {
  // Create a TwitterLogin instance
  final twitterLogin = TwitterLogin(
      apiKey: 'lqUvvh5apSOIHn8smuwLzAAZn',
      apiSecretKey: 'uejjafHKc6ScM65BKbBlKF5ro0hGPkQMp0Cvk32C8n65iic1yS',
      redirectURI: 'quotetiger://');

  // Trigger the sign-in flow
  final authResult = await twitterLogin.loginV2();

  // Create a credential from the access token
  final twitterAuthCredential = TwitterAuthProvider.credential(
    accessToken: authResult.authToken!,
    secret: authResult.authTokenSecret!,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance
      .signInWithCredential(twitterAuthCredential);
}

extension ToMap on AuthResult {
  Map<String, dynamic> toMap() {
    return {
      'authToken': authToken,
      'authTokenSecret': authTokenSecret,
      'errorMessage': errorMessage,
      'status': status,
      'user': user,
    };
  }
}
