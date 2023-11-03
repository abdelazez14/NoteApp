import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/categories/customTextFeildAdd.dart';
import 'package:firebaseauth/component/customButton.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  bool isloading=false;
addCategories()async{
  if(formstate.currentState!.validate()){
    try{
      isloading=true;
      setState(() {

      });
      DocumentReference response= await categories.add
        ({"name": name.text, "id":FirebaseAuth.instance.currentUser!.uid});
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
            CustomButtonAuth(text: "Add",
              onPressed: (){
              addCategories();
            }, color: Colors.orange,),
          ],
        ),
      ),
    );
  }
}
