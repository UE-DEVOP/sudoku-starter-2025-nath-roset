import 'package:flutter/material.dart';

class InnerGrid extends Container {
  int s = 0;
  double? bx = 0;

  InnerGrid({required this.s, required this.bx});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: bx,
        height: bx,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 0.3)),
        child: Center(child: Text(s.toString())));
  }
}
