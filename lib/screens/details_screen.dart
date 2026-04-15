import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cat_breed.dart';
import '../blocs/cat_fact_cubit.dart';
import '../repositories/cat_repository.dart';

class DetailsScreen extends StatelessWidget {
  final CatBreed breed;
  final String heroTag;

  const DetailsScreen({
    super.key,
    required this.breed,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatFactCubit(context.read<CatRepository>())..fetchRandomFact(),
      child: _DetailsView(breed: breed, heroTag: heroTag),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final CatBreed breed;
  final String heroTag;

  const _DetailsView({
    required this.breed,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final String breedName = breed.breed;

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
                          color: isDark ? Colors.black87 : theme.colorScheme.secondary,
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
                  _buildInfoRow(context, Icons.location_on, 'País de Origen:', breed.country),
                  _buildInfoRow(context, Icons.history, 'Origen:', breed.origin),
                  _buildInfoRow(context, Icons.inventory_2, 'Pelaje (Coat):', breed.coat),
                  _buildInfoRow(context, Icons.palette, 'Patrón:', breed.pattern),
                  const SizedBox(height: 30),
                  Text(
                    'Dato Curioso Aleatorio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: BlocBuilder<CatFactCubit, CatFactState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => const SizedBox.shrink(),
                          loading: () => Center(
                            child: CircularProgressIndicator(color: theme.colorScheme.primary),
                          ),
                          loaded: (fact) => Text(
                            fact,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: theme.textTheme.bodyLarge?.color,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          error: (message) => Text(
                            message,
                            style: TextStyle(color: theme.colorScheme.error),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
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
    final displayValue = (value == null || value.isEmpty) ? 'No disponible' : value;

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
