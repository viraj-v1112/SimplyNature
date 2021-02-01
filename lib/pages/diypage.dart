import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';

class DIYPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "DIY Page",
        style: TextStyle(
            color: Color(0Xff52057b),
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
