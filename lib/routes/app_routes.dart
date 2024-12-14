import 'package:get/get.dart';
import 'package:untitled2/layout/almadeeb_delivers.dart';
import 'package:untitled2/layout/deliverables%D9%80recored.dart';


import '../layout/add_family.dart';
import '../layout/admin_home_screen.dart';
import '../layout/almanadeeb_screen.dart';
import '../layout/alshoab_screen.dart';
import '../layout/edit_family.dart';
import '../layout/listfamily_screen.dart';
import '../layout/login_screen.dart';
import '../layout/my_deliveries_screen.dart';
import '../layout/showdetails_screen.dart';
import '../layout/splash_screen.dart';
import '../layout/users_home_screen.dart';
import '../layout/users_screen.dart';

class AppRoutes {
  static const splashScreen = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: Routes.splashScreen,
      page: () => Splash_Screen(),
    ),

    GetPage(
      name: Routes.loginScreen,
      page: () => Login_Screen(),
    ),

    GetPage(
      name: Routes.addFamily,
      page: () => Add_Family(),
    ),

    GetPage(
      name: Routes.adminHomeScreen,
      page: () => Admin_Home_Screen(),
    ),
    GetPage(
      name: Routes.almanadeepScreen,
      page: () => Almanadeeb_Screen(),
    ),
    GetPage(
      name: Routes.alshoabScreen,
      page: () => Alshoab_Screen(),
    ),

    GetPage(
      name: Routes.editFamily,
      page: () => Edit_Family(),
    ),

    GetPage(
      name: Routes.listFamilyScreen,
      page: () => ListFamily_Screen(),
    ),

    GetPage(
      name: Routes.showDetails,
      page: () => ShowDetails_Screen(),
    ),

    GetPage(
      name: Routes.usersScreen,
      page: () => UsersScreen(),
    ),

    GetPage(
      name: Routes.usersHomeScreen,
      page: () => UsersHome_Screen(),
    ),
    GetPage(
      name: Routes.mydeliveries_screen,
      page: () => MyDeliveries_Screen(),
    ),
    GetPage(
      name: Routes.deliverablesrRecored,
      page: () => DeliverablesrRecored(),
    ),

    GetPage(
      name: Routes.alManadeebDelivers,
      page: () => AlManadeebDelivers(),
    ),
    // Add more routes here
  ];
}

class Routes {
  static const splashScreen = '/launch_screen';
  static const loginScreen = '/login_screen';
  static const addFamily = '/add_family';
  static const adminHomeScreen = '/admin_home';
  static const almanadeepScreen = '/manadeep_screen';
  static const alshoabScreen = '/alshoab_screen';
  static const editFamily = '/editFamily_screen';
  static const listFamilyScreen = '/list_family_screen';
  static const showDetails = '/show_details_screen';
  static const usersScreen = '/users_screen';
  static const usersHomeScreen = '/usershome_screen';
  static const mydeliveries_screen = '/mydeliveries_screen';
  static const deliverablesrRecored = '/deliverablesrRecored';
  static const alManadeebDelivers = '/alManadeebDelivers';

}
