import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final SearchDelegate searchDelegate;

  SearchButton({this.searchDelegate}) : assert(searchDelegate != null);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () => showSearch(context: context, delegate: searchDelegate),
    );
  }
}
