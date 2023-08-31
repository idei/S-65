import 'package:flutter/material.dart';

class LabeledCheckboxGeneric extends StatelessWidget {
  const LabeledCheckboxGeneric({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
    this.textStyle,
    this.checkboxScale = 1.5,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function(bool) onChanged;
  final TextStyle textStyle;
  final double checkboxScale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Transform.scale(
                scale: checkboxScale,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
