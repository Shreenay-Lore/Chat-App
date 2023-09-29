import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  //Push Notification Setup :
  //We have added this method here, bcoz request permission yeilds future..and initState can't support 'async'..
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission(); //ask the user to recieve and handle push notification..& get back notification setting.
    
    //final token = await fcm.getToken();  //It yeilds address of the device on which our app is running..
    //print(token);  //We could send this token (via HTTP or Firebase SDK) to a backend..store it in a database..

    fcm.subscribeToTopic('chat');  //By using this..we can target multiple devices..in one step.
  }
  
  @override
  void initState() {
    super.initState();
    
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter-Chat'),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            )
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(  //Expanded makes sure that 'ChatMessages' does take up as much space as it can take..
            child: ChatMessages(),
          ), 

          NewMessage(),
        ],
      ),
    );
  }
}