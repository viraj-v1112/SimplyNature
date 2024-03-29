import 'package:SimplyNatureUI/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:SimplyNatureUI/pages/diypage.dart';
import 'package:SimplyNatureUI/pages/homepage.dart';
import 'package:SimplyNatureUI/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(DIYList(type: 'paper')),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
