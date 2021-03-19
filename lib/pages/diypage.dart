import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:SimplyNatureUI/utils/functions.dart';
import 'package:SimplyNatureUI/widgets/diy_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';

class DIYList extends StatefulWidget with NavigationStates {
  String type;

  DIYList({Key key, this.type}) : super(key: key);

  @override
  _DIYListState createState() => _DIYListState(type: type);
}

class _DIYListState extends State<DIYList>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DIYList> {
  bool get wantKeepAlive => true;

  List<DocumentSnapshot> diys = [];
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;
  bool isFade = false;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 15.0, 7.0));
  String type;
  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  var firestore = Firestore.instance;
  bool loading = false;
  List<DocumentSnapshot> allDiys = [];

  _DIYListState({this.type});

  eventdetails() async {
    setState(() {
      loading = true;
    });
    Firestore firestore = Firestore.instance;
    QuerySnapshot q = await firestore.collection('diy').getDocuments();
    for (DocumentSnapshot d in q.documents) {
      setState(() {
        if (d['type'] == type) {
          diys.add(d);
        }
        allDiys.add(d);
      });
      print(diys);
      print(allDiys);
      print(d['title']);
    }
    setState(() {
      loading = false;
    });
  }

  changeDIYList() {
    print(type);
    setState(() {
      List<DocumentSnapshot> l = [];
      for (int i = 0; i < allDiys.length; i++) {
        if (allDiys[i]['type'] == type) {
          l.add(allDiys[i]);
        }
      }
      diys = l;
    });
  }

  @override
  void initState() {
    print("type =" + type.toString());
    eventdetails();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.3), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.3, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (animationController.isCompleted) {
          animationController.reverse();
          setState(() {
            isFade = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.transparent,
            leadingWidth: 100,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Text('DIY',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold))
              ],
            )),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            AnimatedOpacity(
              opacity: isFade ? 0.2 : 1,
              duration: Duration(milliseconds: 800),
              child: Container(
                child: diys.length == 0
                    ? loading
                        ? Container(
                            height: size.height,
                            width: size.width,
                            child: Center(
                                child: Text('Loading ...',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                        fontSize: 16))))
                        : Container(
                            height: size.height,
                            width: size.width,
                            child: Center(
                                child: LottieBuilder.asset(
                                    'assets/images/coming.json')))
                    : ListView.builder(
                        cacheExtent: 5000,
                        itemCount: diys.length,
                        itemBuilder: (context, index) {
                          return DIYCard(
                            key: ValueKey(diys[index]['title']),
                            description: diys[index]['description'],
                            title: diys[index]['title'],
                            type: diys[index]['type'],
                            num: index,
                            d: diys[index],
                          );
                        },
                      ),
              ),
            ),
            isFade
                ? Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.transparent)
                : Container(),
            Positioned(
                child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                IgnorePointer(
                  ignoring: isFade,
                  child: Container(
                    // color: Colors.black.withOpacity(0.3),
                    height: size.height + 30,
                    width: size.width,
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(93),
                      degThreeTranslationAnimation.value * size.height / 2.28),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value))
                      ..scale(degThreeTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            width: 170,
                            height: 130,
                            child: InkWell(
                              onTap: () {
                                print("glass");
                                setState(() {
                                  type = 'glass';
                                });
                                changeDIYList();
                                animationController.reverse();
                                setState(() {
                                  isFade = false;
                                });
                              },
                              child: Image.asset(
                                'assets/images/Event Images_1-03.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                //Right to the top upper
                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(89),
                      degTwoTranslationAnimation.value * size.height / 3.53),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value))
                      ..scale(degTwoTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            width: 170,
                            height: 130,
                            // color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                print("paper");
                                setState(() {
                                  type = 'paper';
                                });
                                changeDIYList();
                                animationController.reverse();
                                setState(() {
                                  isFade = false;
                                });
                              },
                              child: Image.asset(
                                'assets/images/Event Images_1-02.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(119),
                      degTwoTranslationAnimation.value * size.height / 2.03),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value))
                      ..scale(degTwoTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            width: 170,
                            height: 130,
                            child: InkWell(
                              onTap: () {
                                print("cardboard");
                                setState(() {
                                  type = 'cardboard';
                                });
                                changeDIYList();
                                animationController.reverse();
                                setState(() {
                                  isFade = false;
                                });
                              },
                              child: Image.asset(
                                'assets/images/Event Images_1-05.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(134),
                      degOneTranslationAnimation.value * size.height / 2.6),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value))
                      ..scale(degOneTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            width: 170,
                            height: 130,
                            child: InkWell(
                              onTap: () {
                                print("metal");
                                setState(() {
                                  type = 'metal';
                                });
                                changeDIYList();
                                animationController.reverse();
                                setState(() {
                                  isFade = false;
                                });
                              },
                              child: Image.asset(
                                'assets/images/Event Images_1-04.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(136),
                      degOneTranslationAnimation.value * size.height / 5.5),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value))
                      ..scale(degOneTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 130,
                          // color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              print("trash");
                              setState(() {
                                type = 'trash';
                              });
                              changeDIYList();
                              animationController.reverse();
                              setState(() {
                                isFade = false;
                              });
                            },
                            child: Image.asset(
                              'assets/images/Event Images_1-01.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Transform.translate(
                  offset: Offset.fromDirection(getRadiansFromDegree(136),
                      degOneTranslationAnimation.value * size.height / 5.5),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value))
                      ..scale(degOneTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 130,
                          // color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              print("plastic");
                              setState(() {
                                type = 'plastic';
                              });
                              changeDIYList();
                              animationController.reverse();
                              setState(() {
                                isFade = false;
                              });
                            },
                            child: Image.asset(
                              'assets/images/Event Images_1-01.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  right: 30,
                  bottom: 30,
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value)),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 25,
                          offset: Offset(-5, -5), // changes position of shadow
                        ),
                      ]),
                      child: CircularButton(
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.category,
                          color: Colors.white,
                        ),
                        onClick: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                            setState(() {
                              isFade = false;
                            });
                          } else {
                            animationController.forward();
                            setState(() {
                              print("Forward");
                              isFade = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Icon icon;
  final Function onClick;

  CircularButton({this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.deepPurple, Colors.cyan]),
          shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
