import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/categories/customTextFeildAdd.dart';
import 'package:firebaseauth/component/customButton.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key, required this.docid,required this.oldname});
  final String docid;
  final String oldname;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  bool isloading=false;
  editCategory()async{
    if(formstate.currentState!.validate()){
      try{
        isloading=true;
        setState(() {

        });
        var response= await categories.doc(widget.docid).set(
          {
            "name":name.text,
          },SetOptions(merge: true),
        );
        isloading=false;
        setState(() {

        });
        Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route)=> false);
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
name.dispose();
    super.dispose();
  }
  @override
  void initState() {
    name.text=widget.oldname;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Category"),
      ),
      body: Form(
        key: formstate,
        child:isloading?const Center(child: CircularProgressIndicator(),): Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
              child: AuthTextFormFieldAdd(
                  hinttext: "Enter name",
                  mycontroller: name,
                  validator: (val){
                    if(val==""){
                      return "Can`t be empty";
                    }
                  }),
            ),
            CustomButtonAuth(text: "Save",
              onPressed: (){
                editCategory();
              }, color: Colors.orange,),
          ],
        ),
      ),
    );
  }
}
