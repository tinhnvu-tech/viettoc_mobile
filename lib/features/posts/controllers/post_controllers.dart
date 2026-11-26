import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/language_provider.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

/// Provider tải danh sách Hoạt Động & Dự Án
final activitiesProvider = FutureProvider.autoDispose<List<PostModel>>((ref) async {
  final currentLang = ref.watch(languageProvider);
  final repo = ref.watch(postRepositoryProvider);
  return repo.fetchActivities(language: currentLang);
});

/// Provider tải danh sách Chia Sẻ Tâm Tình
final storiesProvider = FutureProvider.autoDispose<List<PostModel>>((ref) async {
  final currentLang = ref.watch(languageProvider);
  final repo = ref.watch(postRepositoryProvider);
  return repo.fetchStories(language: currentLang);
});

/// Provider tải Tin Buôn Làng Mới Nhất cho Trang Nhà
final latestNewsProvider = FutureProvider.autoDispose<List<PostModel>>((ref) async {
  final currentLang = ref.watch(languageProvider);
  final repo = ref.watch(postRepositoryProvider);
  return repo.fetchLatestNews(language: currentLang, perPage: 5);
});
