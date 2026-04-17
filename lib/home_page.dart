import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/generator/generator_page.dart';
import 'pages/info_page.dart';
import 'colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    GeneratorPage(),
    InfoPage(),
  ];

  static const double navBarHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.only(bottom: navBarHeight),
            child: pages[selected],
          ),


          Positioned(
            bottom: 0,
            left: 0,
            child: NavBar(
              selected: selected,
              onTap: (index) => setState(() => selected = index),
            ),
          ),
        ],
      ),
    );
  }
}