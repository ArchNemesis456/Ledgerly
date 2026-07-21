import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_navigation_provider.dart';
import '../../accounts/screens/accounts_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../widgets/home_bottom_navigation.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  final List<Widget> _pages = const [
    DashboardScreen(),
    TransactionsScreen(),
    AnalyticsScreen(),
    AccountsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homeNavigationProvider);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(homeNavigationProvider.notifier).state = index;
        },
      ),
    );
  }
}
