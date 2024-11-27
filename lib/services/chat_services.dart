import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flatwork/data/models/message.dart';
import 'package:flatwork/services/auth_services.dart';

class ChatServices {
  //   instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // instance of authService
  final AuthServices _authServices = AuthServices();

  // get user stream
  // Stream<List<Map<String,dynamic>>> getUsersStream(String userId, String projectId){
  //   // get all users currently chatting with logged user
  //   return _firestore
  //       .collection("projects").doc(projectId)
  //         .collection("users").doc(userId)
  //           .collection("selected").snapshots()
  //             .map((snapshot) {
  //               return snapshot.docs.map((doc) {
  //                 // for each selected user
  //                 final user = doc.data();
  //                 return user;
  //               }).toList();
  //             });
  // }

  Future<void> sendMessage(String projectId, String receiverId, String message) async {
    // get current user id and name
    final String currentUserId = await _authServices.getSavedUserId();
    final currentUserData = await _authServices.getSavedUserData();

    // create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderName: currentUserData["firstName"]!,
        receiverId: receiverId, message: message,
        timestamp: Timestamp.now()
    );

    // get chat room id = user1_user2
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatroomId = ids.join('_');

    // add new message to firebase
    await _firestore.collection("projects")
        .doc(projectId)
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Future<void> sendAnnouncementMessage(String projectId, String message) async {
    // get current user id and name
    final String currentUserId = await _authServices.getSavedUserId();
    final currentUserData = await _authServices.getSavedUserData();

    // create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderName: currentUserData["firstName"]!,
        receiverId: "ffffff",
        message: message,
        timestamp: Timestamp.now()
    );

    // get chat room id = announcement
    String chatroomId = "announcement";

    // add new message to firebase
    await _firestore.collection("projects")
        .doc(projectId)
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String projectId, String userId, String otherUserId) {
    // get chat room id = user1_user2
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join('_');

    // return chat messages
    return _firestore
        .collection("projects")
        .doc(projectId)
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getAnnouncementMessages(String projectId, String userId) {
    // get chat room id = announcement
    String chatroomId = "announcement";

    // return chat messages
    return _firestore
        .collection("projects")
        .doc(projectId)
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}