import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flatwork/services/auth_services.dart';
import 'package:flatwork/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../providers/user/users_provider.dart';

class InboxScreen extends ConsumerWidget {
  static InboxScreen builder(BuildContext context, GoRouterState state , String projectId, String receiverName, String receiverId, userId)
  => InboxScreen(
    projectId: projectId, receiverName: receiverName, receiverId: receiverId, userId: userId
  );
  InboxScreen({
    super.key,
    required this.projectId,
    required this.receiverName,
    required this.receiverId,
    required this.userId,
  });

  final String receiverName;
  final String receiverId;
  final String projectId;
  final String userId;

  final TextEditingController _messageController = TextEditingController();

  //chat services
  final ChatServices _chatServices = ChatServices();

  void sendMessage() async {
    // not empty
    if (_messageController.text.isNotEmpty) {
      //send
      receiverName == "Announcements"?
      await _chatServices.sendAnnouncementMessage(projectId, _messageController.text)
        :
      await _chatServices.sendMessage(projectId, receiverId, _messageController.text);
      _messageController.text = "";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataState = ref.watch(userDataProvider);

    return userDataState.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text("Error: $err"),
      data: (userData) {
        return Scaffold(
          appBar: AppBar(
            title: Text(receiverName),
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildMessageList(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: (receiverName == "Announcements") && (userData['role'] == "MEMBER")?
                  [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Only administrators of this project can send messages in Announcements! "
                                  "Try to contact an administrator"
                          ),
                        )
                    )
                  ]
                      :
                  [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: () {
                        // Handle sending messages here
                        sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return StreamBuilder(
        stream: receiverName == "Announcements"? _chatServices.getAnnouncementMessages(projectId, userId) : _chatServices.getMessages(projectId, userId, receiverId),
        builder: (context, snapshot) {
          //errors
          if (snapshot.hasError) {
            return const Text("Error");
          }

          //loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          
          //return if empty
          if (snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No messages found"),
            );
          }

          // return List view
          return ListView(
            children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc, context)).toList(),
          );
       }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final message = data["message"];
    final senderName = data['senderName'];

    final timestamp = (data['timestamp'] as Timestamp).toDate();
    final DateFormat formatter = DateFormat('yyyy.MM.dd : hh.mm a');

    final isSentByUser = data['senderId'] == userId;

    print(isSentByUser);

    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: isSentByUser ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Text(
                senderName,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: isSentByUser ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: isSentByUser ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Text(
                message,
                style: TextStyle(
                  color: isSentByUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: isSentByUser ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Text(
                formatter.format(timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: isSentByUser ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
