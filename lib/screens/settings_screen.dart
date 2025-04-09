// import 'package:flutter/material.dart';
// import '../config/app_config.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final TextEditingController _webhookController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _webhookController.text = AppConfig.webhookUrl;
//   }

//   @override
//   void dispose() {
//     _webhookController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           const Text(
//             'Webhook Settings',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: _webhookController,
//             decoration: const InputDecoration(
//               labelText: 'Webhook URL',
//               hintText: 'Enter n8n webhook URL',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _saveWebhookUrl,
//             child: const Text('Save Webhook URL'),
//           ),

//           const SizedBox(height: 32),

//           // Add more settings sections here
//         ],
//       ),
//     );
//   }

//   void _saveWebhookUrl() {
//     if (_webhookController.text.isNotEmpty) {
//       setState(() {
//         AppConfig.webhookUrl = _webhookController.text.trim();
//       });

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Webhook URL saved')));
//     }
//   }
// }
