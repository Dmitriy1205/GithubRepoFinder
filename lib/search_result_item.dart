import 'github_user.dart';

class SearchResultItem {
  final String fullName;
  final String htmlUrl;
  final GithubUser owner;
  final int stargazersCount;

  SearchResultItem({
    this.fullName,
    this.htmlUrl,
    this.owner,
    this.stargazersCount,
  });

  static const String Fullname = 'full_name';
  static const String Htmlurl = 'html_url';
  static const String Owner = 'owner';
  static const String Stargazer = 'stargazers_count';

  static SearchResultItem fromJson(dynamic json) {
    return SearchResultItem(
        fullName: json[Fullname],
        htmlUrl: json[Htmlurl],
        owner: GithubUser.fromJson(json[Owner]),
        stargazersCount: json[Stargazer]);
  }

  Map<String, dynamic> toJson() => {
        Fullname: fullName,
        Htmlurl: htmlUrl,
        Owner: owner,
        Stargazer: stargazersCount,
      };
}
