import 'package:SimplyNatureUI/widgets/diy_steps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageItem extends StatefulWidget {
  final int num;
  final DocumentSnapshot diy;
  PageItem({Key key, this.diy, this.num}) : super(key: key);

  @override
  _PageItemState createState() => _PageItemState();
}

class _PageItemState extends State<PageItem>
    with SingleTickerProviderStateMixin {
  var user = FirebaseAuth.instance.currentUser;
  AnimationController _controller;
  bool loading = false;

  List<DocumentSnapshot> steps = [];

  stepDetails() async {
    Firestore firestore = Firestore.instance;
    QuerySnapshot stepSnap = await firestore
        .collection('diy')
        .document(widget.diy.documentID)
        .collection('steps')
        .getDocuments();
    for (DocumentSnapshot d in stepSnap.documents) {
      setState(() {
        steps.add(d);
        steps.sort((a, b) => a['number'].compareTo(b['number']));
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    stepDetails();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
      lowerBound: 0,
      upperBound: 0.5,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  textfield(controller, fieldname) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Colors.grey[10], borderRadius: BorderRadius.circular(15.0)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        minLines: 1,
        maxLines: 1,
        controller: controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: fieldname,
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget diyImage() {
      return Container(
        width: screenWidth,
        height: screenHeight * 0.3,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              child: Hero(
                tag: "card${widget.num}",
                child: Image.network(
                  widget.diy['imageURL'],
                  width: screenWidth,
                  height: screenHeight * 0.28,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 20,
              // padding: const EdgeInsets.fromLTRB(23.0, 25, 13, 15),
              child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.black.withOpacity(0.3),
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12, 12, 3, 12.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ))),
            ),
          ],
        ),
      );
    }

    return StreamBuilder(
        stream: Firestore.instance.collection('diy').snapshots(),
        builder: (context, snapshot) {
          return SafeArea(
              child: loading
                  ? Container(
                      width: screenWidth,
                      height: screenHeight,
                      child: Center(child: CircularProgressIndicator()))
                  : Material(
                      color: Colors.transparent,
                      child: Stack(children: [
                        Center(
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            color: Color(0xff121212),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 70, 8, 8),
                              child: Image.asset(
                                'assets/images/Oculus BG.png',
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              diyImage(),
                              ShaderMask(
                                shaderCallback: (bounds) => RadialGradient(
                                    radius: 1,
                                    center: Alignment.topLeft,
                                    tileMode: TileMode.mirror,
                                    colors: [
                                      Colors.cyan,
                                      Colors.deepPurple
                                    ]).createShader(bounds),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                                  child: Text(
                                    widget.diy['title'],
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                                  width: screenWidth,
                                  child: Text(
                                    "Description ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              Divider(
                                indent: 30,
                                endIndent: 30,
                                color: Colors.grey,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  width: screenWidth,
                                  child: Text(
                                    widget.diy['description'],
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  )),
                              Container(
                                  padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                                  width: screenWidth,
                                  child: Text(
                                    "Steps",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              Divider(
                                indent: 30,
                                endIndent: 30,
                                color: Colors.grey,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 30, 20),
                                  width: screenWidth,
                                  child: TimeLine(steps: steps)),
                            ],
                          ),
                        ),
                      ]),
                    ));
        });
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
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
