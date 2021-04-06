import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xxxxxxx/search_form.dart';
import 'github_cache.dart';
import 'git_hub_client.dart';
import 'github_repository.dart';
import 'github_search_bloc.dart';

void main() {
  final GithubRepository _githubRepository = GithubRepository(
    GithubCache(),
    GitHubClient(),
  );

  runApp(App(githubRepository: _githubRepository));
}

class App extends StatelessWidget {
  final GithubRepository githubRepository;

  const App({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Github Search',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Github Search'),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (context) =>
              GithubSearchBloc(githubRepository: githubRepository),
          child: SearchForm(),
        ),
      ),
    );
  }
}
