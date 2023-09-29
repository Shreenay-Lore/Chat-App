import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!; 
    
    //Loading & Displaying Chat Messages as a Stream.. 
    //We using stream builder here, to listen to a stream of messages so that whenevr a new messege is submitted it's automatically loaded and displayed here..
    return StreamBuilder( 
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true,)   //'orderBy' method define how this collection documents should be orderd...
          .snapshots(),   //it makes sure that whwnevr a new document is added in remote database(i.e. in chat collection), it will automatically notify our app..
      builder: (ctx, chatSnapshots) {                                       
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text ('No messages found.'),);
        }

        if (chatSnapshots.hasError) {
          return const Center(child: Text ('Something went wrong...'),);
        }
        
        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,   // it makes sure that overall list goes from bottom to top.. 
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length 
                ?  loadedMessages[index + 1].data()
                :  null;
                
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = 
                nextChatMessage != null ? nextChatMessage['userId'] : null; 
            final nextUserIsSame  = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'], 
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage : chatMessage['userImage'], 
                username : chatMessage['username'], 
                message : chatMessage['text'], 
                isMe : authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
    
  }
}