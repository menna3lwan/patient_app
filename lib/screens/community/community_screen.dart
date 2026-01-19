import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../config/providers.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final posts = provider.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المجتمع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showRulesDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Safe Space Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: AppColors.primaryLight.withOpacity(0.3),
            child: const Row(
              children: [
                Icon(Icons.shield, size: 18, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'مساحة آمنة للنساء فقط 💕',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Post Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'شاركي تجربتك أو اطرحي سؤالاً...',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: () {
                    if (_postController.text.trim().isEmpty) return;

                    provider.addPost(_postController.text.trim());
                    _postController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم نشر مشاركتك'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Posts
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                post.userName.isNotEmpty
                                    ? post.userName[0]
                                    : '؟',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.userName.isNotEmpty
                                        ? post.userName
                                        : 'مستخدمة مجهولة',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'منذ قليل',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_horiz, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.content,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  provider.toggleLike(post.id),
                              child: Row(
                                children: [
                                  Icon(
                                    post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: post.isLiked
                                        ? AppColors.error
                                        : Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${post.likes}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${post.commentsCount}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.share,
                                size: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ الرابط'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قواعد المجتمع'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• احترمي الجميع وتجنبي الإساءة'),
            SizedBox(height: 8),
            Text('• لا تشاركي معلومات شخصية'),
            SizedBox(height: 8),
            Text('• المحتوى الطبي ليس بديلاً عن الاستشارة'),
            SizedBox(height: 8),
            Text('• أبلغي عن أي محتوى غير لائق'),
            SizedBox(height: 8),
            Text('• كوني إيجابية وداعمة 💕'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
