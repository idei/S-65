import 'package:flutter/material.dart';

class CustomDivider extends StatefulWidget {
  var text;
  var color;

  CustomDivider({this.text, this.color});

  @override
  State<CustomDivider> createState() => _CustomDividerState();
}

class _CustomDividerState extends State<CustomDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 5,
            color: widget.color,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 5,
            color: widget.color,
          )),
        ],
      ),
    );
  }
}
