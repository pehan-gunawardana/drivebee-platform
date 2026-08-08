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
  List<Vehicle>? _favoritesList;
  Set<int> _favoritedVehicleIds = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final favorites = await FavoriteService().fetchFavorites();
      setState(() {
        _favoritesList = favorites;
        _favoritedVehicleIds = favorites.map((v) => v.id).toSet();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
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
          // Immediately remove the vehicle from the local list to update UI instantly
          _favoritesList?.removeWhere((v) => v.id == vehicleId);
        }
      });
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
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFavorites,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_favoritesList == null || _favoritesList!.isEmpty) {
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      itemCount: _favoritesList!.length,
      itemBuilder: (context, index) {
        final vehicle = _favoritesList![index];

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
              _loadFavorites();
            });
          },
        );
      },
    );
  }
}
