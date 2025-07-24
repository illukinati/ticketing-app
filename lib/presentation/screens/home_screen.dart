import 'package:flutter/material.dart';
import 'show_list_page.dart';
import 'scan_qr_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const ShowListPage(), const ScanQRPage()];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR',
          ),
        ],
      ),
    );
  }
}
