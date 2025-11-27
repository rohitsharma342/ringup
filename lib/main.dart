import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/contest_play_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/error_screen.dart';
import 'services/data_service.dart';
import 'utils/app_colors.dart';
import 'utils/app_routes.dart';
import 'utils/error_handler.dart';

void main() {
  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    ErrorHandler.handleError(details.exception, details.stack);
    FlutterError.presentError(details);
  };

  // Handle errors outside of Flutter framework
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    ErrorHandler.handleError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataService()),
      ],
      child: MaterialApp(
        title: 'RingUp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        builder: (context, widget) {
          // Global error boundary
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return ErrorHandler.buildErrorWidget(errorDetails);
          };
          
          return widget ?? Container();
        },
      ),
    );
  }
}