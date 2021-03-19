import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
// import 'package:oculus/screens/EventDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class DIYCard extends StatefulWidget with NavigationStates {
  final DocumentSnapshot d;
  final String description;
  final String title;
  final String type;
  final int num;
  // final List<Color> gradient;
  // final bool liked;
  final Key key;
  // final bool liked;
  DIYCard(
      {this.description,
      this.title,
      this.type,
      this.num,
      // this.gradient,
      this.d,
      // this.liked,
      this.key})
      : super(key: key);

  @override
  _DIYCardState createState() => _DIYCardState();
}

Color colorFromNum(int num) {
  var random = Random(num);
  var r = random.nextInt(256);
  var g = random.nextInt(256);
  var b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

class _DIYCardState extends State<DIYCard> with TickerProviderStateMixin {
  var user = FirebaseAuth.instance.currentUser;
  bool liked = false;
  bool alreadyliked = false;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   liked = widget.liked? widget.liked : false;
    // });
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getLikedData();
    print(widget.d['type']);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: Firestore.instance.collection('diy').snapshots(),
      builder: (context, snap) {
        if (snap.hasData && !snap.hasError) {
          return Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(7),
              height: height * 0.33,
              child: Stack(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 80),
                      child: Lottie.asset(
                        'assets/images/bgImg.json',
                        height: 200,
                      )),
                  Hero(
                    tag: 'card${widget.num}',
                    child: Container(
                      height: height * 0.27,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        // child:
                        //     Image.network(widget.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 10,
                    left: 10,
                    child: Material(
                      elevation: 5,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.9),
                      child: ShaderMask(
                        shaderCallback: (bounds) => RadialGradient(
                                radius: 1,
                                center: Alignment.topLeft,
                                tileMode: TileMode.mirror,
                                colors: [Colors.cyan, Colors.deepPurple])
                            .createShader(bounds),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                                // color: Colors.blue,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.type,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 37,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 25,
                    child: Container(
                        height: 37,
                        width: 100,
                        child: Center(
                          child: Text(
                            "Learn More",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    left: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    right: 0.0,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        //   onTap: () async {
                        //     await Future.delayed(Duration(milliseconds: 200));
                        //     Navigator.push(
                        //       context,
                        //       SlowMaterialPageRoute(
                        //         builder: (context) {
                        //           return new PageItem(
                        //               event: widget.d,
                        //               date: widget.date,
                        //               num: widget.num);
                        //         },
                        //         fullscreenDialog: true,
                        //       ),
                        //     );
                        //   },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(); // to be done
        }
      },
    );
  }
}

class PageItem extends StatelessWidget {
  final int num;

  const PageItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "card$num",
      child: Scaffold(
        backgroundColor: colorFromNum(num),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }
}

class SlowMaterialPageRoute<T> extends MaterialPageRoute<T> {
  SlowMaterialPageRoute({
    WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => const Duration(seconds: 3);
}
