import 'package:flutter/material.dart';

class InnerGrid extends StatelessWidget {
  final double sz;
  final bool selected;
  final String value;
  final String hint;
  final Function onSelected;

  const InnerGrid({
    super.key,
    required this.sz,
    required this.selected,
    required this.value,
    required this.hint,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => value == "0" ? onSelected() : null,
      child: Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(
          color: selected
              ? Colors.blueAccent.shade100.withAlpha(100)
              : Colors.transparent,
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: Center(
          child: Text(
            value == "0" ? hint : value,
            style:
                TextStyle(color: value == "0" ? Colors.black12 : Colors.black),
          ),
        ),
      ),
    );
  }
}
