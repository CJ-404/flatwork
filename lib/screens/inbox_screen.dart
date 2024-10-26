import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InboxScreen extends ConsumerWidget {
  static InboxScreen builder(BuildContext context, GoRouterState state , String projectId, String userName, String userId)
  => InboxScreen(
    projectId: projectId, userName: userName, userId: userId,
  );
  const InboxScreen({
    super.key,
    required this.projectId,
    required this.userName,
    required this.userId,
  });

  final String userName;
  final String userId;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final receiverName = "David";
    // Dummy messages list
    final List<Map<String, dynamic>> messages = [
      {
        'sender': userName,
        'message': 'Hey, can you review the project plan?',
        'timestamp': '10:00 AM'
      },
      {
        'sender': 'Bob',
        'message': 'Sure, I will get back to you in a bit.',
        'timestamp': '10:05 AM'
      },
      {
        'sender': userName,
        'message': 'Thanks, let me know if you have any questions.',
        'timestamp': '10:15 AM'
      },
      {
        'sender': 'Bob',
        'message': 'I think we should add more details to the timeline.',
        'timestamp': '10:20 AM'
      },
      {
        'sender': userName,
        'message': 'Good idea! I will update it soon.',
        'timestamp': '10:25 AM'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSentByUser = message['sender'] == userName;

                return Align(
                  alignment:
                  isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
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
                        Text(
                          message['sender'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSentByUser ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message['message'],
                          style: TextStyle(
                            color: isSentByUser ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            message['timestamp'],
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
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
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
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
