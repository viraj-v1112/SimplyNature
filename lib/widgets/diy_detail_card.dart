import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'dart:developer' as logger;
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

class PageItem extends StatefulWidget {
  final int num;
  final DocumentSnapshot event;
  final String date;
  PageItem({Key key, this.event, this.date, this.num}) : super(key: key);

  @override
  _PageItemState createState() => _PageItemState();
}

class _PageItemState extends State<PageItem>
    with SingleTickerProviderStateMixin {
  var user = FirebaseAuth.instance.currentUser;
  // ChewieListItem video;
  int _current = 0;
  AnimationController _controller;
  bool interested = false;
  int radio;
  int current;
  TextEditingController email1;
  TextEditingController email2;
  TextEditingController email3;
  TextEditingController email4;
  bool solo = false;
  String soloPrice;
  bool team = false;
  List<String> teamPrice = [];
  List<String> teamNo = [];
  String regfees;
  List<String> regfees2 = [];
  bool loading = false;
  String adImage = "", adLink = "", streamLink = "";
  var mimeMessage;
  var participants = [];
  String alreadyVotedFor = 'None';
  Timestamp validTill;
  Timestamp validFrom;

  List<String> other_events_ = [
    "Oculus Cube Open",
    "Stand Up Comedy-Nite",
    "Sunburn Campus",
    "START-A-THON 2.0",
    "SPIT Hackathon"
  ];

  bool mailsending = false;

  buttonState() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot userdoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.email)
        .get();

    interested = userdoc['Events'].containsKey(widget.event['eventName']);
    print(interested);
    print("init " + interested.toString());
    setState(() {
      loading = false;
    });
  }

  var builder;
  String text = '';

  @override
  void initState() {
    getparticipants();
    setalreadyVotedFor();

    buttonState();
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

    Widget voteContainer(String s) {
      return GestureDetector(
        onTap: alreadyVotedFor != "None"
            ? () {
                Fluttertoast.showToast(
                  msg: "You have already Voted for $alreadyVotedFor",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.black,
                  fontSize: 14.0,
                );
              }
            : () async {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      elevation: 10,
                      backgroundColor: Colors.white.withOpacity(0.95),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      title: Text(
                        "Are you sure ? ",
                        textAlign: TextAlign.center,
                      ),
                      children: <Widget>[
                        Divider(
                          color: Colors.cyan[900],
                          thickness: 0.8,
                          indent: 10,
                          endIndent: 10,
                        ),
                        SimpleDialogOption(
                          child: Text(
                            'Confirm below if you want to vote for $s',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SimpleDialogOption(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              width: 1,
                              color: Colors.black54,
                            ),
                            SimpleDialogOption(
                              onPressed: () async {
                                Navigator.pop(context);
                                if (DateTime.parse(
                                        Timestamp.now().toDate().toString())
                                    .isBefore(DateTime.parse(
                                        validTill.toDate().toString()))) {
                                  print('voted for $s');

                                  setState(() {
                                    alreadyVotedFor = s;
                                  });

                                  await FirebaseDatabase()
                                      .reference()
                                      .child('votes')
                                      .child(widget.event['eventName'])
                                      .child(user.uid)
                                      .set({'vote': s}).catchError((error) {
                                    print(
                                        "Something went wrong: ${error.message}");
                                  });

                                  Fluttertoast.showToast(
                                    msg: "Successfully Voted for $s",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.black,
                                    fontSize: 14.0,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "The Voting is no Longer Active",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.black,
                                    fontSize: 14.0,
                                  );
                                }
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: alreadyVotedFor != "None"
              ? BoxDecoration(
                  color: alreadyVotedFor == s
                      ? Colors.green
                      : Colors.white.withOpacity(0.5),
                  gradient: alreadyVotedFor == s ? null : AppColors.fabGradient,
                  borderRadius: BorderRadius.circular(10))
              : BoxDecoration(
                  gradient: AppColors.fabGradient,
                  borderRadius: BorderRadius.circular(10)),
          constraints: BoxConstraints(minHeight: 50),
          child: Center(
            child: Text(
              s,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    votingui() {
      // return Container();
      return participants.length == 0 ||
              DateTime.parse(Timestamp.now().toDate().toString())
                  .isBefore(DateTime.parse(validFrom.toDate().toString()))
          ? SizedBox(height: 0)
          : DateTime.parse(Timestamp.now().toDate().toString())
                  .isBefore(DateTime.parse(validTill.toDate().toString()))
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: participants.length + 5,
                  itemBuilder: (ctx, index) {
                    if (index == 0) {
                      return Divider(
                        color: Colors.white.withOpacity(0.5),
                        indent: 30,
                        endIndent: 30,
                      );
                    }
                    if (index == 1) {
                      return Align(
                        child: Text(
                          '\nVote For Your Favourite Team\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (index == 2) {
                      return Divider(
                        color: Colors.white.withOpacity(0.5),
                        indent: 30,
                        endIndent: 30,
                      );
                    }
                    if (index == 3) {
                      return SizedBox(height: 5);
                    }
                    if (index == participants.length + 4) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Voting Open Till : ' +
                                    validTill
                                        .toDate()
                                        .toString()
                                        .substring(0, 16),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  letterSpacing: 0.7,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              alreadyVotedFor == "None"
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color: Colors.redAccent,
                              size: 15,
                            )
                          ],
                        ),
                      );
                    }
                    return voteContainer(participants[index - 4]);
                  })
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: Row(
                    children: [
                      Icon(
                        (alreadyVotedFor == "None")
                            ? Icons.sentiment_very_dissatisfied
                            : Icons.sentiment_very_satisfied,
                        color: (alreadyVotedFor == "None")
                            ? Colors.redAccent
                            : Colors.green[400],
                        size: 20,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          alreadyVotedFor == "None"
                              ? 'You didn\'t vote for anyone.\nThe Voting has already ended.'
                              : 'You Voted for $alreadyVotedFor .',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 0.7,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
    }

    Widget eventImage() {
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
                  widget.event['imageURL'],
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
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .snapshots(),
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
                              eventImage(),
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
                                    widget.event['eventName'],
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              streamLink != ''
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 0.6 * screenWidth),
                                            child: Text(
                                              "This event is currently live",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (await canLaunch(streamLink)) {
                                                await launch(streamLink);
                                              } else {
                                                print("Could not launch url");
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 8, 12, 8),
                                                decoration: BoxDecoration(
                                                    // gradient: LinearGradient(
                                                    //   begin: Alignment.topLeft,
                                                    //   end: Alignment.bottomRight,
                                                    //   colors:[
                                                    //           Colors.green[100],
                                                    //           Colors.green[900]
                                                    //         ],
                                                    // ),
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80)),
                                                child: Center(
                                                    child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Watch Now",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                ))),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
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
                                    widget.event['description'],
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  )),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                                child: Row(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          RadialGradient(
                                              radius: 1,
                                              center: Alignment.topLeft,
                                              tileMode: TileMode.mirror,
                                              colors: [
                                            Colors.cyan,
                                            Colors.deepPurple
                                          ]).createShader(bounds),
                                      child: Icon(
                                        Icons.calendar_today,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                              widget.event['eventName'] == "War of Branches"
                                  ? SizedBox(height: 20)
                                  : other_events_
                                          .contains(widget.event['eventName'])
                                      ? Container(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (widget.event['eventName'] ==
                                                  'Stand Up Comedy-Nite') {
                                                if (!interested) {
                                                  Future.delayed(Duration(
                                                          milliseconds: 300))
                                                      .then((value) {
                                                    setState(() {
                                                      interested = true;
                                                    });

                                                    interestedbackend();
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Already registered.');
                                                }
                                              } else {
                                                String link =
                                                    widget.event['link'];

                                                if (await canLaunch(link)) {
                                                  await launch(link);
                                                } else {
                                                  print(
                                                      'Could not launch $link');
                                                }
                                              }
                                            },
                                            child: Transform.scale(
                                              scale: 1 - _controller.value,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 20, 0, 20),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                height: 50,
                                                width: 180,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: interested
                                                          ? [
                                                              Colors.grey,
                                                              Colors.blueGrey
                                                            ]
                                                          : [
                                                              Colors.cyan,
                                                              Colors.deepPurple
                                                            ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80)),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      mailsending
                                                          ? CupertinoActivityIndicator()
                                                          : Container(),
                                                      SizedBox(
                                                          width: mailsending
                                                              ? 10
                                                              : 0),
                                                      Text(
                                                        mailsending
                                                            ? "Please wait ..."
                                                            : "Register",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                mailsending
                                                                    ? 15
                                                                    : 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 20, 30, 0),
                                                width: screenWidth,
                                                child: Text(
                                                  "Registration Fees",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                )),
                                            Divider(
                                              indent: 30,
                                              endIndent: 30,
                                              color: Colors.grey,
                                            ),
                                            solo
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            30, 0, 30, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          regfees,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 17),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            team
                                                ? Container(
                                                    height:
                                                        regfees2.length * 30.0,
                                                    child: ListView.builder(
                                                        primary: false,
                                                        // shrinkWrap: true,
                                                        // physics:
                                                        //     NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            regfees2.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(30, 5,
                                                                    30, 0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  regfees2[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white70,
                                                                      fontSize:
                                                                          17),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                : Container(),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 30, top: 20, right: 30),
                                              child: InfoText([
                                                "  Tap on register, if you’re interested in participating for the event\n",
                                                "  Once registered, the organisers will contact you shortly\n"
                                              ]),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _controller.forward();
                                                Future.delayed(Duration(
                                                        milliseconds: 150))
                                                    .then((value) =>
                                                        _controller.reverse());

                                                interested = snapshot
                                                    .data['Events']
                                                    .containsKey(widget
                                                        .event['eventName']);

                                                if (!interested) {
                                                  Future.delayed(Duration(
                                                          milliseconds: 300))
                                                      .then((value) {
                                                    setState(() {
                                                      interested = true;
                                                    });

                                                    interestedbackend();
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Already registered.');
                                                }
                                              },
                                              child: Transform.scale(
                                                scale: 1 - _controller.value,
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 20, 0, 20),
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  height: 50,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: interested
                                                            ? [
                                                                Colors.grey,
                                                                Colors.blueGrey
                                                              ]
                                                            : [
                                                                Colors.cyan,
                                                                Colors
                                                                    .deepPurple
                                                              ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80)),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        mailsending
                                                            ? CupertinoActivityIndicator()
                                                            : Container(),
                                                        SizedBox(
                                                            width: mailsending
                                                                ? 10
                                                                : 0),
                                                        Text(
                                                          mailsending
                                                              ? "Please wait ..."
                                                              : "Register",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  mailsending
                                                                      ? 15
                                                                      : 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                              votingui(),
                              SizedBox(height: 15),
                              adImage != ""
                                  ? GestureDetector(
                                      onTap: () async {
                                        // const url = 'https://flutter.dev';
                                        if (await canLaunch(adLink)) {
                                          await launch(adLink);
                                        } else {
                                          print("Could not launch url");
                                        }
                                      },
                                      child: Container(
                                        width: screenWidth,
                                        child: Image.network(adImage,
                                            fit: BoxFit.fitWidth),
                                      ))
                                  : Container(),
                              SizedBox(height: adImage != "" ? 20 : 0),
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
