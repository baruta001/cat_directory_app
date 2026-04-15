import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cat_breed.dart';
import '../blocs/cat_breeds_cubit.dart';
import '../main.dart'; // Para ThemeToggle
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CatBreedsCubit>().fetchBreeds();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<CatBreedsCubit>().state;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        _searchQuery.isEmpty &&
        state.errorMessage == null &&
        !state.isLoadingMore &&
        !state.hasReachedMax) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CatBreedsCubit>().fetchBreeds();
        }
      });
    }
  }

  List<CatBreed> _getFilteredBreeds(List<CatBreed> breeds) {
    if (_searchQuery.isEmpty) return breeds;
    return breeds.where((breed) {
      return breed.breed.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio de Gatos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => CatDirectoryApp.of(context).toggleTheme(!isDark),
          ),
        ],
      ),
      body: BlocConsumer<CatBreedsCubit, CatBreedsState>(
        listener: (context, state) {
          // Ya no mostramos SnackBar aquí para errores de paginación
        },
        builder: (context, state) {
          final filteredBreeds = _getFilteredBreeds(state.breeds);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por raza...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.secondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
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
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              Expanded(
                child: (state.isLoading && state.breeds.isEmpty || (state.breeds.isEmpty && state.errorMessage == null))
                    ? _buildSkeletonList(theme)
                    : filteredBreeds.isEmpty && _searchQuery.isNotEmpty
                        ? Center(
                            child: Text(
                              'No se encontraron razas',
                              style: TextStyle(color: theme.colorScheme.secondary, fontSize: 16),
                            ),
                          )
                        : RefreshIndicator(
                            color: theme.colorScheme.primary,
                            onRefresh: () async {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                              await context.read<CatBreedsCubit>().refresh();
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredBreeds.length +
                                  ((state.isLoadingMore || state.errorMessage != null) && _searchQuery.isEmpty ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == filteredBreeds.length) {
                                  if (state.errorMessage != null) {
                                    return _buildErrorRetryCard(theme, state.errorMessage!);
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  );
                                }

                                final breed = filteredBreeds[index];
                                final String heroTag = 'cat_avatar_${breed.breed}';

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                  elevation: 1,
                                  color: theme.colorScheme.surface,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 600),
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: DetailsScreen(breed: breed, heroTag: heroTag),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                      leading: Hero(
                                        tag: heroTag,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: CircleAvatar(
                                            backgroundColor: theme.colorScheme.primary,
                                            radius: 26,
                                            child: Icon(
                                              Icons.pets,
                                              color: isDark ? Colors.black87 : theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Hero(
                                        tag: 'cat_title_${breed.breed}',
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            breed.breed,
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
                                            Icon(Icons.location_on, size: 16, color: theme.colorScheme.secondary),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                breed.country.isEmpty ? 'Desconocido' : breed.country,
                                                style: TextStyle(fontSize: 14, color: theme.colorScheme.secondary),
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorRetryCard(ThemeData theme, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 44, color: theme.colorScheme.error),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.error.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.read<CatBreedsCubit>().fetchBreeds(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar cargar más'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList(ThemeData theme) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
