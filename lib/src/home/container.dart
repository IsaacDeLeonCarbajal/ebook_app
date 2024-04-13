import 'package:ebook_app/src/category/category_index.dart';
import 'package:ebook_app/src/home/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = SidebarXController(selectedIndex: 0);
  static final List pages = [
    {
      'title': const Text('EBook Store'),
      'body': const Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 40),
        ),
      ),
    },
    {
      'title': const Text('Registered Categories'),
      'body': const CategoryIndex(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return pages.elementAtOrNull(_controller.selectedIndex)?['title'];
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page.
              return context.goNamed('settings');
            },
          ),
        ],
      ),
      drawer: Sidebar(controller: _controller),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return pages.elementAtOrNull(_controller.selectedIndex)?['body'];
          }),
    );
  }
}
