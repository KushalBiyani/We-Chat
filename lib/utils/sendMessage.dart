import 'package:cloud_firestore/cloud_firestore.dart';

void sendMessage(groupChatId, message) async {
  var documentReference = FirebaseFirestore.instance
      .collection('messages')
      .doc(groupChatId)
      .collection(groupChatId)
      .doc(DateTime.now().millisecondsSinceEpoch.toString());

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(
      documentReference,
      message,
    );
  });
}
