import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final VoidCallback callBackFunction;
  final String label;

  const AdaptiveFlatButton(this.label, this.callBackFunction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(label),
            onPressed: callBackFunction,
          )
        : TextButton(
            onPressed: callBackFunction,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
