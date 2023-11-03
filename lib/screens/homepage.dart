import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/categories/updates.dart';
import 'package:firebaseauth/notes/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = []; //تخزين الداتا اللي راجعة من fireStore
  bool isloading = true;

  getData() async {
    // بتجيب الداتا اللي راجعه من firestore
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("categories").where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
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
          Navigator.of(context).pushNamed("addCategory");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
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
      body:  GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 150),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteView(categoryid: data[index].id)));
                  },
                  onLongPress: (){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Success',
                      desc: 'اختر ما تريد',
                      btnOkText: "تعديل",
                      btnCancelText: "حذف",
                      btnCancelOnPress: ()async{
                        await FirebaseFirestore.instance.collection("categories").doc(data[index].id).delete();
                        Navigator.of(context).pushReplacementNamed("homepage");
                      },
                      btnOkOnPress: () async{
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> EditCategory(docid: data[index].id, oldname: '${data[index]["name"]}',) ));

                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/image/folder.png",
                            height: 90,
                          ),
                          Text(
                            "${data[index]["name"]}",
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
