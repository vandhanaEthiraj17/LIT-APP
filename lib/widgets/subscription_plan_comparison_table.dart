import 'package:flutter/material.dart';

class PlanComparisonSection extends StatelessWidget {
  const PlanComparisonSection({super.key});

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle _cellStyle = TextStyle(
    fontSize: 12,
    color: Colors.white,
    height: 1.4,
  );

  static const Widget check = Icon(Icons.check, color: Colors.white, size: 16);
  static const Widget cross = Icon(Icons.close, color: Colors.white54, size: 16);

  final List<String> featureTitles = const [
    "Life Regeneration",
    "Midnight Sale Access",
    "Streak Restore",
    "Support Access",
    "Leaderboard Visibility",
    "Product History",
    "Answer Review",
    "Gems Bonus",
  ];

  final List<List<Widget>> rows = const [
    [Text("25 mins", style: _cellStyle), Text("15 mins", style: _cellStyle), Text("20 mins", style: _cellStyle)],
    [cross, check, check],
    [cross, Text("upto 3 days", style: _cellStyle), cross],
    [Text("Basic", style: _cellStyle), Text("VIP Support", style: _cellStyle), Text("Priority", style: _cellStyle)],
    [Text("Basic", style: _cellStyle), Text("Premium", style: _cellStyle), Text("Boosted", style: _cellStyle)],
    [Text("3 saves", style: _cellStyle), Text("Unlimited", style: _cellStyle), Text("3/Day", style: _cellStyle)],
    [cross, check, check],
    [cross, Text("+200 Gems", style: _cellStyle), Text("+100 Gems", style: _cellStyle)],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Plan Comparison",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 32),

          // Header Row
          Row(
            children: const [
              Expanded(flex: 4, child: SizedBox()), // Feature title spacer
              Expanded(flex: 3, child: Center(child: Text("Free", style: _headerStyle))),
              Expanded(flex: 3, child: Center(child: Text("Monthly", style: _headerStyle))),
              Expanded(flex: 3, child: Center(child: Text("Weekly", style: _headerStyle))),
            ],
          ),
          const SizedBox(height: 16),

          Stack(
            children: [
              // Column backgrounds (Free & Weekly + Monthly transparent for alignment)
              Positioned.fill(
                child: Row(
                  children: [
                    const Expanded(flex: 4, child: SizedBox()),
                    Expanded(
                      flex:3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    // Monthly column: transparent container for alignment
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table content
              Column(
                children: List.generate(featureTitles.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Feature name
                        Expanded(
                          flex: 4,
                          child: Text(
                            featureTitles[index],
                            style: _cellStyle,
                          ),
                        ),
                        // Free
                        Expanded(
                          flex: 3,
                          child: Center(child: rows[index][0]),
                        ),
                        // Monthly (now centered properly)
                        Expanded(
                          flex: 3,
                          child: Center(child: rows[index][1]),
                        ),
                        // Weekly
                        Expanded(
                          flex: 3,
                          child: Center(child: rows[index][2]),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
