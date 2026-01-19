import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() { _contentController.dispose(); super.dispose(); }

  Future<void> _publish() async {
    if (_contentController.text.trim().isEmpty) return;
    final community = Provider.of<CommunityProvider>(context, listen: false);
    await community.addPost(_contentController.text.trim(), isAnonymous: _isAnonymous);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final community = Provider.of<CommunityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.close_circle), onPressed: () => context.pop()),
        title: Text(locale.get('writePost')),
        actions: [
          TextButton(
            onPressed: _contentController.text.trim().isNotEmpty ? _publish : null,
            child: Text(locale.get('publish'), style: TextStyle(fontWeight: FontWeight.bold, color: _contentController.text.trim().isNotEmpty ? AppColors.primary : Theme.of(context).disabledColor)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: AppColors.primaryLight, child: Icon(_isAnonymous ? Iconsax.user : Iconsax.user5, color: AppColors.primary)),
                const SizedBox(width: 14),
                Text(_isAnonymous ? locale.get('anonymous') : 'أنا', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: locale.get('writePost'),
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const Divider(),
            Row(
              children: [
                Checkbox(value: _isAnonymous, onChanged: (v) => setState(() => _isAnonymous = v ?? false), activeColor: AppColors.primary),
                Text(locale.get('postAnonymously'), style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                IconButton(icon: const Icon(Iconsax.image, color: AppColors.primary), onPressed: () {}),
                IconButton(icon: const Icon(Iconsax.emoji_happy, color: AppColors.primary), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
