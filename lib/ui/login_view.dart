import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/components/my_button.dart';
import 'package:sample_app/components/my_text_field.dart';
import 'package:sample_app/localizations/locale_keys.g.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/ui/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static MaterialPage page() {
    return const MaterialPage(
      name: AppLinkLocationKeys.login,
      key: ValueKey(AppLinkLocationKeys.login),
      child: LoginView(),
    );
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _errorMessage = "";
  bool _isFormValid = false;
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _sportImages = [
    {
      'image':
          'https://images.unsplash.com/photo-1504450758481-7338eba7524a?q=80&w=1200',
      'text': 'Find and book basketball courts near you',
      'icon': Icons.sports_basketball,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?q=80&w=1200',
      'text': 'Reserve tennis courts with just a few taps',
      'icon': Icons.sports_tennis,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=1200',
      'text': 'Join matches or create your own game',
      'icon': Icons.sports_soccer,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1592656094267-764a45160876?q=80&w=1200',
      'text': 'Find badminton courts for your next match',
      'icon': Icons
          .sports_tennis,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1200',
      'text': 'Volleyball courts available for booking',
      'icon': Icons.sports_volleyball,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    emailController.addListener(_checkFieldsNotEmpty);
    passwordController.addListener(_checkFieldsNotEmpty);

    Future.delayed(const Duration(milliseconds: 500), () {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (_currentPage < _sportImages.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );

        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    emailController.removeListener(_checkFieldsNotEmpty);
    passwordController.removeListener(_checkFieldsNotEmpty);
    emailController.dispose();
    passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _checkFieldsNotEmpty() {
    setState(() {
      _isFormValid =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  bool _validateEmailFormat(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isValid = emailRegex.hasMatch(email);

    if (!isValid) {
      setState(() {
        _errorMessage = "Invalid email format";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }

    return isValid;
  }

  void _handleLogin(LoginViewModel vm) {
    if (!emailController.text.isNotEmpty ||
        !passwordController.text.isNotEmpty) {
      setState(() {
        _errorMessage = "Email and password cannot be empty";
      });
      return;
    }

    if (!_validateEmailFormat(emailController.text)) {
      return;
    }

    vm.signIn(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = HexColor("#1E88E5");
    final accentColor = HexColor("#FF5722");
    final backgroundColor =
        isDarkMode ? HexColor("#121212") : HexColor("#F5F5F5");
    final cardColor = isDarkMode ? HexColor("#1E1E1E") : Colors.white;
    final textColor = isDarkMode ? Colors.white : HexColor("#212121");
    final hintColor = isDarkMode ? HexColor("#BBBBBB") : HexColor("#757575");

    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(this),
        onViewModelReady: (vm) => vm.initialize(),
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _sportImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _sportImages[index]['image'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      primaryColor,
                                      primaryColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    _sportImages[index]['icon'],
                                    size: 100,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Gradient overlay for readability
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          // Text overlay
                          Positioned(
                            bottom: size.height * 0.4,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  // App name with ball icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _sportImages[index]['icon'],
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "CourtSide",
                                        style: GoogleFonts.poppins(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _sportImages[index]['text'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: size.height * 0.36,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _sportImages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),

                // Login card
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: size.height * 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        size.width * 0.07,
                        size.height * 0.04,
                        size.width * 0.07,
                        size.height * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: GoogleFonts.poppins(
                              fontSize: min(size.width * 0.08, 32),
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "Sign in to continue booking courts",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: hintColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Email field
                          Text(
                            LocaleKeys.email_address.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Email field
                          MyTextField(
                            controller: emailController,
                            hintText: LocaleKeys.input_email.tr(),
                            obscureText: false,
                            prefixIcon: const Icon(Icons.mail_outline),
                            onChanged: () {
                              if (_errorMessage.isNotEmpty) {
                                setState(() {
                                  _errorMessage = "";
                                });
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              _errorMessage,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          // Password field
                          Text(
                            LocaleKeys.password.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          MyTextField(
                            controller: passwordController,
                            hintText: "**************",
                            obscureText: !_passwordVisible,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          // Forgot password option
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Forgot password functionality
                              },
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Sign in button
                          SizedBox(
                            width: double.infinity,
                            child: MyButton(
                              onPressed: () => _handleLogin(vm),
                              buttonText: "Sign In",
                              isLoading: vm.isBusy,
                              isEnabled: _isFormValid,
                              // color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      color: hintColor.withOpacity(0.5))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR CONTINUE WITH",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: hintColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Divider(
                                      color: hintColor.withOpacity(0.5))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Social login buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google login button
                              _buildSocialLoginButton(
                                onTap: () => vm.signInWithGoogle(),
                                icon: 'assets/icons/google_icon.png',
                              ),
                              const SizedBox(width: 25),
                              // Facebook login button
                              _buildSocialLoginButton(
                                onTap: () => vm.signInWithFacebook(),
                                icon: 'assets/icons/facebook_icon.png',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Sign up option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New to CourtSide? ",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: hintColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to signup page
                                },
                                child: Text(
                                  "Join now",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildSocialLoginButton(
      {required String icon, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor("#2D2D2D")
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Image.asset(
          icon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  double min(double a, double b) {
    return a < b ? a : b;
  }
}
