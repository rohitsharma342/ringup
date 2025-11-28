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
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.surfaceYellow,
            background: AppColors.background,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(
              color: AppColors.textPrimary,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              elevation: 2,
              shadowColor: AppColors.primaryDark.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          cardTheme: CardTheme(
            color: AppColors.cardBackground,
            elevation: 2,
            shadowColor: AppColors.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textPrimary,
            elevation: 4,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.cardBackground,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            elevation: 8,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surfaceYellow,
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