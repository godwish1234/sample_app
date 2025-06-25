import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/ui/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/localizations/locale_keys.g.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  static MaterialPage page() => const MaterialPage(
        name: AppLinkLocationKeys.profile,
        key: ValueKey(AppLinkLocationKeys.profile),
        child: ProfileView(),
      );

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onViewModelReady: (vm) => vm.initialize(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.white, // Changed from Colors.grey[50]
          body: CustomScrollView(
            slivers: [
              // Clean Profile Header
              SliverAppBar(
                expandedHeight: 180, // Reduced from 220
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildCompactProfileHeader(context, vm),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () => vm.navigateToEditProfile(),
                    ),
                  ),
                ],
              ),

              // Quick Stats Cards
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: _buildQuickStatsCards(context),
                ),
              ),

              // Membership Section (show if not a member)
              SliverToBoxAdapter(
                child: _buildMembershipSection(context, vm),
              ),

              // Recent Activity
              SliverToBoxAdapter(
                child: _buildCompactActivitySection(context),
              ),

              // Settings & Actions
              SliverToBoxAdapter(
                child: _buildModernSettingsSection(context, vm, isDarkMode),
              ),

              // Logout Section
              SliverToBoxAdapter(
                child: _buildLogoutSection(context, vm),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactProfileHeader(BuildContext context, ProfileViewModel vm) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Picture
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: vm.userProfile?.photoURL != null
                      ? Image.network(
                          vm.userProfile!.photoURL!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildCompactAvatarPlaceholder(),
                        )
                      : _buildCompactAvatarPlaceholder(),
                ),
              ),
              const SizedBox(height: 12),
              // Name
              Text(
                vm.userProfile?.displayName ?? "Alex Johnson",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Location
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600], size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "New York, NY",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactAvatarPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 35,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildQuickStatsCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child:
                  _buildStatCard("23", "Bookings", Icons.event, Colors.blue)),
          const SizedBox(width: 12),
          Expanded(
              child: _buildStatCard(
                  "27", "Matches", Icons.sports_tennis, Colors.green)),
          const SizedBox(width: 12),
          Expanded(
              child: _buildStatCard("2", "Teams", Icons.groups, Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipSection(BuildContext context, ProfileViewModel vm) {
    // You can make this dynamic based on user's membership status
    final bool isMember = true;

    if (isMember) {
      // Show membership status for existing members
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.amber[400]!,
              Colors.amber[600]!,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Member',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Unlimited bookings & exclusive perks',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => vm.navigateToMembershipDetails(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Manage',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show upgrade prompt for non-members
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upgrade to Premium',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Unlock exclusive features & save more',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Benefits list
            _buildBenefitItem('✓ Unlimited court bookings'),
            _buildBenefitItem('✓ Priority booking access'),
            _buildBenefitItem('✓ 20% discount on all bookings'),
            _buildBenefitItem('✓ Exclusive member events'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => vm.navigateToMembershipUpgrade(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Upgrade Now',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildCompactActivitySection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Activity",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCompactActivityItem("Basketball Court Booked", "April 8",
              Icons.check_circle, Colors.green),
          _buildCompactActivityItem(
              "Tennis Match Won", "April 5", Icons.sports_tennis, Colors.blue),
          _buildCompactActivityItem(
              "Team Practice", "April 3", Icons.groups, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildCompactActivityItem(
      String title, String date, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSettingsSection(
      BuildContext context, ProfileViewModel vm, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernMenuItem("Personal Information", Icons.person_outline,
              () => vm.navigateToSettings()),
          _buildMenuDivider(),
          _buildModernMenuItem("Payment Methods", Icons.credit_card,
              () => vm.navigateToPaymentMethods()),
          _buildMenuDivider(),
          _buildModernMenuItem("Notifications", Icons.notifications_none,
              () => vm.navigateToNotifications()),
          _buildMenuDivider(),
          _buildModernMenuItem("Help Center", Icons.help_outline,
              () => vm.navigateToHelpCenter()),
          _buildMenuDivider(),
          _buildModernMenuItem(
              "Contact Us", Icons.mail_outline, () => vm.navigateToContactUs()),
          _buildMenuDivider(),
          _buildModernMenuItem(
            isDarkMode ? "Light Mode" : "Dark Mode",
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            () => vm.toggleThemeMode(),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => vm.toggleThemeMode(),
              activeColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernMenuItem(String title, IconData icon, VoidCallback onTap,
      {Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  Widget _buildLogoutSection(BuildContext context, ProfileViewModel vm) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () => _showModernLogoutDialog(context, vm),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.red[700], size: 20),
              const SizedBox(width: 12),
              Text(
                "Logout",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.grey[600],
      ),
    );
  }

  void _showModernLogoutDialog(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                vm.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
