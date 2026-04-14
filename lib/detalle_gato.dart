import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CatBreedDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> breed;
  final String heroTag;

  const CatBreedDetailsScreen({
    super.key,
    required this.breed,
    required this.heroTag,
  });

  @override
  State<CatBreedDetailsScreen> createState() => _CatBreedDetailsScreenState();
}

class _CatBreedDetailsScreenState extends State<CatBreedDetailsScreen> {
  String? _catFact;
  bool _isLoadingFact = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomFact();
  }

  Future<void> _fetchRandomFact() async {
    final url = Uri.parse('https://catfact.ninja/fact');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _catFact = data['fact'];
            _isLoadingFact = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _catFact = 'Error al cargar el dato curioso.';
            _isLoadingFact = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _catFact = 'Error de conexión.';
          _isLoadingFact = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final String breedName = widget.breed['breed'] ?? 'Desconocida';

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
                    tag: widget.heroTag,
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
                    widget.breed['country'],
                  ),
                  _buildInfoRow(
                    context,
                    Icons.history,
                    'Origen:',
                    widget.breed['origin'],
                  ),
                  _buildInfoRow(
                    context,
                    Icons.inventory_2,
                    'Pelaje (Coat):',
                    widget.breed['coat'],
                  ),
                  _buildInfoRow(
                    context,
                    Icons.palette,
                    'Patrón:',
                    widget.breed['pattern'],
                  ),
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
                    child: _isLoadingFact
                        ? Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Text(
                            _catFact ?? 'Dato curioso no disponible',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: theme.textTheme.bodyLarge?.color,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
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
