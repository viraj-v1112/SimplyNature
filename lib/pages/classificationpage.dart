import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../pickers/user_image_picker.dart';

class ClassificationPage extends StatefulWidget with NavigationStates {
  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  File _pickedImage;
  String result;

  List<String> classes = [
    'Cardboard',
    'Glass',
    'Metal',
    'Paper',
    'Plastic',
    'Trash'
  ];
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<int> checkResults() async {
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.0.101:5000/predict"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'file',
        _pickedImage.readAsBytes().asStream(),
        _pickedImage.lengthSync(),
        filename: _pickedImage.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);

    print("request: " + request.toString());
    var res = await request.send();
    result = await res.stream.transform(utf8.decoder).join();
    setState(() {});
    return res.statusCode;
  }

  // Future checkResults() async {
  //   final url = "http://192.168.0.107:5000";
  //   final response = await http.post(
  //     url,
  //     body: json.encode(
  //       {
  //         'file': _pickedImage,
  //       },
  //     ),
  //   );
  //   final extractedData = json.decode(response.body) as Map<String, dynamic>;

  //   print(extractedData);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 128),
      child: Column(
        children: [
          UserImagePicker(_selectImage),
          FlatButton.icon(
            onPressed: checkResults,
            icon: Icon(Icons.check_box),
            label: Text('Check Results'),
            textColor: Theme.of(context).primaryColor,
          ),
          if (result != null)
            Text(
              'The obtained class is: ${classes[int.parse(result[1])]}',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
