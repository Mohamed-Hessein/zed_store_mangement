import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';
import 'package:zed_store_mangent/features/home/presentation/screen/home_screen.dart';
import 'package:zed_store_mangent/features/product/presentation/pages/inventory_page.dart';
import 'package:zed_store_mangent/features/analytics/presentation/pages/analytics_page.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/pages/store_profile_page.dart';

import '../../../../core/resources/app_strings.dart';

@RoutePage()
class HomeBottomNavPage extends StatefulWidget {
  const HomeBottomNavPage({super.key});

  @override
  State<HomeBottomNavPage> createState() => _HomeBottomNavPageState();
}

class _HomeBottomNavPageState extends State<HomeBottomNavPage> {
  final List<Widget> pages = [
    const HomeScreen(),
    const InventoryPage(),
    const AnalyticsPage(),
    const StoreProfilePage(),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_2_outlined),
            label: 'المنتجات',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: AppStrings.analytics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: AppStrings.store,
          ),
        ],
      ),
    );
  }
}
