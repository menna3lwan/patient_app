import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';

class ChatScreen extends StatefulWidget {
  final String appointmentId;
  const ChatScreen({super.key, required this.appointmentId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [
    _Message(text: 'مرحباً، أنا جاهزة للاستشارة', isMe: false, time: '10:00 ص'),
    _Message(text: 'أهلاً دكتورة، شكراً لوقتك', isMe: true, time: '10:01 ص'),
    _Message(text: 'أهلاً بيكِ، كيف أقدر أساعدك اليوم؟', isMe: false, time: '10:01 ص'),
  ];

  @override
  void dispose() { _messageController.dispose(); _scrollController.dispose(); super.dispose(); }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() { _messages.add(_Message(text: _messageController.text, isMe: true, time: TimeOfDay.now().format(context))); });
    _messageController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent + 100, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final appointments = Provider.of<AppointmentsProvider>(context);
    final apt = appointments.getAppointmentById(widget.appointmentId);

    if (apt == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(locale.get('error'))));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop()),
        title: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.primaryLight, child: Text(apt.doctor.name.length > 3 ? apt.doctor.name[3] : apt.doctor.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(apt.doctor.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)), const SizedBox(width: 4), Text('متصلة الآن', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color))]),
          ])),
        ]),
        actions: [
          IconButton(icon: const Icon(Iconsax.call), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.video), onPressed: () {}),
          PopupMenuButton(
            icon: const Icon(Iconsax.more),
            itemBuilder: (_) => [PopupMenuItem(child: Text(locale.get('endSession')))],
          ),
        ],
      ),
      body: Column(
        children: [
          // Session info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.primaryLight,
            child: Row(children: [const Icon(Iconsax.info_circle, size: 18, color: AppColors.primary), const SizedBox(width: 8), Expanded(child: Text('الجلسة نشطة • مدة الاستشارة: 30 دقيقة', style: const TextStyle(fontSize: 12, color: AppColors.primary)))]),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
            ),
          ),
          // Input
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom + 12, top: 12),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
            child: Row(children: [
              IconButton(icon: const Icon(Iconsax.attach_circle, color: AppColors.primary), onPressed: () {}),
              Expanded(child: TextField(controller: _messageController, decoration: InputDecoration(hintText: locale.get('typeMessage'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), filled: true, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), onSubmitted: (_) => _sendMessage())),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(width: 48, height: 48, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Iconsax.send_1, color: Colors.white, size: 20)),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text, time;
  final bool isMe;
  _Message({required this.text, required this.isMe, required this.time});
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  const _MessageBubble({required this.message});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.only(bottom: 12, left: message.isMe ? 50 : 0, right: message.isMe ? 0 : 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(message.text, style: TextStyle(color: message.isMe ? Colors.white : null)),
          const SizedBox(height: 4),
          Text(message.time, style: TextStyle(fontSize: 10, color: message.isMe ? Colors.white70 : Theme.of(context).textTheme.bodySmall?.color)),
        ]),
      ),
    );
  }
}
