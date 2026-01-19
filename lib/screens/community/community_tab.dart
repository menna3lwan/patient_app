import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final community = Provider.of<CommunityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(locale.get('communityTitle'))),
      body: Column(
        children: [
          // Write post card
          GestureDetector(
            onTap: () => context.push('/create-post'),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
              child: Row(children: [
                CircleAvatar(radius: 22, backgroundColor: AppColors.primaryLight, child: const Icon(Iconsax.user, color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: Text(locale.get('writePost'), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))),
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)), child: const Icon(Iconsax.edit, color: Colors.white, size: 18)),
              ]),
            ),
          ),
          // Posts list
          Expanded(
            child: community.posts.isEmpty
                ? EmptyState(icon: Iconsax.message, title: locale.get('noResults'), buttonText: locale.get('writePost'), onButtonPressed: () => context.push('/create-post'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: community.posts.length,
                    itemBuilder: (context, index) => _PostCard(post: community.posts[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final dynamic post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final community = Provider.of<CommunityProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(children: [
              CircleAvatar(radius: 20, backgroundColor: AppColors.primaryLight, child: post.isAnonymous ? const Icon(Iconsax.user, color: AppColors.primary, size: 20) : Text(post.userName.isNotEmpty ? post.userName[0] : '👤', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(post.isAnonymous ? locale.get('anonymous') : post.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(post.timeAgo, style: Theme.of(context).textTheme.bodySmall),
              ])),
              PopupMenuButton(
                icon: Icon(Iconsax.more, color: Theme.of(context).textTheme.bodySmall?.color),
                itemBuilder: (_) => [PopupMenuItem(value: 'report', child: Text(locale.get('reportPost'))), if (post.userId == 'me') PopupMenuItem(value: 'delete', child: Text(locale.get('delete')))],
                onSelected: (v) { if (v == 'delete') community.deletePost(post.id); },
              ),
            ]),
            const SizedBox(height: 12),
            // Content
            Text(post.content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
            const SizedBox(height: 16),
            // Actions
            Row(children: [
              _ActionButton(icon: post.isLiked ? Iconsax.heart5 : Iconsax.heart, label: '${post.likes}', color: post.isLiked ? AppColors.error : null, onTap: () => community.toggleLike(post.id)),
              const SizedBox(width: 24),
              _ActionButton(icon: Iconsax.message, label: '${post.commentsCount}', onTap: () => _showComments(context, post)),
              const Spacer(),
              _ActionButton(icon: Iconsax.share, label: locale.get('share'), onTap: () {}),
            ]),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext context, dynamic post) {
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final community = Provider.of<CommunityProvider>(context, listen: false);
    final controller = TextEditingController();
    bool isAnonymous = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2))),
            Text(locale.get('comments'), style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            Expanded(
              child: post.comments.isEmpty
                  ? Center(child: Text(locale.get('noResults'), style: Theme.of(context).textTheme.bodySmall))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: post.comments.length,
                      itemBuilder: (_, i) {
                        final c = post.comments[i];
                        return ListTile(
                          leading: CircleAvatar(radius: 18, backgroundColor: AppColors.primaryLight, child: Text(c.isAnonymous ? '👤' : (c.userName.isNotEmpty ? c.userName[0] : ''), style: const TextStyle(fontSize: 14))),
                          title: Text(c.isAnonymous ? locale.get('anonymous') : c.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(c.content),
                        );
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, left: 16, right: 16),
              child: Column(children: [
                Row(children: [Checkbox(value: isAnonymous, onChanged: (v) => setState(() => isAnonymous = v ?? false), activeColor: AppColors.primary), Text(locale.get('postAnonymously'), style: Theme.of(context).textTheme.bodySmall)]),
                Row(children: [
                  Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: locale.get('writeComment'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Iconsax.send_1, color: AppColors.primary), onPressed: () { if (controller.text.isNotEmpty) { community.addComment(post.id, controller.text, isAnonymous: isAnonymous); controller.clear(); setState(() {}); } }),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).textTheme.bodySmall?.color;
    return GestureDetector(onTap: onTap, child: Row(children: [Icon(icon, size: 20, color: c), const SizedBox(width: 6), Text(label, style: TextStyle(color: c, fontSize: 13))]));
  }
}
