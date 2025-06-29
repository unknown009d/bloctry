import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData nothingTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.black,
  fontFamily: 'Nothing',
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryRed,
    onPrimary: AppColors.white,
    secondary: AppColors.darkGray,
    onSecondary: AppColors.white,
    error: Colors.red,
    onError: AppColors.white,
    background: AppColors.black,
    onBackground: AppColors.lightGray,
    surface: AppColors.darkGray,
    onSurface: AppColors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.black,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.white),
  ),
  iconTheme: const IconThemeData(color: AppColors.white),

  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.darkGray,
    contentTextStyle: TextStyle(color: AppColors.white),
    actionTextColor: AppColors.primaryRed,
    behavior: SnackBarBehavior.fixed,
  ),
);
