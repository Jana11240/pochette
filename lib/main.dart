import 'package:bank_card_app/screens/home.dart';
import 'package:bank_card_app/general/styling.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BankCardApp());
}

class BankCardApp extends StatelessWidget {
  const BankCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pochette',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          elevation: 2,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff004aad),
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: kBodyText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          hintStyle: kBodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kSoftTextColor,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kSoftTextColor,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              textStyle: kBodyText.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
