import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CatDirectoryApp());
}

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de colores
    const Color beigeColor = Color(0xFFEEDDAA); // Beige suave
    const Color greyColor = Color(0xFF9E9E9E); // Gris secundario (Claro)
    const Color creamyWhite = Color(0xFFFDFBF7); // Blanco crema (Oscuro)

    return MaterialApp(
      title: 'Directorio de Gatos',
      themeMode: ThemeMode.system, // Cambia automáticamente según el sistema
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
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchBreeds();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Razas de Gatos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _breeds.isEmpty && _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : RefreshIndicator(
              color: theme.colorScheme.primary,
              onRefresh: () async {
                setState(() {
                  _currentPage = 1;
                  _breeds.clear();
                  _hasMore = true;
                });
                await _fetchBreeds();
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _breeds.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _breeds.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  final breed = _breeds[index];
                  final String breedName = breed['breed'] ?? 'Desconocida';
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
                                    : theme.colorScheme.secondary,
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
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class CatBreedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> breed;
  final String heroTag;

  const CatBreedDetailsScreen({
    super.key,
    required this.breed,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final String breedName = breed['breed'] ?? 'Desconocida';

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Raza')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: heroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        radius: 60,
                        child: Icon(
                          Icons.pets,
                          size: 60,
                          color: isDark
                              ? Colors.black87
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Hero(
                    tag: 'cat_title_$breedName',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        breedName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información General',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    context,
                    Icons.location_on,
                    'País de Origen:',
                    breed['country'],
                  ),
                  _buildInfoRow(
                    context,
                    Icons.history,
                    'Origen:',
                    breed['origin'],
                  ),
                  _buildInfoRow(
                    context,
                    Icons.inventory_2,
                    'Pelaje (Coat):',
                    breed['coat'],
                  ),
                  _buildInfoRow(
                    context,
                    Icons.palette,
                    'Patrón:',
                    breed['pattern'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    final theme = Theme.of(context);
    final displayValue = (value == null || value.isEmpty)
        ? 'No disponible'
        : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.secondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
