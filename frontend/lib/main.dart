import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NovaAiApp());
}

class NovaAiApp extends StatelessWidget {
  const NovaAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color seed = const Color(0xFF6750A4);
    return MaterialApp(
      title: 'Nova AI Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(height: 1.5),
        ),
      ),
      home: const NovaHomePage(),
    );
  }
}

class NovaHomePage extends StatefulWidget {
  const NovaHomePage({super.key});

  @override
  State<NovaHomePage> createState() => _NovaHomePageState();
}

class _NovaHomePageState extends State<NovaHomePage> {
  int _selectedIndex = 0;
  final DeepSeekChatService _chatService = DeepSeekChatService();
  late final List<Widget> _pages;

  static const List<String> _titles = <String>[
    'AI Navigator',
    'Conversations',
    'Insight Hub',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const DashboardView(),
      ChatView(service: _chatService),
      const InsightView(),
      const ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: const <Widget>[
          _GhostIconButton(icon: Icons.search),
          _GhostIconButton(icon: Icons.notifications_outlined),
          SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_selectedIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.flash_on),
              label: const Text('Prompt Nova'),
            )
          : FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          if (index == _selectedIndex) return;
          setState(() => _selectedIndex = index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_graph_outlined),
            selectedIcon: Icon(Icons.auto_graph),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const List<_QuickAction> _quickActions = <_QuickAction>[
    _QuickAction(Icons.auto_fix_high, 'Idea Draft'),
    _QuickAction(Icons.translate, 'Translate'),
    _QuickAction(Icons.analytics_outlined, 'Predict'),
    _QuickAction(Icons.summarize_outlined, 'Summarise'),
  ];

  static const List<_Insight> _insights = <_Insight>[
    _Insight(
      title: 'Customer Sentiment',
      subtitle: 'Positive trend • +12%',
      icon: Icons.sentiment_satisfied_outlined,
      color: Color(0xFF21B8C7),
    ),
    _Insight(
      title: 'Automation Coverage',
      subtitle: '43 active workflows',
      icon: Icons.precision_manufacturing_outlined,
      color: Color(0xFFFB896B),
    ),
    _Insight(
      title: 'Content Performance',
      subtitle: 'Top 3% engagement',
      icon: Icons.stacked_line_chart,
      color: Color(0xFF8E6BF6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: <Color>[
                Color(0xFF302D7C),
                Color(0xFF6750A4),
                Color(0xFF9F8CFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Meet Nova, your AI co-pilot',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Transform ideas into polished outcomes with adaptive agents and live insights.',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF302D7C),
                ),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Launch Mission'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Quick Actions',
          actionLabel: 'Customise',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _quickActions
              .map((action) => QuickActionChip(action: action))
              .toList(growable: false),
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Live Intelligence',
          actionLabel: 'View all',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        ..._insights.map(InsightCard.new),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Recent Activity',
          actionLabel: 'Timeline',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        const ActivityTile(
          title: 'Generated strategic brief',
          subtitle: 'Nova synthesised 6 market reports.',
          timestamp: '2m ago',
        ),
        const ActivityTile(
          title: 'Automated sentiment follow-up',
          subtitle: 'Triggered outreach to 128 customers.',
          timestamp: '38m ago',
        ),
      ],
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.service});

  final DeepSeekChatService service;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = <_Message>[
    const _Message(
      sender: Sender.assistant,
      text:
          'Hai! Saya Nova, pembantu AI anda. Apa yang boleh saya bantu hari ini?',
      time: 'Sekarang',
    ),
  ];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendPrompt() async {
    final String prompt = _controller.text.trim();
    if (prompt.isEmpty || _isLoading) {
      return;
    }

    setState(() {
      _controller.clear();
      _isLoading = true;
      _messages.insert(
        0,
        _Message(
          sender: Sender.user,
          text: prompt,
          time: _formatTimestamp(DateTime.now()),
        ),
      );
    });

    try {
      final List<Map<String, String>> contextMessages = _messages
          .map((message) => <String, String>{
                'role': message.sender == Sender.user ? 'user' : 'assistant',
                'content': message.text,
              })
          .toList(growable: false)
          .reversed
          .toList(growable: false);

      final String reply = await widget.service.prompt(messages: contextMessages);

      if (reply.isEmpty) {
        throw Exception('Balasan kosong dari pelayan.');
      }

      if (!mounted) return;
      setState(() {
        _messages.insert(
          0,
          _Message(
            sender: Sender.assistant,
            text: reply,
            time: _formatTimestamp(DateTime.now()),
          ),
        );
      });
    } catch (error, stackTrace) {
      debugPrint('ChatView error: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _messages.insert(
          0,
          _Message(
            sender: Sender.assistant,
            text:
                'Maaf, saya gagal mendapatkan respons daripada pelayan. Cuba lagi nanti.',
            time: _formatTimestamp(DateTime.now()),
          ),
        );
      });
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String _formatTimestamp(DateTime time) {
    final String hours = time.hour.toString().padLeft(2, '0');
    final String minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            itemCount: _messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final _Message message = _messages[index];
              final bool isUser = message.sender == Sender.user;
              final Color bubble = isUser
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceVariant;
              final Color textColor = isUser
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface;
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: bubble,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft:
                          Radius.circular(isUser ? 20 : 6),
                      bottomRight:
                          Radius.circular(isUser ? 6 : 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(message.text, style: theme.textTheme.bodyLarge?.copyWith(color: textColor)),
                      const SizedBox(height: 6),
                      Text(
                        message.time,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                SizedBox(width: 12),
                Text('Nova sedang berfikir...'),
              ],
            ),
          ),
        const Divider(height: 1),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: _isLoading ? null : () {},
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Lampirkan',
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendPrompt(),
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'Tulis arahan untuk Nova…',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isLoading ? null : _sendPrompt,
                child: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DeepSeekChatService {
  DeepSeekChatService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  String get _baseUrl {
    const String envUrl = String.fromEnvironment('NOVA_BACKEND_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'http://localhost:3000';
    }
  }

  Future<String> prompt({required List<Map<String, String>> messages}) async {
    final Uri uri = Uri.parse('$_baseUrl/api/chat');
    try {
      final http.Response response = await _client.post(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{'messages': messages}),
      );

      if (response.statusCode >= 400) {
        final String safeBody = response.body.isEmpty ? response.reasonPhrase ?? 'Unknown error' : response.body;
        throw Exception('DeepSeek API error (${response.statusCode}): $safeBody');
      }

      final Map<String, dynamic> payload = jsonDecode(response.body) as Map<String, dynamic>;
      final String reply = (payload['reply'] as String?)?.trim() ?? '';
      return reply;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('DeepSeekChatService error: $error\n$stackTrace');
      }
      rethrow;
    }
  }
}

