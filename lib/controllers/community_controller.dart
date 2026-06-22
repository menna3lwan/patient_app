import 'package:get/get.dart';
import '../models/models.dart';

class CommunityController extends GetxController {
  final posts = RxList<PostModel>(MockData.posts);
  final isLoading = false.obs;

  Future<void> addPost(String content, {bool isAnonymous = false}) async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 300));

    posts.insert(
      0,
      PostModel(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'me',
        userName: isAnonymous ? '' : 'أنا',
        content: content,
        isAnonymous: isAnonymous,
      ),
    );

    isLoading.value = false;
  }

  void toggleLike(String postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = posts[index];
    post.isLiked = !post.isLiked;
    post.likes += post.isLiked ? 1 : -1;
    posts.refresh();
  }

  void deletePost(String postId) {
    posts.removeWhere((p) => p.id == postId);
  }

  void addComment(
    String postId,
    String content, {
    bool isAnonymous = false,
  }) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    posts[index].comments.add(
          CommentModel(
            id: 'c_${DateTime.now().millisecondsSinceEpoch}',
            userId: 'me',
            userName: isAnonymous ? '' : 'أنا',
            content: content,
            isAnonymous: isAnonymous,
          ),
        );

    posts[index].commentsCount++;
    posts.refresh();
  }
}
