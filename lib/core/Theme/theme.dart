import 'package:flutter/material.dart';

class BTheme {
  final int themeId;
  final Color HeadColor;
  final Color lowShadeColor;
  final Color mediumShadeColor;
  final Color secondaryColor;
  final Color BackgroundColor;
  final Color BackgroundShadeColor;
  final Color DarkTextColor;
  final Color LightTextColor;
  final Color BottomNavColor;
  BTheme({
    required this.themeId,
    required this.HeadColor,
    required this.secondaryColor,
    required this.lowShadeColor,
    required this.mediumShadeColor,
    required this.BackgroundColor,
    required this.BottomNavColor,
    required this.BackgroundShadeColor,
    required this.DarkTextColor,
    required this.LightTextColor,
  });
}

class BergerTheme {
  static List<BTheme> themes = [
    // 1️⃣ Purple
    BTheme(
      themeId: 1,
      lowShadeColor: Color(0xfff3e8ff),
      mediumShadeColor: Color(0xffd8b4fe),
      secondaryColor: Color(0xffa855f7),
      HeadColor: Color(0xff6b21a8),
      LightTextColor: Color(0xff1f2937), // on light bg
      DarkTextColor: Color(0xffffffff), // on dark nav
      BackgroundColor: Color(0xfffcfaff),
      BackgroundShadeColor: Color(0xfff5edff),
      BottomNavColor: Color(0xff6d28d9),
    ),

    // 2️⃣ Blue
    BTheme(
      themeId: 2,
      lowShadeColor: Color(0xffeff6ff),
      mediumShadeColor: Color(0xffbfdbfe),
      secondaryColor: Color(0xff3b82f6),
      HeadColor: Color(0xff1e40af),
      LightTextColor: Color(0xff111827),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xffffffff),
      BackgroundShadeColor: Color(0xfff1f5f9),
      BottomNavColor: Color(0xff1d4ed8),
    ),

    // 3️⃣ Clinic Green
    BTheme(
      themeId: 3,
      lowShadeColor: Color(0xffecfdf5),
      mediumShadeColor: Color(0xffbbf7d0),
      secondaryColor: Color(0xff22c55e),
      HeadColor: Color(0xff166534),
      LightTextColor: Color(0xff14532d),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xfff9fffb),
      BackgroundShadeColor: Color(0xfff0fdf4),
      BottomNavColor: Color(0xff15803d),
    ),

    // 4️⃣ Soft Blue + Green
    BTheme(
      themeId: 4,
      lowShadeColor: Color(0xffe6f2fb),
      mediumShadeColor: Color(0xffbcd9f5),
      secondaryColor: Color(0xff22c55e),
      HeadColor: Color(0xff2563eb),
      LightTextColor: Color(0xff1f2937),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xfffdfaff),
      BackgroundShadeColor: Color(0xffedf5fd),
      BottomNavColor: Color(0xff2563eb),
    ),

    // 5️⃣ Clean White Blue
    BTheme(
      themeId: 5,
      lowShadeColor: Color(0xfff5f9ff),
      mediumShadeColor: Color(0xffdbeafe),
      secondaryColor: Color(0xff2563eb),
      HeadColor: Color(0xff1e3a8a),
      LightTextColor: Color(0xff0f172a),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xffffffff),
      BackgroundShadeColor: Color(0xfff1f5f9),
      BottomNavColor: Color(0xff2563eb),
    ),

    // 6️⃣ Red & White
    BTheme(
      themeId: 6,
      lowShadeColor: Color(0xfffff1f2),
      mediumShadeColor: Color(0xfffecdd3),
      secondaryColor: Color(0xffef4444),
      HeadColor: Color(0xffb91c1c),
      LightTextColor: Color(0xff111827),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xffffffff),
      BackgroundShadeColor: Color(0xfffef2f2),
      BottomNavColor: Color(0xffb91c1c),
    ),

    // 7️⃣ Medical Calm Green
    BTheme(
      themeId: 7,
      lowShadeColor: Color(0xffecfdf5),
      mediumShadeColor: Color(0xffa7f3d0),
      secondaryColor: Color(0xff10b981),
      HeadColor: Color(0xff065f46),
      LightTextColor: Color(0xff064e3b),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xfff9fffb),
      BackgroundShadeColor: Color(0xfff0fdf4),
      BottomNavColor: Color(0xff047857),
    ),

    // 8️⃣ Premium Purple Indigo
    BTheme(
      themeId: 8,
      lowShadeColor: Color(0xfff5f3ff),
      mediumShadeColor: Color(0xffddd6fe),
      secondaryColor: Color(0xff8b5cf6),
      HeadColor: Color(0xff4c1d95),
      LightTextColor: Color(0xff1f2937),
      DarkTextColor: Color(0xffffffff),
      BackgroundColor: Color(0xfffafaff),
      BackgroundShadeColor: Color(0xfff3f0ff),
      BottomNavColor: Color(0xff6d28d9),
    ),

    // 9️⃣ Dark Theme
    BTheme(
      themeId: 9,
      lowShadeColor: Color(0xff1e293b),
      mediumShadeColor: Color(0xff334155),
      secondaryColor: Color(0xff3b82f6),
      HeadColor: Color(0xff818cf8),
      LightTextColor: Color(0xffe2e8f0), // on dark cards
      DarkTextColor: Color(0xffffffff), // nav + main text
      BackgroundColor: Color(0xff0f172a),
      BackgroundShadeColor: Color(0xff111827),
      BottomNavColor: Color(0xff1e293b),
    ),
  ];
}
