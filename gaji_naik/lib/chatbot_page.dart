import 'package:flutter/material.dart';

class GajiBotPage extends StatefulWidget {
  const GajiBotPage({super.key});

  @override
  _GajiBotPageState createState() => _GajiBotPageState();
}

class _GajiBotPageState extends State<GajiBotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = []; // Placeholder for messages

  void _handleSubmitted(String text) {
    _textController.clear();
    // TODO: Add logic to handle user input and generate bot response
    // For now, just add the user message to the list
    setState(() {
      _messages.add("User: $text");
    });
  }

  Widget _buildMessage(String message, bool isUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.android, color: Colors.white), // Placeholder icon for bot
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 5.0,
                  borderRadius: isUser
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                  color: isUser ? Colors.blue : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text("U"), // Placeholder for user initial
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.blue[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.tealAccent,
                child: Icon(Icons.computer, color: Colors.blue[700]), // Placeholder icon for GajiBot
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GajiBot',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                // Placeholder: Navigate back or to home
                Navigator.pop(context); // Example: Just pop the current page

              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) {
                String message = _messages[_messages.length - 1 - index];
                bool isUser = message.startsWith("User: ");
                if (isUser) {
                  message = message.substring(6); // Remove "User: " prefix
                }
                return _buildMessage(message, isUser);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Placeholder: Navigate to Simulasi Gaji page
                    Navigator.pushNamed(context, '/simulasiGaji'); // Example route name
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Simulasi gaji'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder: Navigate to Regulasi ASN section/page
                    Navigator.pushNamed(context, '/regulasiASN'); // Example route name
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Regulasi ASN'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder: Navigate to Lapor Masalah page
                    Navigator.pushNamed(context, '/laporMasalah'); // Example route name
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Laporkan Masalah'),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'tulis pesan disini'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}