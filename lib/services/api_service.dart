import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/category.dart';
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000';

  // Tüm ürünleri getirme
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['products'];
      return jsonResponse.map((product) {
        product['imageUrl'] = '$baseUrl/img/${product['imageUrl']}';
        return Product.fromJson(product);
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Kategorileri çekmek için yeni fonksiyon
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/getcategories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Belirli bir kategoriye göre ürünleri getirme
  Future<List<Product>> getProductsByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/categories/$category'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) {
        product['imageUrl'] = '$baseUrl/img/${product['imageUrl']}';
        return Product.fromJson(product);
      }).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  // Ürün detaylarını getirme
  Future<Map<String, dynamic>> fetchProductDetail(String productId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/products/$productId'));

    if (response.statusCode == 200) {
      final product = json.decode(response.body);
      product['imageUrl'] = '$baseUrl/img/${product['imageUrl']}';
      return product;
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
