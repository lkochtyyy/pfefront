import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatBotSupportPage extends StatefulWidget {
  const ChatBotSupportPage({super.key});

  @override
  State<ChatBotSupportPage> createState() => _ChatBotSupportPageState();
}

class _ChatBotSupportPageState extends State<ChatBotSupportPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [
    {'sender': 'bot', 'text': 'Bonjour 👋 ! Comment puis-je vous aider ?'},
  ];
  bool _isBotTyping = false;

  final List<String> _quickReplies = [
    "Problème de paiement",
    "Je veux annuler",
    "Mon compte a été bloqué",
    "Comment modifier une annonce ?",
  ];

  void _scrollToBottom() {
    Future.delayed(300.ms, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _simulateBotResponse(String userText) async {
    setState(() {
      _isBotTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(1500.ms); // délai simulé

    setState(() {
      _isBotTyping = false;
      _messages.add({'sender': 'bot', 'text': 'Merci pour votre message ! 😊'});
    });

    _scrollToBottom();
  }

  void _sendMessage(String? optionalText) {
    final text = optionalText ?? _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
    });

    _controller.clear();
    _simulateBotResponse(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nouveau fond dégradé harmonisé avec l’icône
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 66, 154, 221), Color(0xFFE5F6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 110,
                        width: 120,
                        child: ClipOval(
                          child: Lottie.asset(
                            'assets/json/chatbot.json',
                            fit: BoxFit.cover,
                            repeat: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Titou ',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Disponible pour vous aider',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Liste des messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _messages.length + (_isBotTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isBotTyping && index == _messages.length) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              height: 28,
                              width: 80,
                              child: Lottie.asset(
                                'assets/json/typing.json',
                                repeat: true,
                              ),
                            ),
                          ),
                        ).animate().fade().slideX(begin: -0.2);
                      }

                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'user';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.white
                                      : const Color(0xFFE5F6FF),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(18),
                                    topRight: const Radius.circular(18),
                                    bottomLeft:
                                        Radius.circular(isUser ? 18 : 0),
                                    bottomRight:
                                        Radius.circular(isUser ? 0 : 18),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        msg['text'] ?? '',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (isUser) const SizedBox(width: 6),
                                    if (isUser)
                                      Icon(MdiIcons.accountCircle,
                                          color: Colors.grey.shade600,
                                          size: 18),
                                  ],
                                ),
                              ),
                              if (!isUser)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Lottie.asset(
                                    'assets/json/chatbot.json',
                                    height: 30,
                                    repeat: true,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fade(duration: 400.ms)
                          .scale(begin: const Offset(0.95, 0.95));
                    },
                  ),
                ),

                // Suggestions rapides
                if (!_isBotTyping)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _quickReplies.map((text) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            backgroundColor: Colors.white,
                            label: Text(
                              text,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0078D4),
                              ),
                            ),
                            onPressed: () => _sendMessage(text),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Zone de saisie
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: GoogleFonts.poppins(),
                          decoration: InputDecoration(
                            hintText: 'Écrivez un message...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _sendMessage(null),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            MdiIcons.send,
                            color: const Color(0xFF0078D4),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
