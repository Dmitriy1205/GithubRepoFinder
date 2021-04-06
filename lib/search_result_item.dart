import 'dart:convert';
import 'github_user.dart';

List<SearchResultItem> itemsFromJson(String str) => List<SearchResultItem>.from(
    json.decode(str).map((x) => SearchResultItem.fromJson(x)));

String itemsToJson(List<SearchResultItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchResultItem {
  final String fullName;
  final String htmlUrl;
  final GithubUser owner;
  final int stargazersCount;

  const SearchResultItem({
    this.fullName,
    this.htmlUrl,
    this.owner,
    this.stargazersCount,
  });

  static SearchResultItem fromJson(dynamic json) {
    return SearchResultItem(
        fullName: json['full_name'],
        htmlUrl: json['html_url'],
        owner: GithubUser.fromJson(json['owner']),
        stargazersCount: json['stargazers_count']);
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'html_url': htmlUrl,
        'owner': owner,
        'stargazers_count': stargazersCount,
      };
}
