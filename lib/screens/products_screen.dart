import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart'; // Kategori model dosyası
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> futureProducts;
  late Future<List<Category>> futureCategories;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService().fetchProducts();
    futureCategories = ApiService().fetchCategories();
    futureCategories.then((data) {
      setState(() {
        categories = data; // Kategorileri state'e ekle
      });
    });
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
      appBar: AppBar(title: const Text('Products')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Categories',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            // Kategorileri Drawer'a ekle
            ...categories.map((category) {
              return ListTile(
                title: Text(category.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryScreen(category: category.id),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text('\$${products[index].price}'),
                  leading: getImage(products[index].imageUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(productId: products[index].id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
