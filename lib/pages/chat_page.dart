import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:withu/pages/group_info.dart';
import 'package:withu/services/database_service.dart';
import 'package:withu/widgets/message_tile.dart';
import 'package:withu/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupID, groupName, userName;

  const ChatPage(
      {super.key,
      required this.groupID,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messagecontroler = TextEditingController();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DataBaseService().getChat(widget.groupID).then((val) {
      setState(() {
        chats = val;
      });
    });
    DataBaseService().getGroupAdmin(widget.groupID).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (() {
                nextScreenReplace(
                    context,
                    GroupInfo(
                        groupID: widget.groupID,
                        groupName: widget.groupName,
                        adminName: admin));
              }),
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          //chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.grey[700],
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messagecontroler,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendmessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: ((context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sendByme: widget.userName ==
                            snapshot.data.docs[index]['sender'],
                        sender: snapshot.data.docs[index]['sender']);
                  }),
                )
              : Container();
        });
  }

  sendmessage() {
    if (messagecontroler.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messagecontroler.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      DataBaseService().sendMessage(widget.groupID, chatMessageMap);
      setState(() {
        messagecontroler.clear();
      });
    }
  }
}
