import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/cat_repository.dart';
import 'blocs/cat_breeds_cubit.dart';
import 'screens/home_screen.dart';
import 'core/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CatDirectoryApp());
}

class CatDirectoryApp extends StatefulWidget {
  const CatDirectoryApp({super.key});

  static _CatDirectoryAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_CatDirectoryAppState>()!;

  @override
  State<CatDirectoryApp> createState() => _CatDirectoryAppState();
}

class _CatDirectoryAppState extends State<CatDirectoryApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => CatRepository(),
      child: BlocProvider(
        create: (context) => CatBreedsCubit(context.read<CatRepository>()),
        child: MaterialApp(
          title: 'Directorio de Gatos',
          themeMode: _themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: AppColors.beigeColor,
              secondary: AppColors.greyColor,
              surface: AppColors.lightSurface,
              onPrimary: AppColors.lightOnPrimary,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.beigeColor,
              foregroundColor: AppColors.lightOnPrimary,
              elevation: 0,
            ),
            scaffoldBackgroundColor: AppColors.lightScaffold,
            primaryColor: AppColors.beigeColor,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.beigeColor,
              secondary: AppColors.creamyWhite,
              surface: AppColors.darkSurface,
              onPrimary: AppColors.darkOnPrimary,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkSurface,
              foregroundColor: AppColors.creamyWhite,
              elevation: 0,
            ),
            scaffoldBackgroundColor: AppColors.darkScaffold,
            primaryColor: AppColors.beigeColor,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
