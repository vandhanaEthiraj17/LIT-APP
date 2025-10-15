import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;

  const GameCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
  });

  @override
  Widget build(BuildContext context) {
    // 👉 Unchosen card design
    if (!isSelected) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text(price,
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
          ],
        ),
      );
    }

    // 👉 Chosen card design
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xBF19181A), // overlay bg
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? Colors.green
              : isWrong
                  ? Colors.red
                  : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(price,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),

          const SizedBox(height: 8),

          // Correct / Wrong Section
          if (isCorrect) ...[
            const Text("CORRECT ANSWER",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 4),
            Image.asset("assets/images/gold_star.png",
                height: 36, width: 36, fit: BoxFit.contain),
          ],
          if (isWrong) ...[
            const Text("WRONG ANSWER",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 4),
            SvgPicture.asset("assets/images/heart-1.svg",
                height: 36, width: 36, fit: BoxFit.contain),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}




