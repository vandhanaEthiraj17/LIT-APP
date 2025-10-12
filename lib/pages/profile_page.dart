import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:lit/widgets/rankbox.dart';
import 'package:lit/widgets/badge_popup.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';
import 'package:lit/data/global_data.dart';
import 'package:lit/pages/shop_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditingName = false;
  String userName = "LuxuryinTaste";
  final TextEditingController _nameController = TextEditingController();

  void _onNavTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/ir-icon');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }
  @override
  void initState() {
    super.initState();
    _nameController.text = userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  // 🔹 Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 40,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: NotificationBell(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "PROFILE",
                      style: GoogleFonts.kronaOne(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text("Back", style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(15, 70),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(107, 48, 224, 0.6),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.share, color: Color.fromRGBO(134, 74, 254, 1.0)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/images/avatar4.jpg'),
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Transform.translate(
                          offset: const Offset(-15, 70),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(107, 48, 224, 0.6),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person_add_alt, color: Color.fromRGBO(134, 74, 254, 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isEditingName
                          ? SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white30),
                            ),
                          ),
                          onSubmitted: (val) {
                            setState(() {
                              userName = val.trim().isEmpty ? userName : val.trim();
                              isEditingName = false;
                            });
                          },
                        ),
                      )
                          : Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditingName = true;
                            _nameController.text = userName;
                          });
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white12.withOpacity(0.1),
                          child: const Icon(Icons.edit_note_outlined,
                              color: Color.fromRGBO(127, 52, 195, 1.0), size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Text("Delhi", style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 6),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/india-flag.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                height: 260,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    const Text("Player Stats",
                                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 18)),
                                    const SizedBox(height: 6),
                                    Container(height: 1, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 20)),
                                    const SizedBox(height: 14),
                                    Text("16", style: TextStyle(color: Color.fromRGBO(134, 74, 254, 1.0), fontSize: 28, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    const Text("Games Played", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400)),
                                    const SizedBox(height: 20),
                                    Text("21", style: TextStyle(color: Color.fromRGBO(134, 74, 254, 1.0), fontSize: 28, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    const Text("Games Won", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const BadgePopupDialog();
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Container(
                                  height: 260,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text("Badges",
                                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 18)),
                                      const SizedBox(height: 6),
                                      Container(height: 1, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 20)),
                                      const SizedBox(height: 14),
                                      SizedBox(
                                        height: 80,
                                        width: 90,
                                        child: Image.asset('assets/images/amature-badge.png', fit: BoxFit.contain),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text("Your Points", style: TextStyle(color: Color.fromRGBO(134, 74, 254, 1.0), fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("2803",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(134, 74, 254, 1.0),
                                                  fontSize: 34,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.arrow_upward, size: 24, color: Color.fromRGBO(134, 74, 254, 1.0)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // 🔹 Fully transparent background
                        border: Border.all(
                          color: Colors.white24,    // 🔹 Thin white border
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Achievements",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: Colors.white24,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 16),

                          // 🔹 Icons + Labels + Progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAchievementColumn('assets/images/footwear-icon.png', 'Footwear', '33/40'),
                              _buildAchievementColumn('assets/images/clothing-icon.png', 'Clothing', '33/40'),
                              _buildAchievementColumn('assets/images/accessories-icon.png', 'Accessories', '33/40'),
                              _buildAchievementColumn('assets/images/bags-icon.png', 'Bags', '33/40'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                  _buildAccountInfoBox(),
                  _buildOrderDetailsBox(),
                  const SizedBox(height: 8),
                  RankBoxWidget(),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔹 Always show bottom nav bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // IR Icon tab
        onTap: (index) => _onNavTapped(context, index),
        isMarketplace: false,
      ),

    );
  }

  Widget _buildAccountInfoBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Account Information", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(height: 10),
                Container(height: 1, color: Colors.white24),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildInfoColumn("Full Name", "John Doe")),
                    const SizedBox(width: 5),
                    Expanded(child: _buildInfoColumn("Member Since", "January 2024")),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildInfoColumn("Phone", "+91 9874563210")),
                    const SizedBox(width: 5),
                    Expanded(child: _buildInfoColumn("Email", "John.Doe@Example.Com")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOrderDetailsBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Order Details", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 17)),
                SizedBox(height: 10),
                Divider(color: Colors.white24, thickness: 1),
                SizedBox(height: 16),
                Text("Currently No Orders", style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementIcon(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        assetPath,
        height: 24,
        width: 24,
        color: Colors.white,
      ),
    );
  }
  Widget _buildAchievementColumn(String iconPath, String label, String progress) {
    return Column(
      children: [
        _buildAchievementIcon(iconPath),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          progress,
          style: const TextStyle(
            color: Color.fromRGBO(134, 74, 254, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

}
