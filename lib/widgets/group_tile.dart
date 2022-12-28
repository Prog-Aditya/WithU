import 'package:flutter/material.dart';
import 'package:withu/pages/chat_page.dart';
import 'package:withu/widgets/widgets.dart';

class Groptile extends StatefulWidget {
  String groupName;
  String groupId;
  String userName;

  Groptile(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<Groptile> createState() => _GroptileState();
}

class _GroptileState extends State<Groptile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: (() {
          nextScreen(
              context,
              ChatPage(
                  groupID: widget.groupId,
                  groupName: widget.groupName,
                  userName: widget.userName));
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              widget.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Join the conversation as ${widget.userName}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
