import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_panel/utils/AppConstant.dart';
class UpdateProductScreen extends StatefulWidget {
  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  Map<String, dynamic>? productDetails;

  // 📌 Function to fetch product details by ID
  Future<void> fetchProductDetails() async {
    final String productId = idController.text.trim();
    if (productId.isEmpty) {
      showSnackBar('Please enter a product ID');
      return;
    }

    final url = Uri.parse('http://127.0.0.1:3001/shop_product/id/$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData.isNotEmpty) {
          setState(() {
            productDetails = jsonData is List ? jsonData.first : jsonData;
            titleController.text = productDetails!['title'];
            descriptionController.text = productDetails!['description'];
            categoryController.text = productDetails!['category'];
            ratingController.text = productDetails!['rating'].toString();
            priceController.text = productDetails!['price'].toString();
            imageController.text = productDetails!['image'];
          });
        } else {
          setState(() {
            productDetails = null;
          });
          showSnackBar('No product found with this ID');
        }
      } catch (e) {
        showSnackBar('Error processing response');
      }
    } else {
      showSnackBar('Failed to fetch product details');
    }
  }

  // 📌 Function to update product details
  Future<void> updateProduct() async {
    final String productId = idController.text.trim();
    if (productId.isEmpty) {
      showSnackBar('Please enter a product ID');
      return;
    }

    final Map<String, dynamic> updatedData = {
      "image": imageController.text.trim(),
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "category": categoryController.text.trim(),
      "rating": ratingController.text.trim(),
      "price": priceController.text.trim(),
    };

    final url = Uri.parse('http://127.0.0.1:3001/shop_product/$productId');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      showSnackBar('Product updated successfully!');
    } else {
      showSnackBar('Failed to update product.');
    }
  }

  // 📌 Function to show SnackBar messages
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.backgColor,
      appBar: AppBar(title: Text('Update Product',
          style: TextStyle(color: Colors.white),
      ),
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Product ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchProductDetails,
              child: Text('Fetch Product Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.secondaryColor, // Change color here
                foregroundColor: Colors.white, // Text color

              ),
            ),
            SizedBox(height: 20),

            if (productDetails != null) ...[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Rating', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor, // Change color here
                  foregroundColor: Colors.white, // Text color

                ),
                child: Text('Update Product', style: TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
