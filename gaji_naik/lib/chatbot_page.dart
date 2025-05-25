import 'package:flutter/material.dart';

class GajiBotPage extends StatefulWidget {
  const GajiBotPage({super.key});

  @override
  _GajiBotPageState createState() => _GajiBotPageState();
}

class _GajiBotPageState extends State<GajiBotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<_ChatMessage> _messages = [];

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.insert(0, _ChatMessage(text: text.trim(), isUser: true));
      // Contoh respon bot sederhana
      _messages.insert(0, _ChatMessage(text: 'Terima kasih, saya menerima pesan Anda: "$text"', isUser: false));
    });
  }

  Widget _buildMessage(_ChatMessage message) {
    final radius = Radius.circular(20);
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[400] : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: radius,
            topRight: radius,
            bottomLeft: message.isUser ? radius : Radius.zero,
            bottomRight: message.isUser ? Radius.zero : radius,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          ActionChip(
            label: const Text('Simulasi Gaji'),
            backgroundColor: Colors.blue.shade100,
            labelStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
            onPressed: () {
              Navigator.pushNamed(context, '/simulasiGaji');
            },
          ),
          ActionChip(
            label: const Text('Regulasi ASN'),
            backgroundColor: Colors.green.shade100,
            labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
            onPressed: () {
              Navigator.pushNamed(context, '/regulasiASN');
            },
          ),
          ActionChip(
            label: const Text('Laporkan Masalah'),
            backgroundColor: Colors.orange.shade100,
            labelStyle: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600),
            onPressed: () {
              Navigator.pushNamed(context, '/laporMasalah');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                hintText: 'Tulis pesan...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue.shade700),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GajiBot',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildShortcutButtons(),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, index) => _buildMessage(_messages[index]),
              ),
            ),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}
