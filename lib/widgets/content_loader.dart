import 'package:flutter/material.dart';

import 'loading_indicator.dart';

typedef ContentLoaderBuilder<T> = Widget Function(BuildContext, T);

class ContentLoader<T> extends StatelessWidget {
  final Future<T> future;
  final ContentLoaderBuilder<T> builder;
  final void Function() reload;
  ContentLoader({
    @required this.future,
    @required this.builder,
    this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LoadingIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Failed to Load"),
                  FlatButton(
                    child: Text("RETRY"),
                    onPressed: () => reload(),
                  )
                ],
              );
            }
            return builder(context, snapshot.data);
          default:
            return Text("Unknown Error");
        }
      },
    );
  }
}
