import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_evydhence/components/touch_and_mouse_scroll_behaviour.dart';
import 'package:project_evydhence/injection_container.dart';
import 'package:project_evydhence/provider/clients.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/views/forms/client_register_form.dart';
import 'package:project_evydhence/views/forms/vehicle_register_form.dart';
import 'package:project_evydhence/views/login_page.dart';
import 'package:project_evydhence/views/vehicle_list_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await InjectionContainer.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Clients(),
        )
      ],
      child: MaterialApp(
          title: 'Evydhence',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: {
            AppRoutes.home: (_) => const LoginPage(),
            AppRoutes.clientForm: (_) => const ClientRegisterForm(),
            AppRoutes.vehiclePage: (_) => const VehicleRegisterForm()
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
          scrollBehavior: TouchAndMouseScrollBehavior()),
    );
  }
}
