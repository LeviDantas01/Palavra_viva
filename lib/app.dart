import 'package:flutter/material.dart';
import 'ui/screens/menu_screen.dart';
import 'data/services/notification_service.dart';

class BibleApp extends StatefulWidget {
  const BibleApp({super.key});

  @override
  State<BibleApp> createState() => _BibleAppState();
}

class _BibleAppState extends State<BibleApp> {
  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    final notificationService = NotificationService();
    await notificationService.requestPermissions();
    await notificationService.scheduleAllReminders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palavra Viva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey, 
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const MenuScreen(),
    );
  }
}