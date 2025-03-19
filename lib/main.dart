import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:toastification/toastification.dart';

import 'Functions/FunctionsProduct.dart';
import 'Registery/BlocProviders.dart';
import 'auth/login.dart';
import 'localDatabase/LocalDatabaseInit.dart';
import 'views/Customer_dsiplay.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const BackdisplayScreen());
    case 'presentation':
      return MaterialPageRoute(builder: (_) => const CustomerScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabaseInit.initialize();

  debugPrint('first main');
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> secondaryDisplayMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('second main');
  runApp(const MySecondApp());
}

class MySecondApp extends StatelessWidget {
  const MySecondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: BlocProviders.providers,
        child: MaterialApp(
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle.dark)),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: generateRoute,
          initialRoute: 'presentation',
        ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: BlocProviders.providers,
        child: MaterialApp(
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle.dark)),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: generateRoute,
          initialRoute: '/',
        ));
  }
}

class BackdisplayScreen extends StatefulWidget {
  const BackdisplayScreen({super.key});

  @override
  State<BackdisplayScreen> createState() => _BackdisplayScreenState();
}

DisplayManager displayManager = DisplayManager();
List displays = [];

class _BackdisplayScreenState extends State<BackdisplayScreen> {
  @override
  void initState() {
    super.initState();
    displayManager.showSecondaryDisplay(
        displayId: 1, routerName: "presentation");
    FunctionProduct.getSavedSlideImages();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: BlocProviders.providers,
        child: ToastificationWrapper(
          child: MaterialApp(
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle.dark)),
            debugShowCheckedModeBanner: false,
            home: const LoginScreen(),
          ),
        ));
  }
}
