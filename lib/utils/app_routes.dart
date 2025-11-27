import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/contest_play_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/error_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String contestPlay = '/contest-play';
  static const String leaderboard = '/leaderboard';
  static const String notifications = '/notifications';
  static const String error = '/error';
  static const String networkError = '/network-error';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => SplashScreen(),
    dashboard: (context) => DashboardScreen(),
    contestPlay: (context) => ContestPlayScreen(),
    leaderboard: (context) => LeaderboardScreen(),
    notifications: (context) => NotificationsScreen(),
    error: (context) => ErrorScreen(),
    networkError: (context) => NetworkErrorScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(SplashScreen(), settings);
      case dashboard:
        return _buildRoute(DashboardScreen(), settings);
      case contestPlay:
        return _buildRoute(ContestPlayScreen(), settings);
      case leaderboard:
        return _buildRoute(LeaderboardScreen(), settings);
      case notifications:
        return _buildRoute(NotificationsScreen(), settings);
      case error:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          ErrorScreen(
            errorMessage: args?['message'],
            onRetry: args?['onRetry'],
            showRetryButton: args?['showRetryButton'] ?? true,
          ),
          settings,
        );
      case networkError:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          NetworkErrorScreen(
            onRetry: args?['onRetry'],
          ),
          settings,
        );
      default:
        return _buildRoute(
          ErrorScreen(
            errorMessage: 'Page not found: ${settings.name}',
            showRetryButton: false,
          ),
          settings,
        );
    }
  }

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  static void navigateToError(BuildContext context, {
    String? message,
    VoidCallback? onRetry,
    bool showRetryButton = true,
  }) {
    Navigator.pushNamed(
      context,
      error,
      arguments: {
        'message': message,
        'onRetry': onRetry,
        'showRetryButton': showRetryButton,
      },
    );
  }

  static void navigateToNetworkError(BuildContext context, {
    VoidCallback? onRetry,
  }) {
    Navigator.pushNamed(
      context,
      networkError,
      arguments: {
        'onRetry': onRetry,
      },
    );
  }

  static void navigateAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  static void navigateWithReplacement(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}