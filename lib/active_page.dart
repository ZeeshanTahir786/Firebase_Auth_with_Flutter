import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task1/login_page.dart';
import 'constants.dart';

final _fireStore = Firestore.instance;
final meesageTextController = TextEditingController();
FirebaseUser loggedInUser;

class ActivePage extends StatefulWidget {
  @override
  _ActivePageState createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    String messagesText;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                showSpinner = false;
              }),
        ],
        title: Center(child: Text('Welcome')),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: meesageTextController,
                    onChanged: (value) {
                      messagesText = value;
                    },
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      meesageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messagesText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}

class MessageBubbles extends StatelessWidget {
  MessageBubbles({this.sender, this.isMe, this.text});
  final String text;
  final String sender;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: isMe ? Colors.white : Colors.black54),
                ),
              )),
        ],
      ),
    );
  }
}
