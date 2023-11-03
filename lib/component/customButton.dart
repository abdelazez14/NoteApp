import 'package:flutter/material.dart';
class CustomButtonAuth extends StatelessWidget {
  const CustomButtonAuth({super.key, this.onPressed, required this.text, required this.color});

  final void Function()? onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      color: color,
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: onPressed,
      textColor: Colors.white,
      child: Text(text,style: TextStyle(fontSize: 11),),
    );
  }
}
