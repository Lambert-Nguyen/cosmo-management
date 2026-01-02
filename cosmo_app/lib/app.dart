/// App widget for Cosmo Management
///
/// Root widget that sets up theming and routing.
library;

import 'package:flutter/material.dart';

import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

/// Root application widget
///
/// Configures:
/// - Material app with router
/// - Light and dark themes
/// - Localization (future)
class CosmoApp extends StatefulWidget {
  final AuthService authService;

  const CosmoApp({
    super.key,
    required this.authService,
  });

  @override
  State<CosmoApp> createState() => _CosmoAppState();
}

class _CosmoAppState extends State<CosmoApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(authService: widget.authService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cosmo Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.router,
    );
  }
}
