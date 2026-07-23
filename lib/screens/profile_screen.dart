import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Shared global list notifier so posts persist across screen transitions
final ValueNotifier<List<Map<String, dynamic>>> userPostsNotifier = ValueNotifier([]);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  // Form Controllers for Item Upload
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2); // Default to 'Your posts' tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Pick Image from Device Gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Bottom Sheet Form to Add New Selling Item
  void _showUploadDialog() {
    _selectedImage = null; // Reset image preview on modal open

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sell Your Harvest / Item',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Image Picker Widget
                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setModalState(() {
                            _selectedImage = File(image.path);
                          });
                        }
                      },
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_selectedImage!, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.grey),
                                  SizedBox(height: 6),
                                  Text(
                                    'Tap to choose image from device',
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title Field
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title / Product Name',
                        hintText: 'e.g. Fresh Organic Tomatoes',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price Field
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (Rp)',
                        hintText: 'e.g. 15000',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description Field
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Describe your product...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Upload Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF233B2B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty) {
                            // Update global persistent list
                            userPostsNotifier.value = [
                              {
                                'title': _titleController.text,
                                'price': _priceController.text,
                                'description': _descriptionController.text,
                                'imageFile': _selectedImage,
                              },
                              ...userPostsNotifier.value,
                            ];

                            // Clear controllers
                            _titleController.clear();
                            _priceController.clear();
                            _descriptionController.clear();
                            _selectedImage = null;

                            Navigator.pop(context); // Close bottom sheet
                            _tabController.animateTo(2); // Switch to 'Your posts' tab
                          }
                        },
                        child: const Text(
                          'Upload Item',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F7EC),

      // Floating Plus Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF233B2B),
        onPressed: _showUploadDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      // LEFT DRAWER
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Menu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.tune_rounded, color: Colors.black87),
                title: const Text('Preferences & Theme', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline_rounded, color: Colors.black87),
                title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),

      // RIGHT DRAWER
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded, color: Colors.black87),
                title: const Text('About Apps', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined, color: Colors.black87),
                title: const Text('License', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu_rounded, size: 30, color: Colors.black),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.hexagon_outlined, size: 30, color: Colors.black),
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // PROFILE HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mr. Aqiel',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Did you know ?\nprotein on the fishes is going to your brain not to your muscle.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TAB BAR
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              tabs: const [
                Tab(text: 'Favorite'),
                Tab(text: 'Save'),
                Tab(text: 'Your posts'),
              ],
            ),

            const SizedBox(height: 16),

            // TAB VIEWS
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmptyState('No favorites yet.'),
                  _buildEmptyState('No saved items yet.'),
                  
                  // Re-renders automatically whenever userPostsNotifier receives a new post
                  ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: userPostsNotifier,
                    builder: (context, posts, child) {
                      if (posts.isEmpty) {
                        return _buildEmptyState('No posts yet. Tap + to upload an item to sell!');
                      }
                      return _buildUserPostsGrid(posts);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 26),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined, size: 26),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 26),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildUserPostsGrid(List<Map<String, dynamic>> posts) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.8,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final File? imageFile = post['imageFile'];

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE2EAD6),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageFile != null
                      ? Image.file(
                          imageFile,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                post['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Rp ${post['price'] ?? '0'}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}