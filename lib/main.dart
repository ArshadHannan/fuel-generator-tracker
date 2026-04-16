import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
 const HomePage({super.key});

 @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  double horizontalPadding = 50.0;
  double horizontalMargin = 20.0;

  late double position = 40.0;

  List<String> icons = [
    'assets/home.png',
    'assets/generator.png',
    'assets/info.png'
  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(
    body: Stack(
      children:[
        Positioned(
          bottom: horizontalMargin,
          left: horizontalMargin,
          child: CustomPaint(
            painter: AppBarPainter(position),
            size: Size(MediaQuery.of(context).size.width - (2*horizontalMargin), 80.0),
            child: SizedBox(
              height: 120.0,
              width: MediaQuery.of(context).size.width - (2*horizontalMargin),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    children: icons.map<Widget>((icon) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 575),
                        curve: Curves.easeOut,
                        height: 105.0,
                        width: (MediaQuery.of(context).size.width -
                            (2 * horizontalMargin) -
                            (2 * horizontalPadding)) /
                            3,
                        padding: const EdgeInsets.only(top: 17.5, bottom: 22.5),
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 35.0,
                          width: 35.0,
                          child: Center(
                            child: Image.asset(
                              icon,
                              width: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
             ),
            ),
          )
        )
      ],
    ),
    );
  }
}

class AppBarPainter extends CustomPainter{

  double x;
  AppBarPainter(this.x);

  double height = 80.0;
  double start = 40.0;
  double end = 120.0;

  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0.0, start);

    path.lineTo((x < 20.0 ? 20.0 : x), start);
    path.quadraticBezierTo(20.0 + x, start, 30.0 + x, start + 30.0);
    path.quadraticBezierTo(40.0 + x, start + 55.0, 70.0 + x, start + 55.0);
    path.quadraticBezierTo(100.0 + x, start + 55.0, 110.0 + x, start + 30.0);
    path.quadraticBezierTo(120.0 + x, start, (140.0 + x) > (size.width - 20.0) ? (size.width - 20.0) : 140.0 + x, start);

    path.lineTo(size.width - 20.0, start);

    path.quadraticBezierTo(size.width, start, size.width, start + 25.0);
    path.lineTo(size.width, end - 25.0);
    path.quadraticBezierTo(size.width, end, size.width -25.0 , end);
    path.lineTo(25.0, end);
    path.quadraticBezierTo(0.0, end, 0.0, end - 25.0);
    path.lineTo(0.0, start + 25.0);
    path.quadraticBezierTo(0.0, start, 20.0, start);
    path.close();


    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(70.0+ x, 50.0), 35.0, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){
    return true;
  }

}