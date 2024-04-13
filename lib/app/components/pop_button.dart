import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class PopButton extends StatelessWidget {
  final Icon icon;
  final String message;
  const PopButton({Key? key, required this.icon, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: icon,
        onPressed: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: const TextStyle(),
              ),
            ),
            direction: PopoverDirection.bottom,
          );
        });
  }
}
