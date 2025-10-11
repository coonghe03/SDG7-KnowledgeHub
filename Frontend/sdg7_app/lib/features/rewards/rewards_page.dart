import 'package:flutter/material.dart';
import 'package:sdg7_app/core/api_client.dart';
import 'package:sdg7_app/core/user_config.dart';
import 'package:go_router/go_router.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});
  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late Future<Map<String, dynamic>> _future;

  Future<Map<String, dynamic>> _load() =>
      ApiClient.getRewardsBalance(UserConfig.userId);

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards & Coins')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final data = snap.data!;
          final coins = (data['coins'] ?? 0) as int;
          final target = (data['targetCoins'] ?? 50) as int;
          final eligible = (data['eligibleForBillOffset'] ?? false) as bool;
          final rewardRs = (data['rewardOffsetRs'] ?? 50) as int;

          final progress = (coins / target).clamp(0.0, 1.0);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Coins',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('$coins / $target',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 8),
                        Text(eligible
                            ? '✅ Eligible for Rs. $rewardRs bill offset'
                            : 'Collect ${target - coins} more coins to unlock Rs. $rewardRs offset'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!eligible) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Not eligible yet. Score ≥80% to earn coins!'),
                      ));
                      return;
                    }
                    context.go('/billing'); // go to bill upload
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Electricity Bill'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Balance'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
