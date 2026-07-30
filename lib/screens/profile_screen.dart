import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_session.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for creating a new post
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _farmerController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Vegetables';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categoryOptions = [
    'Vegetables',
    'Fruits',
    'Grains',
    'Organic',
    'Herbs',
  ];

  @override
  void initState() {
    super.initState();
    // Exactly 2 tabs: 0 -> Save, 1 -> Your posts
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    UserSession().addListener(_onSessionUpdate);
  }

  void _onSessionUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    UserSession().removeListener(_onSessionUpdate);
    _tabController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _farmerController.dispose();
    _originController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Pick an image from gallery for a new product upload
  Future<void> _pickImage(StateSetter setModalState) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setModalState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Show bottom sheet form to upload a new product
  void _showUploadProductSheet() {
    final currentUser = UserSession().currentUser;
    _farmerController.text = currentUser?.name ?? 'Pak Tani';
    _originController.text = 'JAKARTA';
    _stockController.text = '10.0 kg';
    _selectedImage = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sell Your Harvest',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF233B2B),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Image Picker Card
                    GestureDetector(
                      onTap: () => _pickImage(setModalState),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(_selectedImage!, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_a_photo_outlined, size: 36, color: Color(0xFF233B2B)),
                                  SizedBox(height: 6),
                                  Text(
                                    'Upload Product Photo',
                                    style: TextStyle(
                                      color: Color(0xFF233B2B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Tap to select from gallery',
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Title Input
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Product Title',
                        hintText: 'e.g., Organic Red Tomatoes',
                        prefixIcon: const Icon(Icons.shopping_bag_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price & Category Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price (k Rp)',
                              hintText: '15',
                              prefixIcon: const Icon(Icons.payments_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                            ),
                            items: _categoryOptions.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Origin & Available Stock Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _originController,
                            decoration: InputDecoration(
                              labelText: 'Origin Location',
                              hintText: 'BOGOR',
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _stockController,
                            decoration: InputDecoration(
                              labelText: 'Stock',
                              hintText: '50.0 kg',
                              prefixIcon: const Icon(Icons.inventory_2_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description Input
                    TextField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        hintText: 'Describe freshness, harvest date, details...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Post Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF233B2B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_titleController.text.trim().isEmpty || _priceController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill in title and price.')),
                            );
                            return;
                          }

                          final double priceVal = double.tryParse(_priceController.text) ?? 10;

                          final newProduct = {
                            'title': _titleController.text.trim(),
                            'price': priceVal,
                            'category': _selectedCategory,
                            'subCategory': 'Fresh Harvest',
                            'farmer': _farmerController.text.trim(),
                            'origin': _originController.text.trim().toUpperCase(),
                            'stock': _stockController.text.trim(),
                            'description': _descriptionController.text.trim().isEmpty
                                ? 'Fresh harvest directly from farm.'
                                : _descriptionController.text.trim(),
                            'imageFile': _selectedImage,
                            'imageUrl': _selectedImage == null
                                ? 'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=600'
                                : '',
                          };

                          UserSession().addPost(newProduct);

                          // Clear Form
                          _titleController.clear();
                          _priceController.clear();
                          _descriptionController.clear();
                          _selectedImage = null;

                          Navigator.pop(context);
                          _tabController.animateTo(1); // Jump to "Your posts" tab
                        },
                        child: const Text(
                          'Publish Product',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Delete product confirmation dialog
  void _confirmDeleteDialog({required String title, required VoidCallback onDelete}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to remove "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession().currentUser;
    final savedItems = user?.savedItems ?? [];
    final userPosts = user?.userPosts ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7EC),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF233B2B),
        onPressed: _showUploadProductSheet,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. USER PROFILE HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFF233B2B),
                      backgroundImage: NetworkImage(
                        user?.avatarUrl ?? 'https://i.pravatar.cc/300?img=12',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Farmer User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'user@kebunku.com',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F0E3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Auth: ${user?.authType.toUpperCase() ?? 'GOOGLE'}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF233B2B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      tooltip: 'Logout',
                      onPressed: () {
                        UserSession().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 2. TAB SELECTION BAR (SAVE & YOUR POSTS ONLY)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicator: BoxDecoration(
                  color: const Color(0xFF233B2B),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: const [
                  Tab(text: 'Save'),
                  Tab(text: 'Your posts'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 3. TAB VIEWS CONTENT
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // TAB 1: SAVED PRODUCTS
                  _buildSavedSection(savedItems),

                  // TAB 2: YOUR POSTS
                  _buildUserPostsSection(userPosts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BUILDER: SAVED PRODUCTS LIST
  Widget _buildSavedSection(List<Map<String, dynamic>> savedItems) {
    if (savedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bookmark_border_rounded, size: 54, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No saved products yet.',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 4),
            Text(
              'Bookmark items from home to see them here.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: savedItems.length,
      itemBuilder: (context, index) {
        final item = savedItems[index];
        final File? imageFile = item['imageFile'];
        final String imageUrl = item['imageUrl'] ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: imageFile != null
                    ? Image.file(imageFile, fit: BoxFit.cover)
                    : (imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : Container(color: Colors.grey[200], child: const Icon(Icons.image))),
              ),
            ),
            title: Text(
              item['title'] ?? 'Product',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text(
              'Rp ${item['price']} k • ${item['origin'] ?? 'BOGOR'}',
              style: const TextStyle(color: Color(0xFF233B2B), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () {
                _confirmDeleteDialog(
                  title: item['title'] ?? 'Item',
                  onDelete: () => UserSession().deleteSavedItem(index),
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailScreen(product: item)),
              );
            },
          ),
        );
      },
    );
  }

  // BUILDER: USER POSTS GRID
  Widget _buildUserPostsSection(List<Map<String, dynamic>> userPosts) {
    if (userPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.storefront_outlined, size: 54, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'You have no active product listings.',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 4),
            Text(
              'Tap "+ Add Product" to list your harvest!',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        final File? imageFile = post['imageFile'];
        final String imageUrl = post['imageUrl'] ?? '';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailScreen(product: post)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image + Delete Icon Overlay
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: imageFile != null
                            ? Image.file(imageFile, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                            : (imageUrl.isNotEmpty
                                ? Image.network(imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                                : Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey))),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _confirmDeleteDialog(
                              title: post['title'] ?? 'Listing',
                              onDelete: () => UserSession().deletePost(index),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Post Content Info
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['title'] ?? 'Product',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${post['price']} k',
                        style: const TextStyle(
                          color: Color(0xFF233B2B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stock: ${post['stock'] ?? 'N/A'}',
                        style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}