import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int count = 0;
  int? imgIndex;
  bool animationHappen = false;
  final List<String> imgList = [
    'assets/Cafe_misto.png',
    'assets/Chai_tea_Late.png',
    'assets/Cold_Drink.png',
    'assets/Hot_Chocolate.png',
    'assets/Ice_tea.png',
  ];
  late final animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late final animation = Tween<double>(begin: 0, end: 1.5 * 150);

  double get holeSize => animation.evaluate(animationController);

  late final coffeeAnimationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));

  late final coffeeAnimation = Tween<double>(begin: 0, end: 170 * 2)
      .chain(CurveTween(curve: Curves.easeInBack));

  late final coffeeRotationAnimation = Tween<double>(begin: 0, end: 0.5)
      .chain(CurveTween(curve: Curves.easeInBack));

  double get coffeeOffset =>
      coffeeAnimation.evaluate(coffeeAnimationController);

  double get coffeeRotationOffset =>
      coffeeRotationAnimation.evaluate(coffeeAnimationController);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
    coffeeAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    coffeeAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 120,
                child: Container(
                  margin: const EdgeInsets.only(left: 290, top: 30),
                  child: Stack(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          // foregroundColor: Colors.teal,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      if (count != 0)
                        Container(
                          margin: const EdgeInsets.only(left: 40, top: 2),
                          child: Text(
                            '${count.toString()}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.teal[600],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                )),
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        //width: 200,
                        //height: 160,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                              child: Image.asset(imgList[index],
                                  fit: BoxFit.cover),
                            ),
                            Expanded(
                              child: FloatingActionButton(
                                backgroundColor: Colors.teal,
                                onPressed: () async {
                                  animationHappen = true;
                                  setState(() {
                                  });
                                  count++;
                                  imgIndex = index;
                                  animationController.forward();
                                  coffeeAnimationController.forward();
                                    Future.delayed(
                                            const Duration(milliseconds: 500))
                                        .then((value) {
                                      animationController.reverse();
                                      coffeeAnimationController.reset();
                                      animationHappen = false;
                                      // coffeeAnimationController.reverse();
                                      setState(() {});
                                    });
                                },
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 30),
            SizedBox(
              // height: 150*1.25,
              // width: double.infinity,
              child: ClipPath(
                clipper: BlackHoleClipper(),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 75),
                      height: 100,
                      width: holeSize,
                      child: Image.asset(
                        "assets/hole.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    if (imgIndex != null && animationHappen)
                      Transform.translate(
                        offset: Offset(0, coffeeOffset),
                        child: Container(
                          margin: EdgeInsets.only(left: 50),
                          height: 120,
                          child: Image.asset(imgList[imgIndex!],
                              fit: BoxFit.cover),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 4),
            width: size.width + 100,
            height: size.height + 100),
        0,
        pi,
        true);

    path.lineTo(0, -1000);
    // path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
