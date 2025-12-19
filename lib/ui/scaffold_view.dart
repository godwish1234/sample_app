import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/ui/activity/activity_view.dart';
import 'package:sample_app/ui/activity/new_activity/create_activity_view.dart';
import 'package:sample_app/ui/community/event_view.dart';
import 'package:sample_app/ui/home/equipment/equipment_view.dart' as sample_app;
import 'package:sample_app/ui/home/cafe/cafe_menu_view.dart' as sample_app;
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
      navRailName: 'Activity',
      bottomNavBarName: 'Activity',
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
      const ActivityView(),
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
              border: Border.all(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
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
                  border: Border.all(
                    color: backgroundColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: fabColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
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
              _navigationItems[index].bottomNavBarName,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1F1F1F)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Quick Actions',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSheetOption(
                  context,
                  icon: Icons.calendar_month_rounded,
                  title: 'New Booking',
                  subtitle: 'Book a court or venue',
                  color: const Color(0xFF2563EB),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateActivityView(),
                      ),
                    );
                  },
                ),
                _buildSheetOption(
                  context,
                  icon: Icons.qr_code_scanner,
                  title: 'Check In',
                  subtitle: 'Scan QR code to check in',
                  color: const Color(0xFF8B5CF6),
                  isComingSoon: true,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check In - Coming Soon!')),
                    );
                  },
                ),
                _buildSheetOption(
                  context,
                  icon: Icons.emoji_events_rounded,
                  title: 'Tournaments',
                  subtitle: 'Browse and join tournaments',
                  color: const Color(0xFFF59E0B),
                  isComingSoon: true,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tournaments - Coming Soon!')),
                    );
                  },
                ),
                _buildSheetOption(
                  context,
                  icon: Icons.fitness_center,
                  title: 'Equipment Rental',
                  subtitle: 'Browse available sports equipment',
                  color: const Color(0xFFEC4899),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const sample_app.EquipmentView(),
                      ),
                    );
                  },
                ),
                _buildSheetOption(
                  context,
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Cafe Menu',
                  subtitle: 'Order food and beverages',
                  color: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const sample_app.CafeMenuView(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900.withOpacity(0.3)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Soon',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
