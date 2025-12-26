import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fontsizes {
  static const small = 12.0;
  static const standard = 14.0;
  static const standardUp = 16.0;
  static const medium = 20.0;
  static const large = 28.0;
}

class DefaultColors {
  static const Color authPageBg = Color(0xFF000000);
  static const Color authPageElements = Color(0xFF6200FF);
  static const Color authPageFields = Color(0xFF0F71FA);
  static const Color authPageButton = Color.fromARGB(255, 93, 111, 232);

  static const Color senderMessage = Color.fromARGB(255, 32, 39, 60);
  static const Color receiverMessage = Color(0xFF373E4E);
  static const Color sentMessageInput = Color(0xFF262934);

  static const Color messageListPage = Color(0xFF292F3F);
  static const Color contactButtonColor = Color(0xFF5F84E9);
  static const Color profileIconBackground = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFF1B202D),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
