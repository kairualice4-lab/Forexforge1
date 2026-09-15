import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ForexForgeApp());
}

class ForexForgeApp extends StatelessWidget {
  const ForexForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forex Forge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E17),
        primaryColor: const Color(0xFF00E5FF),
        cardColor: const Color(0xFF131B2A),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers for Main Menu Inputs
  final TextEditingController _riskController = TextEditingController(text: "11.0");
  final TextEditingController _drawdownController = TextEditingController(text: "15.0");
  final TextEditingController _brokerController = TextEditingController(text: "ICMarkets-Demo");
  final TextEditingController _serverController = TextEditingController(text: "ICMarkets-Server01");
  final TextEditingController _loginController = TextEditingController(text: "12345678");
  final TextEditingController _passwordController = TextEditingController();

  final List<String> pairs = ["XAUUSD", "EURUSD", "GBPUSD", "USDJPY", "GBPJPY", "BTCUSD", "AUDUSD"];
  
  bool isRunning = false;
  Timer? _executionTimer;
  final List<String> _logs = ["[System Ready] Input configuration and start the bot."];

  void _addLog(String text) {
    setState(() {
      _logs.insert(0, "[${DateTime.now().toString().split('.').first}] $text");
    });
  }

  void _startBot() {
    if (!_formKey.currentState!.validate()) return;

    double risk = double.parse(_riskController.text);
    double drawdown = double.parse(_drawdownController.text);

    if (risk <= 10.0) {
      _showError("Risk % must be strictly greater than 10%.");
      return;
    }
    if (drawdown <= 10.0) {
      _showError("Daily Drawdown % must be strictly greater than 10%.");
      return;
    }

    setState(() {
      isRunning = true;
    });

    _addLog("==========================================");
    _addLog("FOREX FORGE INSTANCE INITIALIZED");
    _addLog("Broker: ${_brokerController.text} | Server: ${_serverController.text}");
    _addLog("Risk Target: $risk% | Max Drawdown Target: $drawdown%");
    _addLog("Monitoring Pairs (15M): ${pairs.join(', ')}");
    _addLog("==========================================");

    // Mock 15-minute Strategy Loop execution interval (Set to 4 seconds for UI test)
    _executionTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _runStrategyLoop();
    });
  }

  void _stopBot() {
    _executionTimer?.cancel();
    setState(() {
      isRunning = false;
    });
    _addLog("[STOPPED] Bot execution loop paused by user.");
  }

  void _runStrategyLoop() {
    for (var pair in pairs) {
      _addLog("Scanning $pair on M15 timeframe...");
      // Logic Pipeline simulation
      _addLog(" -> $pair: Passed Order Block & 50% Fib entry check.");
      _addLog(" -> $pair: Filter Check (RSI + 60% Retail Contrarian + CME Heatmap) [PASSED]");
      _addLog(" -> $pair: Risk Management (RR >= 1:2) [PASSED]");
      _addLog(" -> EXECUTION: Buy Limit order sent for $pair");
      break; // Run for single pair per interval tick
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FOREX FORGE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: const Color(0xFF131B2A),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Configuration Form
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Bot Input Parameters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildInputField("Risk % (>10%)", _riskController, isNumber: true)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildInputField("Daily Drawdown % (>10%)", _drawdownController, isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildInputField("MT4/MT5 Broker", _brokerController),
                      const SizedBox(height: 10),
                      _buildInputField("Server", _serverController),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildInputField("Account Login", _loginController, isNumber: true)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildInputField("Password", _passwordController, isPassword: true)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isRunning ? null : _startBot,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent[700],
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text("START BOT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isRunning ? _stopBot : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent[700],
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text("STOP BOT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            // Real-Time System Log Display
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Strategy Output Console", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70)),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _logs[index],
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontFamily: 'monospace'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Author: Joseph Wachiuri", style: TextStyle(fontSize: 11, color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isNumber = false, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.white60),
        filled: true,
        fillColor: const Color(0xFF131B2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "Required";
        return null;
      },
    );
  }
}
