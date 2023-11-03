import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseauth/categories/customTextFeildAdd.dart';
import 'package:firebaseauth/component/customButton.dart';
import 'package:firebaseauth/notes/view.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.notedocid, required this.categorydocid, required this.value});
  final String notedocid;
  final String value;
  final String categorydocid;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();


  bool isloading=false;
  editNote()async{
    CollectionReference collectionNote =
    FirebaseFirestore.instance.
    collection('categories').
    doc(widget.categorydocid).collection("note");

    if(formstate.currentState!.validate()){
      try{
        isloading=true;
        setState(() {

        });
         await collectionNote.doc(widget.notedocid).update({"note":note.text});
          ({"note": note.text});
        isloading=false;
        setState(() {

        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NoteView(categoryid: widget.categorydocid)));
      } catch(e){
        isloading=false;
        setState(() {

        });
        print("=====================================$e");
      }

    }
  }

  @override
  void initState() {
    note.text=widget.value;

    super.initState();
  }
  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Edit Note"),
      ),
      body: Form(
        key: formstate,
        child:isloading?const Center(child: CircularProgressIndicator(),): Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
              child: AuthTextFormFieldAdd(
                  hinttext: "Edit Your Note",
                  mycontroller: note,
                  validator: (val){
                    if(val==""){
                      return "Can`t be empty";
                    }
                  }),
            ),
            CustomButtonAuth(text: "Edit",
              onPressed: (){
                editNote();
              }, color: Colors.orange,),
          ],
        ),
      ),
    );
  }
}