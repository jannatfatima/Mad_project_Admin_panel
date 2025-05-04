import 'package:admin_panel/panel_screen/deleteproduct.dart';
import 'package:admin_panel/utils/AppConstant.dart';
import 'package:flutter/material.dart';
import 'orderpage.dart';
import 'addproduct.dart';
import 'reviewspage.dart';
import 'updateProduct.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.backgColor,
      body: Center( // Center everything horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color: AppConstant.appMainColor,
                alignment: Alignment.center,
                child: const Text(
                  "Add Product",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteProductScreen()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color:AppConstant.appMainColor,
                alignment: Alignment.center,
                child: const Text(
                  " Delete Products",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProductScreen()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color:AppConstant.appMainColor,
                alignment: Alignment.center,
                child: const Text(
                  " Update Products",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Orderpage()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color: AppConstant.appMainColor,
                alignment: Alignment.center,
                child: const Text(
                  "Orders",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewsPage()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color: AppConstant.appMainColor,
                alignment: Alignment.center,
                child: const Text(
                  "Reviews",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



