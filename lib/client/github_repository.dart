import 'dart:async';
import '../local/github_cache.dart';
import 'git_hub_client.dart';

class GithubRepository {
  final GithubCache cache;
  final GitHubClient client;

  GithubRepository(this.cache, this.client);

  Future<SearchResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await client.search(term);
      cache.set(term, result);
      return result;
    }
  }
}
