import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/quote.dart';
import 'package:quote_tiger/models/user.dart';

class QuoteService {
  static Future<List<QuoteModel>> getQuotesFromRequest(String requestID) async {
    var quotes = (await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestID)
            .collection('quotes')
            .orderBy('creation_date', descending: true)
            .get())
        .docs;
    List<QuoteModel> quoteModels = [];

    for (var quoteSnapshot in quotes) {
      quoteModels.add(QuoteModel.fromSnapshot(quoteSnapshot));
    }

    return quoteModels;
  }

  static Future<DocumentReference> createQuote(String requestID, String content,
      UserModel localUser, List<String> files, String creatorID) async {
    var reference = await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestID)
        .collection('quotes')
        .add({
      'content': content,
      'creator': localUser.id,
      'creation_date': FieldValue.serverTimestamp(),
      // rid = request id
      'target_rid': requestID,
      'target_uid': creatorID,
      'files': files,
    });

    return reference;
  }
}
