import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(_ChatMessage(
      text:
          "Halo! Saya GajiBot, asisten virtual Anda untuk informasi gaji ASN. Ada yang bisa saya bantu?",
      isUser: false,
    ));
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.insert(0, _ChatMessage(text: text.trim(), isUser: true));
      // Simulate typing delay
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.insert(
              0,
              _ChatMessage(
                text: _getBotResponse(text.trim()),
                isUser: false,
              ));
        });
      });
    });
  }

  String _getBotResponse(String userMessage) {
    String message = userMessage.toLowerCase();
    if (message.contains('gaji') || message.contains('simulasi')) {
      return "Untuk simulasi gaji, Anda bisa menggunakan fitur Simulasi Gaji di menu utama. Saya akan membantu menghitung estimasi gaji baru berdasarkan golongan dan masa kerja Anda.";
    } else if (message.contains('regulasi') || message.contains('peraturan')) {
      return "Regulasi terbaru tentang kenaikan gaji ASN bisa Anda temukan di menu Berita dan Regulasi. Disana ada informasi lengkap tentang PP terbaru.";
    } else if (message.contains('masalah') || message.contains('lapor')) {
      return "Untuk melaporkan masalah, silakan gunakan fitur Lapor Masalah di menu utama. Tim kami akan segera menindaklanjuti laporan Anda.";
    } else if (message.contains('halo') || message.contains('hai')) {
      return "Halo! Senang bertemu dengan Anda. Ada informasi apa yang Anda butuhkan tentang gaji ASN?";
    } else {
      return "Terima kasih atas pertanyaan Anda. Saya akan membantu Anda dengan informasi seputar gaji ASN. Silakan pilih menu di bawah atau tanyakan langsung.";
    }
  }

  Widget _buildMessage(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: message.isUser
              ? const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: message.isUser ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: message.isUser
                ? const Radius.circular(20)
                : const Radius.circular(4),
            bottomRight: message.isUser
                ? const Radius.circular(4)
                : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu Cepat',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildShortcutChip(
                'Simulasi Gaji',
                Icons.calculate_outlined,
                const Color(0xFF1565C0),
                () => _handleSubmitted('Simulasi gaji'),
              ),
              _buildShortcutChip(
                'Regulasi ASN',
                Icons.article_outlined,
                Colors.green,
                () => _handleSubmitted('Regulasi terbaru'),
              ),
              _buildShortcutChip(
                'Lapor Masalah',
                Icons.report_problem_outlined,
                Colors.orange,
                () => _handleSubmitted('Cara lapor masalah'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutChip(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: color),
        label: Text(label),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration(
                  hintText: 'Ketik pesan Anda...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GajiBot',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Asisten Virtual Anda',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tentang GajiBot'),
                  content: const Text(
                      'GajiBot adalah asisten virtual yang membantu Anda mendapatkan informasi seputar gaji ASN dengan cepat dan akurat.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildShortcutButtons(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
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
