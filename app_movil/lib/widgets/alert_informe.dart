import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

typedef OnPressedFunction = void Function();

void showCustomAlert(BuildContext context, String title, String description,
    bool screeningRecordatorio, OnPressedFunction onPressedFunction) {
  Alert(
    context: context,
    title: title,
    desc: description,
    alertAnimation: FadeAlertAnimation,
    buttons: [
      DialogButton(
        child: Text(
          "Entendido",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        onPressed: onPressedFunction,
        width: 120,
      )
    ],
  ).show();
}

void alert_screenings_generico(
    BuildContext context, String title, String descripcion) {
  Alert(
    context: context,
    title: title,
    desc: descripcion,
    alertAnimation: FadeAlertAnimation,
    buttons: [
      DialogButton(
        child: Text(
          "Entendido",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
