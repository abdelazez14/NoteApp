import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/categories/updates.dart';
import 'package:firebaseauth/notes/edit.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'add.dart';

class NoteView extends StatefulWidget {
  NoteView({super.key, required this.categoryid});
  final String categoryid;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = []; //تخزين الداتا اللي راجعة من fireStore
  bool isloading = true;

  getData() async {
    // بتجيب الداتا اللي راجعه من firestore
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("categories").
    doc(widget.categoryid).collection("note").get();

    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNote(docid: widget.categoryid,)));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Notes'),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn google = GoogleSignIn();
                google.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body:  WillPopScope(onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route) => false);
        return Future.value(false);
      },
      child: GridView.builder(
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 150),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onLongPress: (){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'Success',
                desc: ' هل انت متاكد من عمليه الحذف ؟',
                btnCancelOnPress: ()async{

                },
                btnOkOnPress: () async{
                 await FirebaseFirestore.instance.
                 collection("categories").
                 doc(widget.categoryid).
                 collection("note").doc(data[index].id).delete();
                 Navigator.of(context).push(MaterialPageRoute(
                     builder: (context)=> NoteView(categoryid: widget.categoryid)));
                },
              ).show();

            },
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=>EditNote(
                      notedocid: data[index].id,
                      categorydocid: widget.categoryid,
                      value: data[index]["note"])));
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "${data[index]["note"]}",
                      style: TextStyle(fontSize: 11),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      ),

    );
  }
}