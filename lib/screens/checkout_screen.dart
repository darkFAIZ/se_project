import 'package:flutter/material.dart';
import '../models/user_session.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _paymentMethod = 'QRIS';
  String _selectedBank = 'BCA';
  bool _useMapAddress = false;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _postalController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    double total = 0;
    for (final item in widget.cartItems) {
      final price = (item['price'] is num)
          ? (item['price'] as num).toDouble()
          : double.tryParse(item['price'].toString()) ?? 0;
      final quantity = item['quantity'] is num ? (item['quantity'] as num).toInt() : 1;
      total += price * quantity;
    }
    return total;
  }

  int get _totalItems {
    int total = 0;
    for (final item in widget.cartItems) {
      final quantity = item['quantity'] is num ? (item['quantity'] as num).toInt() : 1;
      total += quantity;
    }
    return total;
  }

  void _useDetectedMapAddress() {
    setState(() {
      _useMapAddress = true;
      _addressController.text = 'Jl. Pahlawan No. 24, Kec. Ciganjur';
      _cityController.text = 'Jakarta Selatan';
      _districtController.text = 'Ciganjur';
      _postalController.text = '12430';
    });
  }

  bool _isCardPaymentComplete() {
    final number = _cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
    return _cardHolderController.text.trim().isNotEmpty &&
        number.length >= 12 &&
        _expiryController.text.trim().isNotEmpty &&
        _cvvController.text.trim().length >= 3;
  }

  bool get _isFormValid {
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();
    final district = _districtController.text.trim();
    final postal = _postalController.text.trim();

    if (address.isEmpty || city.isEmpty || district.isEmpty || postal.isEmpty) {
      return false;
    }

    if (_paymentMethod == 'QRIS') {
      return true;
    }

    if (_paymentMethod == 'Card') {
      return _selectedBank.isNotEmpty && _isCardPaymentComplete();
    }

    return false;
  }

  void _showValidationMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all required information.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _confirmOrder() {
    if (!_isFormValid) {
      _showValidationMessage();
      return;
    }

    final order = {
      'id': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      'items': widget.cartItems,
      'total': _totalPrice,
      'totalItems': _totalItems,
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'district': _districtController.text.trim(),
      'postalCode': _postalController.text.trim(),
      'paymentMethod': _paymentMethod,
      'bank': _paymentMethod == 'Card' ? _selectedBank : 'QRIS',
      'status': 'Packed',
      'deliveryNote': _useMapAddress ? 'Location detected from map' : 'Address provided manually',
      'createdAt': DateTime.now().toIso8601String(),
    };

    UserSession().placeOrder(order);
    UserSession().clearCart();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(order: order),
      ),
    );
  }

  Widget _buildQrCodePreview() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemCount: 81,
            itemBuilder: (context, index) {
              final row = index ~/ 9;
              final col = index % 9;
              final bool shouldFill =
                  (row % 2 == 0 && col % 2 == 0) ||
                  (row % 3 == 0 && col % 4 == 0) ||
                  (row % 4 == 1 && col % 3 == 0) ||
                  (row % 2 == 1 && col % 2 == 1 && row < 7) ||
                  (row == 8 && col % 2 == 0) ||
                  (col == 8 && row % 2 == 0);

              return Container(
                decoration: BoxDecoration(
                  color: shouldFill ? const Color(0xFF233B2B) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: const Text('Complete Transaction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF233B2B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${_totalPrice.toStringAsFixed(0)} k',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_totalItems items ready to be delivered',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Delivery Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.map_outlined, color: Color(0xFF233B2B)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Based on the map address',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: _useDetectedMapAddress,
                          child: const Text('Use map location'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Full Address',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.home_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _districtController,
                            decoration: InputDecoration(
                              labelText: 'District',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _postalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.local_post_office_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),
              const Text(
                'Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: RadioListTile<String>(
                        value: 'QRIS',
                        groupValue: _paymentMethod,
                        title: const Text('QRIS'),
                        subtitle: const Text('Pay with your e-wallet or mobile banking QR code'),
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF233B2B),
                      ),
                    ),
                    if (_paymentMethod == 'QRIS')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: Column(
                          children: [
                            const Text(
                              'Scan this QR code to complete payment',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            _buildQrCodePreview(),
                          ],
                        ),
                      ),
                    Material(
                      color: Colors.transparent,
                      child: RadioListTile<String>(
                        value: 'Card',
                        groupValue: _paymentMethod,
                        title: const Text('Bank Card'),
                        subtitle: const Text('BCA, Mandiri, BNI, and other Indonesian banks'),
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF233B2B),
                      ),
                    ),
                    if (_paymentMethod == 'Card') ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7F4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedBank,
                              decoration: InputDecoration(
                                labelText: 'Select Bank',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'BCA', child: Text('BCA')),
                                DropdownMenuItem(value: 'Mandiri', child: Text('Mandiri')),
                                DropdownMenuItem(value: 'BNI', child: Text('BNI')),
                                DropdownMenuItem(value: 'BRI', child: Text('BRI')),
                                DropdownMenuItem(value: 'Other', child: Text('Other Bank')),
                              ],
                              onChanged: (value) => setState(() => _selectedBank = value ?? 'BCA'),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _cardNumberController,
                              keyboardType: TextInputType.number,
                              maxLength: 19,
                              decoration: InputDecoration(
                                labelText: 'Card Number',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.credit_card_outlined),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _cardHolderController,
                              decoration: InputDecoration(
                                labelText: 'Card Holder Name',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _expiryController,
                                    maxLength: 5,
                                    decoration: InputDecoration(
                                      labelText: 'MM/YY',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _cvvController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      labelText: 'CVV',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF233B2B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Confirm Order',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderTrackingScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderStatus = order['status'] as String? ?? 'Packed';
    final steps = [
      {'label': 'Packed', 'done': true},
      {'label': 'On the way to your address', 'done': true},
      {'label': 'Delivered', 'done': false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: const Text('Order Status'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF233B2B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment successful',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      orderStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Order ${order['id']}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delivery progress',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              ...steps.map((step) {
                final isDone = step['done'] as bool;
                final isCurrent = step['label'] == orderStatus;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone || isCurrent ? const Color(0xFF233B2B) : Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step['label'] as String,
                          style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isDone || isCurrent ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ),
                      if (isCurrent)
                        const Icon(Icons.local_shipping_rounded, color: Color(0xFF233B2B)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery address',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order['address']}, ${order['district']}, ${order['city']} ${order['postalCode']}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment'),
                        Text(order['paymentMethod'].toString()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text('Rp ${((order['total'] as num?) ?? 0).toDouble().toStringAsFixed(0)} k'),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF233B2B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
