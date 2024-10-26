import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/module/auth/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const NexusAdmin());
}

class NexusAdmin extends StatelessWidget {
  const NexusAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService());
      }),
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        useMaterial3: true,
        scheme: FlexScheme.deepOrangeM3,
        blendLevel: 2,
        appBarOpacity: 0.98,
        subThemesData: const FlexSubThemesData(
          inputDecoratorRadius: 8,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          // inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 0x18,
          inputDecoratorUnfocusedHasBorder: false,
          appBarScrolledUnderElevation: 6,
          popupMenuOpacity: 0.96,
          bottomNavigationBarOpacity: 0.96,
          navigationBarOpacity: 0.96,
          navigationRailOpacity: 0.96,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // Custom fonts to demonstrate you pass a default GoogleFonts TextTheme
        // to both textTheme and primaryTextTheme in M2/M3 mode as well as in
        // light/dark theme and have them get correct default color and
        // contrast color in all cases. Vanilla ThemeData does not do this.
        fontFamily: GoogleFonts.notoSans().fontFamily,
        textTheme: GoogleFonts.notoSansTextTheme(),
        primaryTextTheme: GoogleFonts.notoSansTextTheme(),
      ),
      darkTheme: FlexThemeData.dark(
        useMaterial3: true,
        scheme: FlexScheme.blueWhale,
        blendLevel: 14,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.96,
        subThemesData: const FlexSubThemesData(
          inputDecoratorRadius: 8,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 0x22,
          inputDecoratorUnfocusedHasBorder: false,
          popupMenuOpacity: 0.96,
          bottomNavigationBarOpacity: 0.96,
          navigationBarOpacity: 0.96,
          navigationRailOpacity: 0.96,
          navigationRailLabelType: NavigationRailLabelType.none,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
        // Custom fonts to demonstrate you pass a default GoogleFonts TextTheme
        // to both textTheme and primaryTextTheme in M2/M3 mode as well as in
        // light/dark theme and have them get correct default color and
        // contrast color in all cases. Vanilla ThemeData does not do this.
        textTheme: GoogleFonts.notoSansTextTheme(),
        primaryTextTheme: GoogleFonts.notoSansTextTheme(),
      ),
      themeMode: ThemeMode.light,
      home: SplashView(),
    );
  }
}
