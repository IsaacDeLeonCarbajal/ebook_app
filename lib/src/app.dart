import 'package:ebook_app/src/book/book_detail.dart';
import 'package:ebook_app/src/category/category_detail.dart';
import 'package:ebook_app/src/home/container.dart';
import 'package:ebook_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          routerConfig: GoRouter(
            routes: <GoRoute>[
              GoRoute(
                  path: '/',
                  name: 'home',
                  builder: (BuildContext context, GoRouterState state) {
                    return const Home();
                  },
                  routes: [
                    // Books
                    GoRoute(
                      path: 'books/create',
                      name: 'books.create',
                      builder: (BuildContext context, GoRouterState state) => const BookDetail(bookId: null),
                    ),
                    GoRoute(
                      path: 'books/:bookId',
                      name: 'books.details',
                      builder: (BuildContext context, GoRouterState state) => BookDetail(bookId: state.pathParameters['bookId']),
                    ),
                    // Categories
                    GoRoute(
                      path: 'categories/create',
                      name: 'categories.create',
                      builder: (BuildContext context, GoRouterState state) => const CategoryDetail(categoryId: null),
                    ),
                    GoRoute(
                      path: 'categories/:categoryId',
                      name: 'categories.details',
                      builder: (BuildContext context, GoRouterState state) => CategoryDetail(categoryId: state.pathParameters['categoryId']),
                    ),
                    // Settings
                    GoRoute(
                      path: 'settings',
                      name: 'settings',
                      builder: (BuildContext context, GoRouterState state) => SettingsView(controller: settingsController),
                    ),
                  ]),
            ],
          ),
        );
      },
    );
  }
}
