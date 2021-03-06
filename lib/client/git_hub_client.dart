import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xxxxxxx/model/search_result_item.dart';

class GitHubClient {
  Future<SearchResult> search(String term) async {
    final String url = 'https://api.github.com/search/repositories?q=';
    final response = await http
        .get(Uri.parse('$url$term&sort=stars&order=desc&per_page=30'));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
}

class SearchResult {
  final List<SearchResultItem> items;

  const SearchResult({this.items});

  static SearchResult fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map((dynamic item) =>
            SearchResultItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return SearchResult(items: items);
  }
}

class SearchResultError {
  final String message;

  const SearchResultError({this.message});

  static SearchResultError fromJson(dynamic json) {
    return SearchResultError(
      message: json['message'] as String,
    );
  }
}
