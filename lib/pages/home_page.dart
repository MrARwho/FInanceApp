// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fintechapp/pages/saving_page.dart';
import 'package:fintechapp/pages/wallet_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fintechapp/constants/constants.dart';
import 'package:fintechapp/widgets/buildEarningItems.dart';
import 'package:fintechapp/widgets/buildSavingItems.dart';
import 'package:fintechapp/widgets/buildTransactionItems.dart';
import 'package:fintechapp/constants/constants.dart';
import 'package:fintechapp/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Earning_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Extract the username from the email
      String email = user.email ?? 'user@example.com';
      String extractedUserName = email.split('@')[0];

      // Check if user exists in Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Add user to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': extractedUserName,
          'email': user.email,
          'uid': user.uid,
        });
      }

      // Set the username for display
      setState(() {
        userName = extractedUserName;
        print(userName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildHeader(),
                  const SizedBox(height: 15),
                  _buildBalanceCard(),
                  const SizedBox(height: 20),
                  _buildIncomeOutcomeCard(),
                ],
              ),
            ),
          ),
          _buildSectionHeader(
            "Earnings",
            "Add",
            () async {
              final newEarning = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEarningPage(),
                ),
              );

              if (newEarning != null) {
                setState(() {
                  earnings.add(newEarning);
                });
              }
            },
          ),
          _buildEarningsList(),
          _buildSectionHeader(
            "Savings",
            "See All",
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SavingPage(),
              ),
            ),
          ),
          _buildSavingsGrid(),
          _buildSectionHeader("Transactions", "See All", () {}),
          _buildTransactionsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning!",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "$userName",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Image.asset("assets/icons/Bell_pin.png"),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.maxFinite,
      height: 155,
      decoration: BoxDecoration(
        color: Fblack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -30,
            bottom: -60,
            child: Container(
              width: 91,
              height: 91,
              decoration: const BoxDecoration(
                color: Color(0XFF469B88),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -1,
            right: -1,
            child: Image.asset("assets/icons/Shape.png"),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Balance!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Fwhite,
                      ),
                    ),
                    Text(
                      "\$25,000.40",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Fwhite,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "My Wallet",
                        style: TextStyle(
                          fontSize: 14,
                          color: Fwhite,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 38,
                        icon: const Icon(
                          Icons.arrow_circle_right,
                          color: Fwhite,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateBalance(
      String userId, double totalBalance, double income, double outcome) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'totalBalance': totalBalance,
        'income': income,
        'outcome': outcome,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating balance: $e');
    }
  }
double income = 20000; // Initial income
double outcome = 17000; 
  Widget _buildIncomeOutcomeCard() {
    return Container(
      width: double.maxFinite,
      height: 80,
      decoration: BoxDecoration(
        color: Fblack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -10,
            top: -10,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0XFFBFA2CA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0XFFF5D8CB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIncomeOutcomeDetail(
                    "Income", "Arrow_left.svg", "\$ 20,000"),
                Container(width: 1, color: const Color(0XFFCFCFCF)),
                _buildIncomeOutcomeDetail(
                    "Outcome", "Arrow_right.svg", "\$ 17,000"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIncomeOutcomeDetail(
      String title, String iconPath, String amount) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/$iconPath",
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Fwhite,
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Fwhite,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
      String title, String actionText, Function()? onTap) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Fblack,
              ),
            ),
            InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: onTap,
              child: Text(
                actionText,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF489FCD),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> earnings = [
    {"name": "Upwork", "price": "3,000", "color": Fred},
    {"name": "Freepik", "price": "3,000", "color": Fpink},
    {"name": "Envato", "price": "2,000", "color": Fblue},
  ];
  Widget _buildEarningsList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        child: SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: earnings.length,
            itemBuilder: (context, index) {
              final earning = earnings[index];
              return BuildEarningItems(
                name: earning["name"],
                price: earning["price"],
                color: earning["color"],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsGrid() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: [
            SizedBox(
              width: 156,
              height: 91,
              child: BuildSavingItems(
                name: "Iphone 13 Mini",
                price: "699",
                color1: Color(0XFFCEDFBC),
                color2: Color(0XFFE0533D),
              ),
            ),
            SizedBox(
              width: 156,
              height: 91,
              child: BuildSavingItems(
                name: "Macbook Pro M1",
                price: "1,499",
                color1: Color(0XFFF5E9D3),
                color2: Color(0XFFE78C9D),
              ),
            ),
            SizedBox(
              width: 156,
              height: 91,
              child: BuildSavingItems(
                name: "Car",
                price: "20,000",
                color1: Color(0XFFBFA2CA),
                color2: Color(0XFFEED868),
              ),
            ),
            SizedBox(
              width: 156,
              height: 91,
              child: BuildSavingItems(
                name: "House",
                price: "30,500",
                color1: Color(0XFFE6B8D0),
                color2: Color(0XFF377CC8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: const [
              BuildTransactionItems(
                name: "Adobe Illustrator",
                description: "Subcription fee",
                nameImage: "desktop",
                bgColor: Color(0XFFFFCB66),
                price: "32.00",
              ),
              BuildTransactionItems(
                name: "Dribble",
                description: "Subcription fee",
                nameImage: "desktop",
                bgColor: Color(0XFFFFCB66),
                price: "15.00",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
