import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xxxxxxx/search_result_item.dart';
import 'github_search_bloc.dart';
import 'github_search_event.dart';
import 'github_search_state.dart';

class SearchForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: _SearchBar()),
          SizedBox(
            height: 40,
          ),
          _SearchBody()
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  GithubSearchBloc _githubSearchBloc;

  @override
  void initState() {
    super.initState();
    _githubSearchBloc = BlocProvider.of<GithubSearchBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      textAlign: TextAlign.center,
      autocorrect: false,
      onChanged: (text) {
        _githubSearchBloc.add(
          TextChanged(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: 'Search Repository',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _githubSearchBloc.add(TextChanged(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubSearchBloc, GithubSearchState>(
      bloc: BlocProvider.of<GithubSearchBloc>(context),
      builder: (BuildContext context, GithubSearchState state) {
        if (state is SearchStateEmpty) {
          return Text('Please enter a term to begin');
        }
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? Text('No Results')
              : Expanded(child: _SearchResults(items: state.items));
        }
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<SearchResultItem> items;

  const _SearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(
          item: items[index],
        );
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final SearchResultItem item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 2.0,
          child: Row(
            children: [
              CircleAvatar(child: Image.network(item.owner.avatarUrl)),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 230,
                    child: Text(
                      item.fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 10),
                  //Text(item.htmlUrl),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.yellow[700],
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(item.stargazersCount.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        if (await canLaunch(item.htmlUrl)) {
          await launch(item.htmlUrl);
        }
      },
    );
  }
}
