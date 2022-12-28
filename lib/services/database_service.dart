import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  //refrence for collecction
  final CollectionReference usercollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupcollection =
      FirebaseFirestore.instance.collection("groups");

  // Updating the user data
  Future updateUserdata(String fullname, String email) async {
    return await usercollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // geting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await usercollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getuserGroups() async {
    return usercollection.doc(uid).snapshots();
  }

  // crating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupcollection.add({
      "GroupName": groupName,
      "GroupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "resentMessage": "",
      "resentMessageSender": "",
    });
    //update the members
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupdocumentReference.id,
    });

    DocumentReference UserdocumentRefrence = await usercollection.doc(uid);
    return await UserdocumentRefrence.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }

  //getting chats
  getChat(String groupID) async {
    return groupcollection
        .doc(groupID)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  //get group admin
  Future getGroupAdmin(String groupID) async {
    DocumentReference d = groupcollection.doc(groupID);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //get members
  getGroupMenbers(groupID) async {
    return groupcollection.doc(groupID).snapshots();
  }

  //search
  searchByName(String groupName) {
    return groupcollection.where("GroupName", isEqualTo: groupName).get();
  }

  //function -> bool(to check user exist or not)
  Future<bool> isUserJoinde(
      String groupName, String groupId, String userName) async {
    DocumentReference userdocumentReference = usercollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userdocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toogle group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    //doc refrence
    DocumentReference userDocumentRefrence = usercollection.doc(uid);
    DocumentReference groupDocumentRefrence = groupcollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentRefrence.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    //if user has our groups -> then remove them or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentRefrence.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentRefrence.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentRefrence.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentRefrence.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  //send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupcollection.doc(groupId).collection("messages").add(chatMessageData);
    groupcollection.doc(groupId).update({
      "resentMessage": chatMessageData["message"],
      "resentMessageSender": chatMessageData["sender"],
      "recentMessageTime": chatMessageData["time"].toString(),
    });
  }
}
