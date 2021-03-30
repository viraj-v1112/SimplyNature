import 'package:SimplyNatureUI/pages/classificationpage.dart';
import 'package:SimplyNatureUI/pages/diypage.dart';
import 'package:SimplyNatureUI/pages/homepage.dart';
import 'package:SimplyNatureUI/pages/ngodrivepage.dart';
import 'package:SimplyNatureUI/pages/recyclecenterpage.dart';
import 'package:bloc/bloc.dart';

enum NavigationEvents {
  // HomePageClickedEvent,
  ClassifyPageClickedEvent,
  DIYPageClickedEvent,
  RecyclePageClickedEvent,
  NgoPageClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(NavigationStates initialState) : super(initialState);

  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      //   case NavigationEvents.HomePageClickedEvent:
      //     yield HomePage();
      //     break;
      case NavigationEvents.DIYPageClickedEvent:
        yield DIYList(type: 'paper');
        break;
      case NavigationEvents.ClassifyPageClickedEvent:
        yield ClassificationPage();
        break;
      case NavigationEvents.RecyclePageClickedEvent:
        yield RecycleCenterPage();
        break;
      case NavigationEvents.NgoPageClickedEvent:
        yield NgoDrivePage();
        break;
      default:
    }
  }
}
