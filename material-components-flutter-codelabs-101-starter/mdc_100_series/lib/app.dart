import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'category_menu_page.dart';
import 'colors.dart';
import 'home.dart';
import 'login.dart';
import 'model/product.dart';


class ShrineApp extends StatefulWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  State<ShrineApp> createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  Category _currentCategory = Category.all;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHOPPE TM',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => Backdrop(
          currentCategory: _currentCategory,
          frontLayer: HomePage(category: _currentCategory), // Pass _currentCategory for frontLayer
          backLayer: CategoryMenuPage(
            currentCategory: _currentCategory,
            onCategoryTap: _onCategoryTap,
          ),
          frontTitle: const Text('SHOPEE TM'),
          backTitle: const Text('MENU'),
        ),
      },
      theme: _kShrineTheme,
    );
    
  }
}

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePurple,
      onPrimary: kShrinePurple,
      secondary:kShrinePurple,
      error: kShrinePurple,
    ),
    textTheme: _buildShrineTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kShrinePurple,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: kShrinePurple,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: kShrinePurple,
      ),
    ),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline6: base.headline6!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline4: base.headline4!.copyWith(
          fontSize: 18.0,
        ),
        bodyText2: base.bodyText2!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyText1: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kShrinePurple,
        bodyColor: kShrinePurple,
      );
}
