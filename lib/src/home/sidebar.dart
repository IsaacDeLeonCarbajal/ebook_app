import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

class Sidebar extends StatelessWidget {
  final SidebarXController _controller;

  const Sidebar({Key? key, required SidebarXController controller})
      : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      extendedTheme: const SidebarXTheme(width: 250),
      footerDivider: const Divider(),
      headerBuilder: (context, extended) => const SizedBox(
        height: 140,
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Icon(
            Icons.person,
            size: 60,
          ),
        ),
      ),
      items: [
        SidebarXItem(icon: Icons.home, label: 'Home', onTap: () => context.pop()),
      ],
    );
  }
}
