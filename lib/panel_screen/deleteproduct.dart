import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_panel/utils/AppConstant.dart';

class DeleteProductScreen extends StatefulWidget {
  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  final TextEditingController idController = TextEditingController();
  Map<String, dynamic>? productDetails;

  // Function to fetch product details by ID

  Future<void> fetchProductDetails() async {
    final String productId = idController.text.trim();
    if (productId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a product ID')),
      );
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
          });
        } else {
          setState(() {
            productDetails = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No product found with this ID')),
          );
        }
      } catch (e) {
        print('Error parsing JSON: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing response')),
        );
      }
    } else {
      setState(() {
        productDetails = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch product details')),
      );
    }
  }

  // Function to delete product by ID
  Future<void> deleteProduct() async {
    final id = idController.text.trim();
    if (id.isEmpty) return;

    final url = Uri.parse('http://127.0.0.1:3001/shop_product/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      setState(() {
        productDetails = null;
        idController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.backgColor,
      appBar: AppBar(title: Text('Delete Product',
          style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppConstant.appMainColor,
      centerTitle: true),
      body: Padding(

        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 50),
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
              onPressed: fetchProductDetails, // No need to pass an argument
              child: Text('Fetch Product Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.appMainColor, // Change color here
                foregroundColor: Colors.white, // Text color

                ),
              ),

            SizedBox(height: 20),

            if (productDetails != null) ...[
              Text('Title: ${productDetails!['title']}' ,style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),),
              Text('Description: ${productDetails!['description']}',style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),),
              Text('Category: ${productDetails!['category']}',style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),),
              Text('Price: \$${productDetails!['price']}',style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: deleteProduct,
                style: ElevatedButton.styleFrom(backgroundColor: AppConstant.appMainColor),
                child: Text('Delete Product', style: TextStyle(color: Colors.white , )),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
