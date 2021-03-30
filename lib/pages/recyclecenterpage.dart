import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:geolocator/geolocator.dart';

class RecycleCenterPage extends StatefulWidget with NavigationStates {
  // static const routeName = '/map-screen';

  RecycleCenterPage();

  @override
  _RecycleCenterPageState createState() => _RecycleCenterPageState();
}

class _RecycleCenterPageState extends State<RecycleCenterPage> {
  Set<Marker> markers = {};
  Position _currentPosition = Position();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  void initState() {
    super.initState();
    // if(markers == null){
    //    getCenters().then(
    //       () => setState(() {})
    //    );
    // }
    _getCurrentLocation();
    getCenters();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> getCenters() async {
    Firestore firestore = Firestore.instance;
    QuerySnapshot q = await firestore.collection('centers').getDocuments();

    print("**********");
    print(_currentPosition);

    for (DocumentSnapshot d in q.documents) {
      // setState(() {
      //   if (d['type'] == type) {
      //     diys.add(d);
      //   }
      //   allDiys.add(d);
      // });

      markers.add(
        Marker(
          markerId: MarkerId(d['uid'].toString()),
          position: LatLng(
            double.parse(d['lat']),
            double.parse(d['long']),
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.lime[100],
                    ),
                    height: 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            d['name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          d['address'],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(markers);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'Your Map',
      //   ),
      // ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            22.4690,
            73.0750,
          ),
          zoom: 16,
        ),
        markers: markers,
      ),
    );
  }
}
