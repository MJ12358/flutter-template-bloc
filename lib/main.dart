import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_template/bootstrap.dart';
import 'package:flutter_template/injector.dart';
import 'package:flutter_template/presentation/extensions/localization_extension.dart';
import 'package:flutter_template/presentation/ui/app/app.dart';
import 'package:flutter_themez/flutter_themez.dart';
import 'package:flutter_widgetz/flutter_widgetz.dart';

void main() async {
  await Injector.init();
  await Injector.sl<Bootstrap>().call(_Main.new);
}

class _Main extends StatelessWidget {
  _Main();

  // Storing this here prevents this issue:
  // https://stackoverflow.com/questions/60927958/flutter-being-sent-back-to-initial-page-after-hot-reload
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => Injector.sl<AppBloc>()..add(const AppInitialized()),
      child: _MainView(_navigatorKey),
    );
  }
}

class _MainView extends StatelessWidget {
  const _MainView(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (AppState previous, AppState current) {
        return previous.status == AppStatus.initializing &&
            current.status != AppStatus.initializing;
      },
      listener: (BuildContext context, AppState state) {
        FlutterNativeSplash.remove();
      },
      buildWhen: (AppState previous, AppState current) {
        return previous.settings != current.settings ||
            previous.status == AppStatus.initializing &&
                current.status != AppStatus.initializing;
      },
      builder: (BuildContext context, AppState state) {
        if (state.status == AppStatus.initializing) {
          return const CustomProgressIndicator.circular();
        }

        final FlutterThemez theme = FlutterThemez(
          primaryColor: state.settings.primaryColor,
          secondaryColor: state.settings.secondaryColor,
        );

        return MaterialApp(
          navigatorKey: _navigatorKey,
          color: theme.primaryColor,
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: state.settings.showMaterialGrid,
          home: _getInitialView(state),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateTitle: (BuildContext context) {
            return context.l10n.appTitle;
          },
          restorationScopeId: 'app',
          showPerformanceOverlay: state.settings.showPerformanceOverlay,
          showSemanticsDebugger: state.settings.showSemanticOverlay,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: state.settings.darkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }

  Widget _getInitialView(AppState state) {
    switch (state.status) {
      case AppStatus.initializing:
      case AppStatus.loading:
        return const CustomProgressIndicator.circular();
      default:
        return const AppView();
    }
  }
}
