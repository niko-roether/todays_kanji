import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/content_loader.dart';

typedef SearchResultBuilder = Widget Function(
  BuildContext context,
  String query,
);
typedef SearchSuggestionFetcher = FutureOr<List<String>> Function(String query);

abstract class Search extends SearchDelegate {
  final String initial;

  Search({this.initial = ""}) : assert(initial != null) {
    query = initial;
  }

  FutureOr<List<String>> fetchSuggestions();
  List<String> getRecent();

  void addRecentSearch(String query);

  Widget _createListItem(BuildContext context, String text, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        query = text;
        showResults(context);
      },
      trailing: IconButton(
        // Hacking a top left arrow icon cuz that doesn't exist apparently
        icon: Icon(
          Icons.call_made,
          textDirection: TextDirection.rtl,
        ),
        onPressed: () => query = text,
      ),
    );
  }

  List<Widget> _createListItemsFromStrings(
    BuildContext context,
    List<String> strings,
    IconData icon,
  ) {
    return strings
        .map<Widget>((e) => _createListItem(context, e, icon))
        .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () => close(context, null),
    );
  }

  @override
  @mustCallSuper
  Widget buildResults(BuildContext context) {
    addRecentSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Widget> suggestions =
        _createListItemsFromStrings(context, getRecent(), Icons.access_time);
    if (query.isNotEmpty) {
      suggestions.add(ContentLoader<List<String>>(
        futureCallback: () => fetchSuggestions(),
        builder: (context, suggestionStrings) {
          return Wrap(
            children: _createListItemsFromStrings(
              context,
              suggestionStrings,
              Icons.search,
            ),
          );
        },
      ));
    }
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => suggestions[index],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }
}
