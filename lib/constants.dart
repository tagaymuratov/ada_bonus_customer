import 'package:flutter/material.dart';

const BoxDecoration gradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF009554),
      Color(0xFF000000),
      Color(0xFF000000),
    ]
  )
);

final Widget loader = Container(
  color: Colors.white, 
  child: const Center( child: CircularProgressIndicator())
);  