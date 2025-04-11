import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final bool isLoading;
  final bool isEnabled;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color enabledColor = HexColor('#007BFF');
    final Color disabledColor = HexColor('#CCCCCC');
    final Color loadingColor = enabledColor.withOpacity(0.7);

    Color currentColor =
        isLoading ? loadingColor : (isEnabled ? enabledColor : disabledColor);

    return GestureDetector(
      onTap: (isLoading || !isEnabled) ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isEnabled && !isLoading
              ? [
                  BoxShadow(
                    color: enabledColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Text(
                buttonText,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