class InsightView extends StatelessWidget {
  const InsightView({super.key});

  static const List<_Metric> _metrics = <_Metric>[
    _Metric(
      title: 'Automation Uptime',
      description: 'Autonomous workflows without manual intervention.',
      progress: 0.86,
      color: Color(0xFF6750A4),
    ),
    _Metric(
      title: 'Knowledge Coverage',
      description: 'Sources synced and refreshed weekly.',
      progress: 0.72,
      color: Color(0xFF21B8C7),
    ),
    _Metric(
      title: 'Response Confidence',
      description: 'Average confidence across generated insights.',
      progress: 0.91,
      color: Color(0xFFFB896B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: <Widget>[
        SectionHeader(
          title: 'System Health',
          actionLabel: 'Log',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        ..._metrics.map(MetricCard.new),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.colorScheme.surfaceVariant.withOpacity(0.8),
          ),
          padding: const EdgeInsets.all(22),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: theme.colorScheme.primary.withOpacity(0.12),
                ),
                child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Need deeper analysis?', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Lancarkan audit hiper terperinci dengan penganalisis autonomi Nova.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Launch'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.colorScheme.surfaceVariant.withOpacity(0.85),
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  'AR',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Aisyah Rahman', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text('Head of Innovation • Enterprise Workspace',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('Preferences', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: true,
          onChanged: (_) {},
          title: const Text('Enable multimodal responses'),
          subtitle: const Text('Allow Nova to attach visuals or audio outputs.'),
        ),
        SwitchListTile.adaptive(
          value: false,
          onChanged: (_) {},
          title: const Text('Offline knowledge sync'),
          subtitle: const Text('Download packs for on-device access.'),
        ),
        const Divider(height: 32),
        Text('Security & Access', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.verified_user_outlined),
          title: const Text('Roles & permissions'),
          subtitle: const Text('Manage collaborators dan workspace tiers.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.lock_clock_outlined),
          title: const Text('Data policy'),
          subtitle: const Text('Tetapkan tempoh retensi dan pematuhan.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.link_outlined),
          title: const Text('Integrations'),
          subtitle: const Text('Hubungkan ke CRM, papan tugas dan knowledge hubs.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const Divider(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text('Sign out', style: TextStyle(color: theme.colorScheme.error)),
          onTap: () {},
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: theme.textTheme.titleLarge),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}

class QuickActionChip extends StatelessWidget {
  const QuickActionChip({super.key, required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(action.icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Text(action.label, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard(this.insight, {super.key});

  final _Insight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(insight.icon, color: insight.color),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(insight.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(insight.subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: insight.color),
        ],
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final String title;
  final String subtitle;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(subtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            timestamp,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard(this.metric, {super.key});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(metric.title, style: theme.textTheme.titleMedium),
              ),
              Text(
                '${(metric.progress * 100).round()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: metric.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(metric.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: metric.progress,
              minHeight: 8,
              color: metric.color,
              backgroundColor: metric.color.withOpacity(0.16),
            ),
          ),
        ],
      ),
    );
  }
}

class _GhostIconButton extends StatelessWidget {
  const _GhostIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _Insight {
  const _Insight({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _Message {
  const _Message({
    required this.sender,
    required this.text,
    required this.time,
  });

  final Sender sender;
  final String text;
  final String time;
}

class _Metric {
  const _Metric({
    required this.title,
    required this.description,
    required this.progress,
    required this.color,
  });

  final String title;
  final String description;
  final double progress;
  final Color color;
}

enum Sender { user, assistant }
