import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class ContentLoader<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) builder;
  final void Function(Exception) reload;
  ContentLoader({this.future, this.builder, this.reload});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder<T>(
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
                      onPressed: () => reload(snapshot.error),
                    )
                  ],
                );
              }
              return builder(snapshot.data);
            default:
              return Text("Unknown Error");
          }
        },
      ),
    );
  }
}
