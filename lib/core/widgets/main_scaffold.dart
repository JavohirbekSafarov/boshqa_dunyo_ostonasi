import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  static const List<_Destination> destinations = [
    _Destination(
      label: AppStrings.HOME,
      icon: LineIcons.home,
      route: AppRoutes.HomePage,
    ),
    _Destination(
      label: AppStrings.UPLOAD,
      icon: LineIcons.plusCircle,
      route: AppRoutes.UploadPage,
    ),
    _Destination(
      label: AppStrings.PROFILE,
      icon: LineIcons.user,
      route: AppRoutes.ProfilePage,
    ),
  ];

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _locationToTabIndex(String location) {
    final index = MainScaffold.destinations.indexWhere(
      (d) => location.startsWith(d.route),
    );
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = _locationToTabIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        items:
            MainScaffold.destinations
                .map(
                  (d) => BottomNavigationBarItem(
                    backgroundColor: Colors.blueGrey,
                    icon: Icon(d.icon),
                    label: d.label,
                  ),
                )
                .toList(),
        onTap: (index) {
          final selectedRoute = MainScaffold.destinations[index].route;
          if (location != selectedRoute) {
            setState(() {
              currentIndex = index;
            });
            context.go(selectedRoute);
          }
        },
      ),
    );
  }
}

class _Destination {
  final String label;
  final IconData icon;
  final String route;

  const _Destination({
    required this.label,
    required this.icon,
    required this.route,
  });
}
