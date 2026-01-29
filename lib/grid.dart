import 'package:flutter/material.dart';

class InnerGrid extends StatefulWidget {
  int? s = 0;
  double? bx = 0;

  InnerGrid({super.key, required this.s, required this.bx});

  @override
  State<StatefulWidget> createState() => _GridState();
}

class _GridState extends State<InnerGrid> {
  bool isSelected = false;

  void invertChoice() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.bx,
        height: widget.bx,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.shade100.withAlpha(100)
              : Colors.transparent,
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: InkWell(
          onTap: () => invertChoice(),
          child: Center(child: Text(widget.s == 0 || widget.s == null ? "" : widget.s.toString())),
        ));
  }
}
