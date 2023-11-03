import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseauth/categories/customTextFeildAdd.dart';
import 'package:firebaseauth/component/customButton.dart';
import 'package:firebaseauth/notes/view.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.docid});
final String docid;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();


  bool isloading=false;
  addNote()async{
    CollectionReference collectionNote =
    FirebaseFirestore.instance.collection('categories').doc(widget.docid).collection("note");

    if(formstate.currentState!.validate()){
      try{
        isloading=true;
        setState(() {

        });
        DocumentReference response= await collectionNote.add
          ({"note": note.text});
        isloading=false;
        setState(() {

        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NoteView(categoryid: widget.docid)));
      } catch(e){
        isloading=false;
        setState(() {

        });
        print("=====================================$e");
      }

    }
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
        title: const Text("Add Note"),
      ),
      body: Form(
        key: formstate,
        child:isloading?const Center(child: CircularProgressIndicator(),): Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
              child: AuthTextFormFieldAdd(
                  hinttext: "Enter Your Note",
                  mycontroller: note,
                  validator: (val){
                    if(val==""){
                      return "Can`t be empty";
                    }
                  }),
            ),
            CustomButtonAuth(text: "Add",
              onPressed: (){
                addNote();
              }, color: Colors.orange,),
          ],
        ),
      ),
    );
  }
}