import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/services/favorite_service.dart';
import '../shared/models/vehicle_model.dart';
import '../shared/widgets/vehicle_card.dart';
import 'vehicle_details_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late Future<List<Vehicle>> _favoritesFuture;
  Set<int> _favoritedVehicleIds = {};

  @override
  void initState() {
    super.initState();
    _favoritesFuture = FavoriteService().fetchFavorites();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await FavoriteService().fetchFavorites();
      setState(() {
        _favoritedVehicleIds = favorites.map((v) => v.id).toSet();
      });
    } catch (_) {}
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = FavoriteService().fetchFavorites();
    });
  }

  Future<void> _toggleFavorite(int vehicleId) async {
    try {
      final isAdded = await FavoriteService().toggleFavorite(vehicleId);
      if (!mounted) return;
      setState(() {
        if (isAdded) {
          _favoritedVehicleIds.add(vehicleId);
        } else {
          _favoritedVehicleIds.remove(vehicleId);
        }
      });
      _refreshFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdded ? 'Added to Favorites' : 'Removed from Favorites'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primary),
            onPressed: _refreshFavorites,
          ),
        ],
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 20),
                    const Text(
                      'No Favorites Yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap the heart icon on any vehicle to add it to your wishlist.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final vehicle = favorites[index];

              return VehicleCard(
                vehicle: vehicle,
                isFavorite: _favoritedVehicleIds.contains(vehicle.id),
                onFavoriteToggle: () => _toggleFavorite(vehicle.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailsScreen(vehicle: vehicle),
                    ),
                  ).then((_) {
                    _refreshFavorites();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
