import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/ui/activities/activities_view.dart';
import 'package:sample_app/ui/activities/new_activity/create_activity_view.dart';
import 'package:sample_app/ui/community/event_view.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_app/ui/home/home_view.dart';
import 'package:sample_app/ui/profile/profile_view.dart';
import 'package:sample_app/ui/scaffold_view_model.dart';

class NavigationItem {
  final String navRailName;
  final String bottomNavBarName;
  final IconData icon;
  final IconData activeIcon;

  NavigationItem({
    required this.navRailName,
    required this.bottomNavBarName,
    required this.icon,
    required this.activeIcon,
  });
}

class ScaffoldView extends StatefulWidget {
  const ScaffoldView({super.key});

  static MaterialPage page() => const MaterialPage(child: ScaffoldView());

  @override
  State<StatefulWidget> createState() => _ScaffoldViewState();
}

class _ScaffoldViewState extends State<ScaffoldView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      navRailName: 'Home',
      bottomNavBarName: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavigationItem(
      navRailName: 'Bookings',
      bottomNavBarName: 'Bookings',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
    ),
    NavigationItem(
      navRailName: 'Community',
      bottomNavBarName: 'Community',
      icon: Icons.people_outline,
      activeIcon: Icons.people,
    ),
    NavigationItem(
      navRailName: 'Profile',
      bottomNavBarName: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      const HomeView(),
      const BookingsView(),
      const EventView(),
      const ProfileView()
    ];

    return ViewModelBuilder<ScaffoldViewModel>.reactive(
      viewModelBuilder: () => ScaffoldViewModel(),
      onViewModelReady: (vm) => vm.initialize(),
      builder: (context, vm, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: IndexedStack(
            index: vm.currentNavIndex,
            children: children,
          ),
          extendBody: true,
          bottomNavigationBar: _buildBottomNavigationBar(vm),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(ScaffoldViewModel vm) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor =
        isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500;
    final fabColor = Theme.of(context).colorScheme.primary;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 65,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(2, (index) {
                  final isSelected = vm.currentNavIndex == index;
                  return _buildNavItem(
                      vm, index, isSelected, selectedColor, unselectedColor);
                }),
                const SizedBox(width: 48),
                ...List.generate(2, (index) {
                  final actualIndex = index + 2;
                  final isSelected = vm.currentNavIndex == actualIndex;
                  return _buildNavItem(vm, actualIndex, isSelected,
                      selectedColor, unselectedColor);
                }),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: GestureDetector(
              onTap: () {
                _showAddOptionsBottomSheet(context);
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: fabColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28, // Slightly smaller
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(ScaffoldViewModel vm, int index, bool isSelected,
      Color selectedColor, Color unselectedColor) {
    return InkWell(
      onTap: () => vm.onNavigationItemClicked(index),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? _navigationItems[index].activeIcon
                  : _navigationItems[index].icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              _navigationItems[index].bottomNavBarName.tr(),
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOptionsBottomSheet(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateActivityView(),
      ),
    );
  }
}
