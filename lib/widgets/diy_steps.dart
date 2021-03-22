import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  double height, width;
  int date = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget rippleCircle(color) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color.withOpacity(0.3)),
        child: Animator<double>(
          duration: Duration(seconds: 1),
          tween: Tween<double>(begin: 2.0, end: 8.0),
          cycles: 0,
          builder: (context, animatorState, child) => Center(
            child: Container(
              margin: EdgeInsets.all(
                animatorState.value,
              ),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
        ));
  }

  Widget timeLineStepsCard(
      int number, String description, BuildContext context) {
    return ClipPath(
      clipper: LineClipper(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            color: Color(0xff2b343b),
            border: Border.all(
              color: Colors.deepPurple,
            )),
        height: 100,
        child: Row(
          children: [
            ClipPath(
              clipper: LineClipper2(),
              child: Container(
                height: 130,
                width: 22,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Step " + number.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  description,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width - 25;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: height * 0.9,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Scrollbar(
                    child: Container(
                        // height: height * 0.3,
                        width: width - 20,
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            if (index != 5) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: width * 0.2 - 10,
                                      child: Column(
                                        children: [
                                          rippleCircle(Colors.blue),
                                          Container(
                                              height: 100,
                                              width: 3,
                                              color: Color(0xff8f8f8f)),
                                        ],
                                      )),
                                  Container(
                                    width: width * 0.8 - 10,
                                    child: timeLineStepsCard(
                                        index, 'ajgvoduvsdjbpizdbc', context),
                                  )
                                ],
                              );
                            } else {
                              return Container(
                                  padding: EdgeInsets.only(left: 19),
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.blue,
                                  ));
                            }
                          },
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LineClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(20, 20);
    path.lineTo(20, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class LineClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(20, 20);
    path.lineTo(20, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 20);
    path.lineTo(size.width - 20, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
