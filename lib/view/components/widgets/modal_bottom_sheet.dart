import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';

class MyModalBottomSheet{
  BuildContext context;
  int index;
  Widget modalBottomSheetChild;
  MyModalBottomSheet({this.context,this.index,this.modalBottomSheetChild});
  
  void showModalSheet(){
           showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child:modalBottomSheetChild,
            ),
        ),
        ),
      );
  }
  
}