import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final dynamic primaryInfo;
  final dynamic secondaryInfo;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const ListItem({
    Key? key,
    required this.title,
    this.primaryInfo,
    this.secondaryInfo,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (primaryInfo != null)
                  if (primaryInfo is String)
                    Expanded(
                      child: Text(primaryInfo),
                    )
                  else if (primaryInfo is Widget)
                    Expanded(
                      child: primaryInfo,
                    )
                  else
                    const Expanded(
                      child: Text('Info in list items must be one of String or Widget'),
                    ),
                if (secondaryInfo != null)
                  if (secondaryInfo is String)
                    Expanded(
                      child: Text(
                        secondaryInfo ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else if (secondaryInfo is Widget)
                    Expanded(
                      child: secondaryInfo,
                    )
                  else
                    const Expanded(
                      child: Text('Info in list items must be one of String or Widget'),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
