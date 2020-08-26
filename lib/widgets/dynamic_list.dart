import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

typedef DynamicListLoader = FutureOr<Widget> Function(
    BuildContext context, int index);

class DynamicList extends StatefulWidget {
  final DynamicListLoader loader;

  DynamicList({@required this.loader}) : assert(loader != null);

  @override
  State<StatefulWidget> createState() => _DynamicListState(loader);
}

class _DynamicListState extends State<DynamicList> {
  static const _LOAD_OVERSCROLL = 50; // px

  final DynamicListLoader loader;
  final _controller = ScrollController();
  List<Widget> _items = [];
  bool _loading = true; // loading initial item

  _DynamicListState(this.loader);

  @override
  void initState() {
    _controller.addListener(() async {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent + _LOAD_OVERSCROLL) {
        setState(() => _loading = true);
        Widget item = await loader(context, _items.length);
        setState(() {
          _items.add(item);
          _loading = false;
        });
      }
    });
    // FIXME what if disposed?
    Future.value(loader(context, 0)).then((item) {
      _items.add(item);
      setState(() => _loading = false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _items.length == 0) return LoadingIndicator();
    return ListView.builder(
      itemCount: _items.length + (_loading ? 1 : 0),
      controller: _controller,
      itemBuilder: (context, index) {
        if (index == _items.length) return LoadingIndicator();
        return _items[index];
      },
    );
  }
}
