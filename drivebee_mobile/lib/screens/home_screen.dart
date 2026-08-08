import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/services/vehicle_service.dart';
import '../core/services/favorite_service.dart';
import '../shared/models/vehicle_model.dart';
import '../shared/widgets/vehicle_card.dart';
import 'vehicle_details_screen.dart';
import 'my_bookings_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Vehicle>> _vehiclesFuture;
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Set<int> _favoritedVehicleIds = {};

  final List<String> _categories = ['All', 'Cars', 'SUVs', 'Vans', 'Tuks'];

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = VehicleService().fetchVehicles(category: _selectedCategory);
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await FavoriteService().fetchFavorites();
      setState(() {
        _favoritedVehicleIds = favorites.map((v) => v.id).toSet();
      });
    } catch (_) {}
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

  void _refreshVehicles() {
    setState(() {
      _vehiclesFuture = VehicleService().fetchVehicles(
        searchQuery: _searchQuery,
        category: _selectedCategory,
      );
    });
    _loadFavorites();
  }

  List<Vehicle> _filterVehicles(List<Vehicle> vehicles) {
    return vehicles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Greeting Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good morning, Pehan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.location_on, size: 16, color: AppTheme.primary),
                          SizedBox(width: 4),
                          Text(
                            'Southern Province, Sri Lanka',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // My Bookings Shortcut Button
                      IconButton(
                        icon: const Icon(Icons.book_online, color: AppTheme.textPrimary),
                        tooltip: 'My Bookings',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyBookingsScreen(),
                            ),
                          );
                        },
                      ),
                      // Notification Bell
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No new notifications')),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      // Profile Avatar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primary,
                          child: Text(
                            'P',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search & Promo Card (Charcoal Palette)
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppTheme.charcoal,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text(
                            '15% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Text(
                          'Summer Deal',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Where are you\ndriving next?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Interactive Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.white70),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                              cursorColor: AppTheme.primary,
                              decoration: const InputDecoration(
                                hintText: 'Search for perfect cars...',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.trim();
                                  _vehiclesFuture = VehicleService().fetchVehicles(
                                    searchQuery: _searchQuery,
                                    category: _selectedCategory,
                                  );
                                });
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white70, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _vehiclesFuture = VehicleService().fetchVehicles(
                                    category: _selectedCategory,
                                  );
                                });
                              },
                            ),
                          const Icon(Icons.tune, color: AppTheme.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Categories Header & Horizontal list
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = cat == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = cat;
                            _vehiclesFuture = VehicleService().fetchVehicles(
                              searchQuery: _searchQuery,
                              category: _selectedCategory,
                            );
                          });
                        },
                        selectedColor: AppTheme.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey.shade200,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Vehicle List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Rides',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppTheme.primary, size: 20),
                    onPressed: _refreshVehicles,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Vehicle List Builder
              FutureBuilder<List<Vehicle>>(
                future: _vehiclesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: CircularProgressIndicator(color: AppTheme.primary),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              snapshot.error.toString().replaceAll('Exception: ', ''),
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          'No vehicles found.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    );
                  }

                  final vehicles = _filterVehicles(snapshot.data!);

                  if (vehicles.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          'No vehicles match this category.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
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
                          ).then((_) => _refreshVehicles());
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
