import 'package:fintechapp/constants/constants.dart';
import 'package:flutter/material.dart';

class AddEarningPage extends StatefulWidget {
  const AddEarningPage({Key? key}) : super(key: key);

  @override
  State<AddEarningPage> createState() => _AddEarningPageState();
}

class _AddEarningPageState extends State<AddEarningPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  double income = 20000; // Initial income
  double outcome = 17000; // Initial outcome
  List<Map<String, dynamic>> earnings = [
    {"name": "Upwork", "price": 3000, "color": Fred},
    {"name": "Freepik", "price": 3000, "color": Fpink},
    {"name": "Envato", "price": 2000, "color": Fblue},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Earning"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Earning Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter earning name",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Earning Price",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter earning price",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
                child: ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final price = _priceController.text.trim();
                if (name.isNotEmpty && price.isNotEmpty) {
                  final newEarning = {
                    "name": name,
                    "price": double.parse(
                        price), // Convert price to double for calculations
                    "color":
                        Colors.green, // Example color, you can customize this
                  };
                  Navigator.pop(context, newEarning);

                  setState(() {
                    earnings.add(newEarning); // Add the new earning to the list
                    income += double.parse(price); // Update total income
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                }
              },
              child: const Text("Add Earning"),
            )),
          ],
        ),
      ),
    );
  }
}
