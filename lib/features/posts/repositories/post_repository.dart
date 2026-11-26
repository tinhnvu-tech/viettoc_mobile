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

    return _fetchPostsByCategoryId(catId, page: page, perPage: perPage);
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

    return _fetchPostsByCategoryId(catId, page: page, perPage: perPage);
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

    return _fetchPostsByCategoryId(catId, page: page, perPage: perPage);
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

  Future<List<PostModel>> _fetchPostsByCategoryId(
    int categoryId, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        'posts',
        queryParameters: {
          'categories': categoryId,
          'page': page,
          'per_page': perPage,
          '_embed': 'true',
        },
      );

      final List rawList = response.data as List;
      return rawList.map((item) => PostModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Lỗi kết nối REST API cho Category $categoryId: $e');
    }
  }
}
