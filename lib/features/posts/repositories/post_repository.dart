import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/providers/language_provider.dart';
import '../models/post_model.dart';

class PostRepository {
  final Dio _dio;

  PostRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Accept': 'application/json',
                },
              ),
            );

  /// Tải danh sách Hoạt Động & Dự Án
  Future<List<PostModel>> fetchActivities({
    required AppLanguage language,
    int page = 1,
    int perPage = 10,
  }) async {
    final catId = language == AppLanguage.vi
        ? ApiConstants.catActivitiesVi
        : ApiConstants.catActivitiesEn;

    return _fetchPostsByCategoryId(catId, language: language, page: page, perPage: perPage);
  }

  /// Tải danh sách Chia Sẻ Tâm Tình
  Future<List<PostModel>> fetchStories({
    required AppLanguage language,
    int page = 1,
    int perPage = 10,
  }) async {
    final catId = language == AppLanguage.vi
        ? ApiConstants.catStoriesVi
        : ApiConstants.catStoriesEn;

    return _fetchPostsByCategoryId(catId, language: language, page: page, perPage: perPage);
  }

  /// Tải danh sách Tin Buôn Làng Mới Nhất
  Future<List<PostModel>> fetchLatestNews({
    required AppLanguage language,
    int page = 1,
    int perPage = 5,
  }) async {
    final catId = language == AppLanguage.vi
        ? ApiConstants.catNewsVi
        : ApiConstants.catNewsEn;

    return _fetchPostsByCategoryId(catId, language: language, page: page, perPage: perPage);
  }

  /// Lấy chi tiết một bài viết theo ID
  Future<PostModel> fetchPostDetail(int id) async {
    try {
      final response = await _dio.get(
        'posts/$id',
        queryParameters: {'_embed': 'true'},
      );
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Không thể tải bài viết $id: $e');
    }
  }

  static final RegExp _vietnameseDiacriticsRegex = RegExp(
    r'[àáảãạăắằẳẵặâấầẩẫậèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵđĐ]',
    caseSensitive: false,
  );

  static bool _hasVietnameseDiacritics(String text) {
    return _vietnameseDiacriticsRegex.hasMatch(text);
  }

  Future<List<PostModel>> _fetchPostsByCategoryId(
    int categoryId, {
    required AppLanguage language,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // Yêu cầu thêm một số bài để phòng trường hợp lọc bớt bài sai ngôn ngữ
      final fetchCount = (perPage * 1.5).ceil();
      final response = await _dio.get(
        'posts',
        queryParameters: {
          'categories': categoryId,
          'page': page,
          'per_page': fetchCount,
          '_embed': 'true',
        },
      );

      final List rawList = response.data as List;
      final posts = rawList
          .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // Kiểm soát cách ly ngôn ngữ tuyệt đối (Strict Language Separation)
      List<PostModel> filtered;
      if (language == AppLanguage.vi) {
        filtered = posts.where((p) {
          return _hasVietnameseDiacritics(p.title) || _hasVietnameseDiacritics(p.excerpt);
        }).toList();
      } else {
        filtered = posts.where((p) {
          return !_hasVietnameseDiacritics(p.title);
        }).toList();
      }

      return filtered.take(perPage).toList();
    } catch (e) {
      throw Exception('Lỗi kết nối REST API cho Category $categoryId: $e');
    }
  }
}
