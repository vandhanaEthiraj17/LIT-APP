import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lit/pages/notifications_page.dart';
import 'package:lit/providers/notification_provider.dart';


class NotificationBell extends StatefulWidget {
  final double? size;
  const NotificationBell({super.key, this.size});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        if (provider.shouldTriggerSound) {
          _controller.forward(from: 0);

          // 👇 Prevent multiple triggers
          provider.updateLastNotifiedCount();
        }

        return Stack(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: IconButton(
                icon: Icon(Icons.notifications_none, 
                  color: Colors.white,
                  size: widget.size,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsPage()),
                  ).then((_) {
                    Provider.of<NotificationProvider>(context, listen: false).markAllSeen();
                  });
                },
              ),
            ),
            if (provider.hasUnseenNotifications)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
