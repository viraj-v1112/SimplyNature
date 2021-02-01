import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';

class RecycleCenterPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Recycle Page",
        style: TextStyle(
            color: Color(0Xff52057b),
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
