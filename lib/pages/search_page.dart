import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:withu/helper/helper_function.dart';
import 'package:withu/pages/chat_page.dart';
import 'package:withu/services/database_service.dart';
import 'package:withu/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchControler = TextEditingController();
  bool _isloading = false, hasUserSearched = false, isJoined = false;
  User? user;
  String userName = "";
  QuerySnapshot? searchSnapshot;

  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getCurrentUserIdandName() async {
    await helperFunction.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text(
            "Search",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchControler,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Search group ...",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    initiateSearchMethod();
                  }),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchControler.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      await DataBaseService()
          .searchByName(searchControler.text)
          .then((snapshots) {
        setState(() {
          searchSnapshot = snapshots;
          _isloading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: ((context, index) {
              return groupTile(
                  searchSnapshot!.docs[index]['GroupName'],
                  searchSnapshot!.docs[index]['groupId'],
                  userName,
                  searchSnapshot!.docs[index]['admin']);
            }),
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DataBaseService(uid: user!.uid)
        .isUserJoinde(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String groupName, String groupId, String userName, String admin) {
    //funbction to check weather a group is alreedy joined by user  or not
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
      ),
      subtitle: Text("Admin : ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DataBaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined; 
            });
            ShowSnakBar(context, Colors.green, "Succesfully Joinde");
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupID: groupId,
                      groupName: groupName,
                      userName: userName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
            });
            ShowSnakBar(context, Colors.red, "Leaved group $groupName");
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Join Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
