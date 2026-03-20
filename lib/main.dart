import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rebar_bender_cabinet/initial_screen.dart';
import 'package:rebar_bender_cabinet/providers/user_provider.dart';
import 'package:rebar_bender_cabinet/screens/main_navigation.dart';
import 'package:rebar_bender_cabinet/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(child: RebarBenderApp(prefs: prefs)));
}

class RebarBenderApp extends ConsumerStatefulWidget {
  final SharedPreferences prefs;
  const RebarBenderApp({super.key, required this.prefs});

  @override
  ConsumerState<RebarBenderApp> createState() => _RebarBenderAppState();
}

class _RebarBenderAppState extends ConsumerState<RebarBenderApp> {
  @override
  void initState() {
    super.initState();
    // Load user state from prefs on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider).loadUser(widget.prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Rebar Bender Archive',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: user.firstTimeUser
              ? const InitialScreen()
              : const MainNavigation(),
        );
      },
    );
  }
}
