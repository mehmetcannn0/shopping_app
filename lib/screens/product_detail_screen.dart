import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:shopping_app/services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId; // Ürün ID'sini al

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> fetchProductDetail;

  @override
  void initState() {
    super.initState();
    fetchProductDetail = ApiService().fetchProductDetail(widget.productId);
  }

  Widget getImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const FlutterLogo(size: 40);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProductDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getImage(product['imageUrl']),
                  // Image.network(product['imageUrl']),
                  const SizedBox(height: 16),
                  Text(product['name'], style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text('\$${product['price']}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  HtmlWidget(product['description']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
