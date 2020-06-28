import 'package:flutter/material.dart';

const textFormDecoration = InputDecoration(

    border: InputBorder.none,
        
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  enabled: true,
   fillColor: Colors.white,
   
    filled: true,
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(18.0)),
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0)
  )
  );
