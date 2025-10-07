import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// To run this app:
// 1. Make sure you have Flutter installed.
// 2. Create a new Flutter project: `flutter create real_estate_app`
// 3. Replace the contents of `lib/main.dart` with this code.
// 4. Add dependencies to your `pubspec.yaml` file:
//
// dependencies:
//   flutter:
//     sdk: flutter
//   intl: ^0.19.0
//   google_fonts: ^6.2.1
//   cupertino_icons: ^1.0.2
//
// 5. Run `flutter pub get` in your terminal.
// 6. Run the app: `flutter run`

void main() {
  runApp(const MyApp());
}

// --- DATA MODELS ---
enum PropertyType { House, Apartment, Condo, Land, Any }

class Property {
  final int id;
  final String title;
  final String image;
  final String address;
  final double price;
  final int bedrooms;
  final double bathrooms;
  final int sqft;
  final PropertyType type;
  bool isFavorite;

  Property({
    required this.image,
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.sqft,
    required this.type,
    this.isFavorite = false,
  });
}

// --- MOCK DATA ---
final List<Property> initialProperties = [
  Property(
    id: 1,
    title: 'Modern Downtown Loft',
    address: '123 Main St, Anytown, USA',
    price: 650000,
    bedrooms: 2,
    bathrooms: 2,
    sqft: 1200,
    type: PropertyType.Apartment,
    isFavorite: false,
    image:
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/222501658.jpg?k=83eb2464d57f058b3aa1224977753e21308675adf29ee10410a13e79dd14be55&o=&hp=1',
  ),
  Property(
    id: 2,
    title: 'Spacious Suburban Home',
    address: '456 Oak Ave, Suburbia, USA',
    price: 875000,
    bedrooms: 4,
    bathrooms: 3,
    sqft: 2800,
    type: PropertyType.House,
    isFavorite: true,
    image:
        'https://cdn10.bostonmagazine.com/wp-content/uploads/sites/2/2020/04/Boston-Real-Estate-Media-0001-scaled.jpg',
  ),
  Property(
    id: 3,
    title: 'Cozy Beachfront Condo',
    address: '789 Ocean Blvd, Beachtown, USA',
    price: 1200000,
    bedrooms: 3,
    bathrooms: 2.5,
    sqft: 1800,
    type: PropertyType.Condo,
    isFavorite: false,
    image:
        'https://panamacitybeachrentalbyowner.com/wp-content/uploads/2025/04/IMG_9410.jpeg',
  ),
  Property(
    id: 4,
    title: 'Rustic Countryside Farmhouse',
    address: '101 Country Rd, Farmville, USA',
    price: 720000,
    bedrooms: 5,
    bathrooms: 4,
    sqft: 3500,
    type: PropertyType.House,
    isFavorite: false,
    image:
        'https://st.hzcdn.com/simgs/pictures/exteriors/rustic-farm-house-laura-culpepper-aia-img~f9d18eee054afdce_4-9654-1-b9ab94d.jpg',
  ),
  Property(
    id: 5,
    title: 'Luxury Penthouse Suite',
    address: '210 Sky High Rd, Metropolis, USA',
    price: 2500000,
    bedrooms: 3,
    bathrooms: 4,
    sqft: 3200,
    type: PropertyType.Apartment,
    isFavorite: true,
    image:
        'https://www.thepostoakhotel.com/accommodations/penthouse/images/penthouse-01.jpeg',
  ),
  Property(
    id: 6,
    title: 'Charming Victorian Home',
    address: '311 History Ln, Old Town, USA',
    price: 950000,
    bedrooms: 4,
    bathrooms: 3,
    sqft: 2600,
    type: PropertyType.House,
    isFavorite: false,
    image: 'https://cdn.mos.cms.futurecdn.net/nMJxBvqaVtkbutfTxd6pJc.jpg',
  ),
  Property(
    id: 7,
    title: 'Prime Development Land',
    address: '816 Future Way, Growth City, USA',
    price: 1500000,
    bedrooms: 0,
    bathrooms: 0,
    sqft: 435600,
    type: PropertyType.Land,
    isFavorite: false,
    image:
        'https://assets.marknetalliance.com/projects/62059/photos/img_1652195741632486276.jpg',
  ),
  Property(
    id: 8,
    title: 'Studio in the Arts District',
    address: '917 Canvas Ave, Artsburg, USA',
    price: 420000,
    bedrooms: 1,
    bathrooms: 1,
    sqft: 750,
    type: PropertyType.Apartment,
    isFavorite: false,
    image:
        'https://photos.zillowstatic.com/fp/9d63b992c325042e33e729a580bed9aa-p_e.jpg',
  ),
];

