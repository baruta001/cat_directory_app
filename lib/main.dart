import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detalle_gato.dart';

void main() {
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
    // Definición de colores
    const Color beigeColor = Color(0xFFC8AE81); // Beige suave
    const Color greyColor = Color(0xFF9E9E9E); // Gris secundario (Claro)
    const Color creamyWhite = Color(0xFFFDFBF7); // Blanco crema (Oscuro)

    return MaterialApp(
      title: 'Directorio de Gatos',
      themeMode: _themeMode, // Cambia dinámicamente
      // Tema Claro
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: beigeColor,
          secondary: greyColor,
          surface: Colors.white,
          onPrimary: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: beigeColor,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        primaryColor: beigeColor,
        useMaterial3: true,
      ),
      // Tema Oscuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: beigeColor,
          secondary: creamyWhite,
          surface: Color(0xFF1E1E1E),
          onPrimary: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: creamyWhite,
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: beigeColor,
        useMaterial3: true,
      ),
      home: const CatBreedsScreen(),
    );
  }
}

class CatBreedsScreen extends StatefulWidget {
  const CatBreedsScreen({super.key});

  @override
  State<CatBreedsScreen> createState() => _CatBreedsScreenState();
}

class _CatBreedsScreenState extends State<CatBreedsScreen> {
  final List<dynamic> _breeds = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<dynamic> get _filteredBreeds {
    if (_searchQuery.isEmpty) return _breeds;
    return _breeds.where((breed) {
      final String breedName = breed['breed'] ?? '';
      return breedName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchBreeds();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _searchQuery.isEmpty) {
      _fetchBreeds();
    }
  }

  Future<void> _fetchBreeds() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
      'https://catfact.ninja/breeds?limit=10&page=$_currentPage',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> newBreeds = data['data'];

        setState(() {
          _currentPage++;
          _breeds.addAll(newBreeds);
          _hasMore = data['current_page'] < data['last_page'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showError('Error al obtener las razas de gatos');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error de red: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Directorio de Gatos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              CatDirectoryApp.of(context).toggleTheme(!isDark);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por raza...',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.secondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _breeds.isEmpty && _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  )
                : _filteredBreeds.isEmpty && _searchQuery.isNotEmpty
                ? Center(
                    child: Text(
                      'No se encontraron razas',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: theme.colorScheme.primary,
                    onRefresh: () async {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _currentPage = 1;
                        _breeds.clear();
                        _hasMore = true;
                      });
                      await _fetchBreeds();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          _filteredBreeds.length +
                          (_hasMore && _searchQuery.isEmpty ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _filteredBreeds.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          );
                        }

                        final breed = _filteredBreeds[index];
                        final String breedName =
                            breed['breed'] ?? 'Desconocida';
                        final String heroTag = 'cat_avatar_$breedName';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          elevation: 1,
                          color: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 600,
                                  ),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: CatBreedDetailsScreen(
                                            breed: breed,
                                            heroTag: heroTag,
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 10.0,
                              ),
                              leading: Hero(
                                tag: heroTag,
                                child: Material(
                                  color: Colors.transparent,
                                  child: CircleAvatar(
                                    backgroundColor: theme.colorScheme.primary,
                                    radius: 26,
                                    child: Icon(
                                      Icons.pets,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.black87
                                          : theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              title: Hero(
                                tag: 'cat_title_$breedName',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    breedName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        breed['country']?.isEmpty ?? true
                                            ? 'Desconocido'
                                            : breed['country'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: theme.colorScheme.secondary.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
