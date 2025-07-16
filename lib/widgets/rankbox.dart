import 'package:flutter/material.dart';
import 'dart:ui';

import '../pages/game_leaderboard_page.dart';

class RankBoxWidget extends StatelessWidget {
  const RankBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildRankBox(context);
  }

  Widget _buildRankBox(BuildContext context) {
    final List<Map<String, dynamic>> ranks = [
      {
        'rank': 1,
        'name': 'LuxuryinTaste',
        'points': 555,
        'avatar': 'assets/images/avatar1.jpg',
        'isGold': true,
      },
      {
        'rank': 2,
        'name': 'Gamer42',
        'points': 534,
        'avatar': 'assets/images/avatar2.jpg',
        'isGold': false,
      },
      {
        'rank': 3,
        'name': 'Alix Johnson',
        'points': 510,
        'avatar': 'assets/images/avatar3.jpg',
        'isGold': false,
      },
      {
        'rank': 4,
        'name': 'Mariya Satnova',
        'points': 500,
        'avatar': 'assets/images/avatar4.jpg',
        'isGold': true,
      },
    ];

    final Map<String, dynamic> currentUser = {
      'rank': 98,
      'name': 'Gamer42',
      'points': 534,
      'avatar': 'assets/images/avatar2.jpg',
      'isGold': false,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Rank",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GameLeaderboardPage()),
                          );
                        },
                        child: const Text(
                          "view all",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,

                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                const Divider(color: Colors.white24, height: 0),
                // 🔹 Top Rankings List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ranks.length,
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white10, height: 0),
                  itemBuilder: (context, index) {
                    final item = ranks[index];
                    return _buildRankTile(
                      rank: item['rank'],
                      name: item['name'],
                      points: item['points'],
                      avatar: item['avatar'],
                      isGold: item['isGold'],
                      isCurrentUser: false,
                    );
                  },
                ),

                const Divider(color: Colors.white24, height: 0),

                // 🔹 Current User Rank
                _buildRankTile(
                  rank: currentUser['rank'],
                  name: currentUser['name'],
                  points: currentUser['points'],
                  avatar: currentUser['avatar'],
                  isGold: currentUser['isGold'],
                  isCurrentUser: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankTile({
    required int rank,
    required String name,
    required int points,
    required String avatar,
    required bool isGold,
    bool isCurrentUser = false,
  }) {
    // Background & Border styling based on rank
    Color bgColor = Colors.transparent;
    Border border = Border.all(color: Colors.white60);

    if (rank == 1) {
      bgColor = Colors.amber.shade700;
      border = Border.all(color: Colors.yellowAccent, width: 2);
    } else if (rank == 2) {
      bgColor = Colors.grey.shade700;
      border = Border.all(color: Colors.grey, width: 2);
    } else if (rank == 3) {
      bgColor = Colors.brown.shade600;
      border = Border.all(color: Colors.brown.shade300, width: 2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isCurrentUser ? Colors.white.withOpacity(0.05) : Colors
          .transparent,
      child: Row(
        children: [
          // 🔹 Rank Box
          Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              border: border,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              rank.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 🔹 Avatar
          CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: 22,
          ),

          const SizedBox(width: 12),

          // 🔹 Name
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 🔹 Points + Star
          Row(
            children: [
              Image.asset(
                isGold
                    ? 'assets/images/gold_star.png'
                    : 'assets/images/purple_star.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 6),
              Text(
                points.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}