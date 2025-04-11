import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/ui/bookings/bookings_view.dart';
import 'package:sample_app/ui/community/community_view.dart';
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
      const CommunityView(),
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
      decoration: BoxDecoration(
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...List.generate(2, (index) {
                  final isSelected = vm.currentNavIndex == index;
                  return _buildNavItem(
                      vm, index, isSelected, selectedColor, unselectedColor);
                }),
                Container(width: 60),
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
                  boxShadow: [
                    BoxShadow(
                      color: fabColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
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

  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Quick Actions",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOptionItem(context, Icons.add_business, "New Booking",
                        () {
                      Navigator.pop(context);
                    }),
                    _buildOptionItem(
                        context, Icons.sports_basketball, "Find Court", () {
                      Navigator.pop(context);
                    }),
                    _buildOptionItem(context, Icons.schedule, "Schedule", () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