class PriceRange {
  final String label;
  final double min;
  final double max;
  const PriceRange(this.label, this.min, this.max);
}

const List<PriceRange> priceRanges = [
  PriceRange('Any Price', 0, double.infinity),
  PriceRange('< \$500k', 0, 500000),
  PriceRange('\$500k - \$1M', 500000, 1000000),
  PriceRange('\$1M - \$2M', 1000000, 2000000),
  PriceRange('> \$2M', 2000000, double.infinity),
];

const List<String> bedBathOptions = ['Any', '1+', '2+', '3+', '4+', '5+'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Dwellings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Property> _properties;

  @override
  void initState() {
    super.initState();
    _properties = List.from(initialProperties);
  }

  void _toggleFavorite(int id) {
    setState(() {
      final property = _properties.firstWhere((p) => p.id == id);
      property.isFavorite = !property.isFavorite;
    });
  }

  late final List<Widget> _pages = <Widget>[
    RealEstateHomePage(
      properties: _properties,
      onToggleFavorite: _toggleFavorite,
    ),
    FavoritesScreen(
      favoriteProperties: _properties.where((p) => p.isFavorite).toList(),
      onToggleFavorite: _toggleFavorite,
    ),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.home_work_rounded, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              ['DreamDwellings', 'Your Favorites', 'Profile'][_selectedIndex],
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RealEstateHomePage extends StatefulWidget {
  final List<Property> properties;
  final Function(int) onToggleFavorite;

  const RealEstateHomePage({
    super.key,
    required this.properties,
    required this.onToggleFavorite,
  });

  @override
  State<RealEstateHomePage> createState() => _RealEstateHomePageState();
}

class _RealEstateHomePageState extends State<RealEstateHomePage> {
  final TextEditingController _searchController = TextEditingController();
  PropertyType _selectedType = PropertyType.Any;
  PriceRange _selectedPriceRange = priceRanges[0];
  String _selectedBedrooms = bedBathOptions[0];
  String _selectedBathrooms = bedBathOptions[0];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = PropertyType.Any;
      _selectedPriceRange = priceRanges[0];
      _selectedBedrooms = bedBathOptions[0];
      _selectedBathrooms = bedBathOptions[0];
    });
  }

  List<Property> get _filteredProperties {
    return widget.properties.where((p) {
      final searchQuery = _searchController.text.toLowerCase();
      final searchMatch =
          searchQuery.isEmpty ||
          p.title.toLowerCase().contains(searchQuery) ||
          p.address.toLowerCase().contains(searchQuery);

      final typeMatch =
          _selectedType == PropertyType.Any || p.type == _selectedType;
      final priceMatch =
          p.price >= _selectedPriceRange.min &&
          p.price <= _selectedPriceRange.max;
      final bedsMatch =
          _selectedBedrooms == 'Any' ||
          p.bedrooms >= int.parse(_selectedBedrooms.replaceAll('+', ''));
      final bathsMatch =
          _selectedBathrooms == 'Any' ||
          p.bathrooms >= int.parse(_selectedBathrooms.replaceAll('+', ''));

      return searchMatch && typeMatch && priceMatch && bedsMatch && bathsMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildFilterSection(),
        const SizedBox(height: 24),
        _buildResults(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Find Your Perfect Home',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Search through thousands of listings to find the property that\'s right for you.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'e.g. "Downtown Loft" or "Anytown"',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildDropdown(
                  'Property Type',
                  _selectedType,
                  PropertyType.values,
                  (PropertyType? val) {
                    if (val != null) setState(() => _selectedType = val);
                  },
                ),
                _buildDropdown(
                  'Price Range',
                  _selectedPriceRange,
                  priceRanges,
                  (PriceRange? val) {
                    if (val != null) setState(() => _selectedPriceRange = val);
                  },
                ),
                _buildDropdown('Beds', _selectedBedrooms, bedBathOptions, (
                  String? val,
                ) {
                  if (val != null) setState(() => _selectedBedrooms = val);
                }),
                _buildDropdown('Baths', _selectedBathrooms, bedBathOptions, (
                  String? val,
                ) {
                  if (val != null) setState(() => _selectedBathrooms = val);
                }),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetFilters,
                child: const Text('Reset Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T value,
    List<T> items,
    ValueChanged<T?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: false,
              items: items.map((T item) {
                String text;
                if (item is PropertyType) {
                  text = item.name;
                } else if (item is PriceRange) {
                  text = item.label;
                } else {
                  text = item.toString();
                }
                return DropdownMenuItem<T>(value: item, child: Text(text));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final results = _filteredProperties;
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                'No Properties Found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search filters.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Clear All Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Showing ${results.length} Results',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 3 / 3.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return PropertyCard(
              property: results[index],
              onToggleFavorite: widget.onToggleFavorite,
            );
          },
        ),
      ],
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Property> favoriteProperties;
  final Function(int) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favoriteProperties,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteProperties.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No Favorites Yet',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on a listing to save it here.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteProperties.length,
      itemBuilder: (context, index) {
        final property = favoriteProperties[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: PropertyCard(
            property: property,
            onToggleFavorite: onToggleFavorite,
          ),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen', style: TextStyle(fontSize: 24)),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  final Function(int) onToggleFavorite;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.simpleCurrency(decimalDigits: 0);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailScreen(
              property: property,
              onToggleFavorite: onToggleFavorite,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(property.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onToggleFavorite(property.id),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          property.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.pink,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'FOR SALE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property.address,
                                style: TextStyle(color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          priceFormat.format(property.price),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfo(Icons.bed, '${property.bedrooms} Beds'),
                            _buildInfo(
                              Icons.bathtub,
                              '${property.bathrooms} Baths',
                            ),
                            _buildInfo(
                              Icons.square_foot,
                              '${property.sqft} sqft',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade300),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  final Function(int) onToggleFavorite;

  const PropertyDetailScreen({
    super.key,
    required this.property,
    required this.onToggleFavorite,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.property.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.property.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(widget.property.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  widget.onToggleFavorite(widget.property.id);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priceFormat.format(widget.property.price),
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.property.address,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat(
                            Icons.bed,
                            '${widget.property.bedrooms}',
                            'Beds',
                          ),
                          _buildStat(
                            Icons.bathtub,
                            '${widget.property.bathrooms}',
                            'Baths',
                          ),
                          _buildStat(
                            Icons.square_foot,
                            '${widget.property.sqft}',
                            'sqft',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.property.address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Book a Tour', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.apartment, size: 80, color: Colors.indigo[600]),
                const SizedBox(height: 16),
                const Text(
                  'Dream Dwellings',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find Your Future Home',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingStep {
  final IconData icon;
  final String title;
  final String description;

  OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      icon: Icons.search,
      title: 'Discover Your Dream Home',
      description:
          'Easily search and filter through thousands of verified property listings to find the perfect match for you.',
    ),
    OnboardingStep(
      icon: Icons.vrpano,
      title: 'Immersive Virtual Tours',
      description:
          'Explore properties from the comfort of your home with our high-quality 360° virtual tours.',
    ),
    OnboardingStep(
      icon: Icons.people,
      title: 'Connect with Top Agents',
      description:
          'Get expert advice and assistance by connecting directly with our network of professional real estate agents.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to Dream Dwellings!'),
        content: const Text('You have completed the onboarding.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (_) => MainScreen()),
              );
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo[100],
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(24),
            child: Icon(step.icon, size: 64, color: Colors.indigo[600]),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        bool isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 24 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: isActive ? Colors.indigo[600] : Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: _currentPage < _steps.length - 1
                  ? TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.indigo[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_steps[index]);
                },
              ),
            ),
            _buildDots(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _previousPage,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: _currentPage == 0
                            ? Colors.grey
                            : Colors.indigo[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[600],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      _currentPage == _steps.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
