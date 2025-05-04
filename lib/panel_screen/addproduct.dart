import 'package:flutter/material.dart';
import 'package:admin_panel/utils/AppConstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  int _nextId = 1;
  String? selectedCategory;
  Uint8List? _webImage;
  File? _image;
  String? _imageFileName;

  @override
  void initState() {
    super.initState();
    fetchNextId();
  }

  Future<void> fetchNextId() async {
    final url = Uri.parse('http://127.0.0.1:3001/shop_product');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> products = jsonDecode(response.body);
      if (products.isNotEmpty) {
        int lastId = products.last['id'];
        setState(() {
          _nextId = lastId + 1;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        _webImage = await pickedFile.readAsBytes();
        _imageFileName = pickedFile.name;
      } else {
        _image = File(pickedFile.path);
      }
      setState(() {});
    }
  }

  Future<void> addProduct() async {
    final url = Uri.parse('http://127.0.0.1:3001/shop_product');

    final Map<String, dynamic> product = {
      "id": _nextId,
      "image": _imageFileName ?? "",
      "title": titleController.text,
      "description": descriptionController.text,
      "category": selectedCategory ?? "",
      "rating": double.parse(ratingController.text),
      "price": double.parse(priceController.text),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
      clearFields();
      fetchNextId();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product.')),
      );
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    ratingController.clear();
    priceController.clear();
    setState(() {
      selectedCategory = null;
      _webImage = null;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppConstant. backgColor ,
      appBar: AppBar(title: Text(' Add Product',
      style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppConstant.appMainColor,
      centerTitle: true,),
      body: Padding(

        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Product ID: $_nextId', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _webImage != null
                  ? Image.memory(_webImage!, height: 100)
                  : _image != null
                  ? Image.file(_image!, height: 100)
                  : Text('No image selected'),
              SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.secondaryColor, // Change color here
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              child: Text('Pick Image'),
            ),),
              SizedBox(height: 10),
              buildTextField('Title', titleController),
              buildTextField('Description', descriptionController),
              buildDropdownField(),
              buildTextField('Rating', ratingController, isNumber: true),
              buildTextField('Price', priceController, isNumber: true),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 400),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addProduct();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor, // Change color here
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: Text('Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdownField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        items: ['Male', 'Female', 'Perfume']
            .map((category) => DropdownMenuItem(
          value: category,
          child: Text(category),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }
}
