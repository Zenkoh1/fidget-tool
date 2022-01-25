import 'package:flutter/material.dart';

class SettingsOption extends StatelessWidget {
  final String label;
  final Widget child;
  const SettingsOption({
    Key key,
    @required this.label,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '$label:',
        style: TextStyle(
          fontSize: size.height * 0.025,
          color: Colors.white,
        ),
      ),
      SizedBox(
        width: size.width * 0.05,
      ),
      child,
    ]);
  }
}
