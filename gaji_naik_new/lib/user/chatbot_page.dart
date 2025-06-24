import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // ✅ GEMINI API CONFIGURATION
  static const String _apiKey =
      'AIzaSyAGHjNd2WwLXoYixmEZP_zM82GP3USdAM8'; // Ganti dengan API key Anda
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _loadUserData();
    _addWelcomeMessage();
  }

  // ✅ INITIALIZE GEMINI MODEL
  void _initializeGemini() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp', // ✅ MENGGUNAKAN GEMINI 2.0 FLASH
      apiKey: _apiKey,
      systemInstruction: Content.system('''
Anda adalah GajiBot, asisten virtual khusus untuk aplikasi Gaji Naik yang membantu ASN (Aparatur Sipil Negara) Indonesia. 

KONTEKS APLIKASI:
- Aplikasi "Gaji Naik" adalah platform untuk simulasi dan informasi gaji ASN
- Fitur utama: Simulasi Gaji, Berita & Regulasi, Edukasi, Laporan Masalah
- Target pengguna: PNS, PPPK, dan ASN lainnya di Indonesia

TUGAS ANDA:
1. Memberikan informasi akurat tentang gaji ASN berdasarkan regulasi terbaru
2. Membantu pengguna memahami sistem penggajian ASN
3. Menjelaskan cara menggunakan fitur-fitur aplikasi
4. Memberikan panduan terkait simulasi gaji berdasarkan golongan dan masa kerja
5. Menginformasikan regulasi dan peraturan terbaru tentang gaji ASN

GAYA KOMUNIKASI:
- Ramah, profesional, dan mudah dipahami
- Gunakan bahasa Indonesia yang baik dan benar
- Berikan jawaban yang konkret dan actionable
- Jika tidak tahu jawaban pasti, arahkan ke fitur yang tepat di aplikasi

INFORMASI KHUSUS:
- PP No. 15 Tahun 2024 tentang kenaikan gaji ASN
- Sistem golongan I/a sampai IV/e
- Komponen gaji: Gaji pokok, Tunjangan Kinerja, Tunjangan Keluarga, dll.
- Masa kerja mempengaruhi kenaikan berkala

Selalu akhiri dengan ajakan untuk menggunakan fitur aplikasi yang relevan.
      '''),
    );

    _chatSession = _model.startChat();
  }

  // ✅ LOAD USER DATA FROM FIREBASE
  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _addWelcomeMessage() {
    String userName = userData?['namaLengkap'] ?? 'Pengguna';
    _messages.add(_ChatMessage(
      text:
          "Halo ${userName}! 👋\n\nSaya GajiBot, asisten virtual Anda untuk informasi gaji ASN. Saya dapat membantu Anda dengan:\n\n🧮 Simulasi gaji berdasarkan golongan\n📋 Informasi regulasi terbaru\n📚 Panduan penggunaan aplikasi\n❓ Pertanyaan seputar gaji ASN\n\nAda yang bisa saya bantu hari ini?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  // ✅ ENHANCED MESSAGE HANDLING WITH GEMINI
  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage = text.trim();
    _textController.clear();

    setState(() {
      _messages.insert(
          0,
          _ChatMessage(
            text: userMessage,
            isUser: true,
            timestamp: DateTime.now(),
          ));
      _isLoading = true;
    });

    try {
      // ✅ ENHANCE USER MESSAGE WITH CONTEXT
      String enhancedMessage = _addContextToMessage(userMessage);

      // ✅ SEND TO GEMINI API
      final response =
          await _chatSession.sendMessage(Content.text(enhancedMessage));

      String botResponse = response.text ??
          'Maaf, saya tidak dapat memproses permintaan Anda saat ini.';

      // ✅ ADD QUICK ACTIONS TO RESPONSE
      botResponse = _enhanceResponseWithActions(botResponse, userMessage);

      setState(() {
        _messages.insert(
            0,
            _ChatMessage(
              text: botResponse,
              isUser: false,
              timestamp: DateTime.now(),
            ));
        _isLoading = false;
      });

      // ✅ SAVE CHAT HISTORY TO FIREBASE
      _saveChatHistory(userMessage, botResponse);
    } catch (e) {
      print('Error getting Gemini response: $e');
      setState(() {
        _messages.insert(
            0,
            _ChatMessage(
              text:
                  'Maaf, terjadi kesalahan saat menghubungi server. Silakan coba lagi dalam beberapa saat. 🔄',
              isUser: false,
              timestamp: DateTime.now(),
            ));
        _isLoading = false;
      });
    }
  }

  // ✅ ADD USER CONTEXT TO MESSAGE
  String _addContextToMessage(String message) {
    String context = message;

    if (userData != null) {
      context += '\n\nKONTEKS PENGGUNA:';
      if (userData!['namaLengkap'] != null) {
        context += '\n- Nama: ${userData!['namaLengkap']}';
      }
      if (userData!['nip'] != null) {
        context += '\n- NIK: ${userData!['nip']}';
      }
    }

    context +=
        '\n\nSilakan berikan jawaban yang spesifik dan praktis untuk ASN Indonesia.';

    return context;
  }

  // ✅ ENHANCE RESPONSE WITH QUICK ACTIONS
  String _enhanceResponseWithActions(String response, String userMessage) {
    String enhanced = response;

    // Add relevant app features based on context
    if (userMessage.toLowerCase().contains(RegExp(r'simulasi|gaji|hitung'))) {
      enhanced +=
          '\n\n💡 *Gunakan fitur Simulasi Gaji di aplikasi untuk perhitungan yang akurat!*';
    } else if (userMessage
        .toLowerCase()
        .contains(RegExp(r'regulasi|peraturan|pp|undang'))) {
      enhanced +=
          '\n\n📄 *Cek menu Berita & Regulasi untuk informasi terkini!*';
    } else if (userMessage
        .toLowerCase()
        .contains(RegExp(r'masalah|lapor|keluhan'))) {
      enhanced +=
          '\n\n📝 *Gunakan fitur Laporan Masalah untuk bantuan lebih lanjut!*';
    } else if (userMessage
        .toLowerCase()
        .contains(RegExp(r'belajar|edukasi|tutorial'))) {
      enhanced +=
          '\n\n🎓 *Kunjungi menu Edukasi untuk pembelajaran lebih mendalam!*';
    }

    return enhanced;
  }

  // ✅ SAVE CHAT HISTORY TO FIREBASE
  Future<void> _saveChatHistory(String userMessage, String botResponse) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('chat_history')
            .doc(user.uid)
            .collection('conversations')
            .add({
          'userMessage': userMessage,
          'botResponse': botResponse,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'model': 'gemini-2.0-flash-exp',
        });
      }
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  Widget _buildMessage(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.black45,
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildShortcutButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan Cepat',
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
                'Simulasi Gaji PNS',
                Icons.calculate_outlined,
                const Color(0xFF1565C0),
                () => _handleSubmitted(
                    'Bagaimana cara menghitung simulasi gaji PNS?'),
              ),
              _buildShortcutChip(
                'PP No. 15 Tahun 2024',
                Icons.article_outlined,
                Colors.green,
                () => _handleSubmitted(
                    'Jelaskan tentang PP No. 15 Tahun 2024 kenaikan gaji ASN'),
              ),
              _buildShortcutChip(
                'Tunjangan Kinerja',
                Icons.payments_outlined,
                Colors.purple,
                () =>
                    _handleSubmitted('Bagaimana sistem tunjangan kinerja ASN?'),
              ),
              _buildShortcutChip(
                'Kenaikan Berkala',
                Icons.trending_up_outlined,
                Colors.orange,
                () => _handleSubmitted('Kapan saya bisa naik gaji berkala?'),
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
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Tanyakan tentang gaji ASN...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: _isLoading
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading
                  ? null
                  : () => _handleSubmitted(_textController.text),
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
                  'Powered by Gemini 2.0 Flash',
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
                  title: const Row(
                    children: [
                      Icon(Icons.smart_toy, color: Color(0xFF1565C0)),
                      SizedBox(width: 8),
                      Text('Tentang GajiBot'),
                    ],
                  ),
                  content: const Text(
                    'GajiBot adalah asisten virtual bertenaga Gemini 2.0 Flash yang membantu Anda mendapatkan informasi akurat seputar gaji ASN berdasarkan regulasi terbaru.\n\n'
                    'Fitur:\n'
                    '• Informasi regulasi PP No. 15 Tahun 2024\n'
                    '• Panduan simulasi gaji\n'
                    '• Tips kenaikan berkala\n'
                    '• Konsultasi sistem penggajian ASN',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
