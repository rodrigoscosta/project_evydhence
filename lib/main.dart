import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_evydhence/components/touch_and_mouse_scroll_behaviour.dart';
import 'package:project_evydhence/injection_container.dart';
import 'package:project_evydhence/provider/clients.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/views/client_list_page.dart';
import 'package:project_evydhence/views/dashboard_page.dart';
import 'package:project_evydhence/views/forms/client_register_form.dart';
import 'package:project_evydhence/views/forms/scheduling_register_form.dart';
import 'package:project_evydhence/views/forms/vehicle_register_form.dart';
import 'package:project_evydhence/views/home_page.dart';
import 'package:project_evydhence/views/login_page.dart';
import 'package:project_evydhence/views/scheduling_list_page.dart';
import 'package:project_evydhence/views/vehicle_list_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.instance.init();

  // Recupera o tema salvo
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  // Alterna o modo de tema e salva a preferência
  void _toggleTheme(bool isDark) async {
    setState(() {
      _isDarkMode = isDark;
    });
    // Salva a preferência no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Clients(),
        ),
        ChangeNotifierProvider(
          create: (context) => ZoomProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Evydhence',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        routes: {
          AppRoutes.home: (_) => LoginPage(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.homePage: (_) => HomePage(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.dashboardPage: (_) => DashboardPage(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.clientPage: (_) => ClientListPage(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.clientForm: (_) => ClientRegisterForm(
                isDarkMode: _isDarkMode,
              ),
          AppRoutes.vehiclePage: (_) => VehicleListPage(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.vehicleForm: (_) => VehicleRegisterForm(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.schedulePage: (_) => SchedulingListPage(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
          AppRoutes.scheduleForm: (_) => SchedulingRegisterForm(
                isDarkMode: _isDarkMode,
                onThemeChanged: _toggleTheme,
              ),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('pt', 'BR'),
        ],
        debugShowCheckedModeBanner: false,
        scrollBehavior: TouchAndMouseScrollBehavior(),
      ),
    );
  }
}
