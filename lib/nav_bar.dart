import 'package:flutter/material.dart';
import 'app_bar_painter.dart';
import 'colors.dart';

class NavBar extends StatefulWidget {
  final int selected;
  final Function(int) onTap;

  const NavBar({super.key, required this.selected, required this.onTap});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TickerProviderStateMixin {
  double horizontalPadding = 40.0;
  double horizontalMargin = 0.0;
  int noOfIcons = 3;

  List<String> icons = [
    'assets/home.png',
    'assets/generator.png',
    'assets/info.png',
  ];

  late double position;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 375));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    animation = Tween(
      begin: getEndPosition(0),
      end: getEndPosition(0),
    ).animate(controller);
    position = getEndPosition(0);
    super.didChangeDependencies();
  }

  double getEndPosition(int index) {
    double valueToOmit = 2 * horizontalMargin + 2 * horizontalPadding;
    return (((MediaQuery.of(context).size.width - valueToOmit) / noOfIcons) *
        index +
        horizontalPadding) +
        (((MediaQuery.of(context).size.width - valueToOmit) / noOfIcons) / 2) -
        70;
  }

  void animateDrop(int index) {
    animation = Tween(begin: position, end: getEndPosition(index)).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    controller.forward().then((value) {
      position = getEndPosition(index);
      controller.dispose();
      controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 575));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: AppBarPainter(animation.value),
          size: Size(MediaQuery.of(context).size.width, 100.0),
          child: SizedBox(
            height: 120.0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: icons.map<Widget>((icon) {
                  final index = icons.indexOf(icon);
                  return GestureDetector(
                    onTap: () {
                      animateDrop(index);
                      widget.onTap(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 375),
                      curve: Curves.easeOut,
                      height: 105,
                      width: (MediaQuery.of(context).size.width -
                          (2 * horizontalMargin) -
                          (2 * horizontalPadding)) /
                          3,
                      padding: const EdgeInsets.only(bottom: 40.0),
                      alignment: widget.selected == index
                          ? Alignment.topCenter
                          : Alignment.bottomCenter,
                      child: SizedBox(
                        height: 35.0,
                        width: 35.0,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 575),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeOut,
                            child: widget.selected == index
                                ? Image.asset(icon,
                                key: ValueKey('selected$icon'),
                                width: 30.0,
                                color: AppColors.secondary)
                                : Image.asset(icon,
                                key: ValueKey('unselected$icon'),
                                width: 30.0,
                                color: const Color(0xFF9D9D9D)),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}