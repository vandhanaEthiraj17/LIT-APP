import 'package:flutter/material.dart';
import 'package:lit/pages/ir_icon_page.dart';
import 'package:lit/pages/profile_page.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';
import 'home/home_page.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/pages/notifications_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    IrIconPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const AppDrawer(), // ⬅️ Common drawer
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: NotificationBell(),
          ),
        ],


      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
