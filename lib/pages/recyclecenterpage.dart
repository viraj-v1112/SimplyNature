import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';

class RecycleCenterPage extends StatefulWidget with NavigationStates {
  // static const routeName = '/map-screen';

  RecycleCenterPage();

  @override
  _RecycleCenterPageState createState() => _RecycleCenterPageState();
}

class _RecycleCenterPageState extends State<RecycleCenterPage> {
  Set<Marker> markers = {};

  void initState() {
    super.initState();
    // if(markers == null){
    //    getCenters().then(
    //       () => setState(() {})
    //    );
    // }
    getCenters();
  }

  Future<void> getCenters() async {
    Firestore firestore = Firestore.instance;
    QuerySnapshot q = await firestore.collection('centers').getDocuments();

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
                    height: 150,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/simplynature-e1066.appspot.com/o/Glass%2Fclamp-12.jpg?alt=media&token=bc72ec59-0ef1-4946-8099-169e2fb2cb86',
                          height: 100,
                          width: 150,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                'This is some name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                'This is the address. This has to be lomg and multiline.',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
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
            19.120128,
            72.8858624,
          ),
          zoom: 16,
        ),
        markers: markers,
      ),
    );
  }
}
