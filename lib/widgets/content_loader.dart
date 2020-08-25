import 'package:flutter/material.dart';

import 'loading_indicator.dart';

typedef ContentLoaderBuilder<T> = Widget Function(BuildContext, T);
typedef FutureCallback<T> = Future<T> Function();

class ContentLoader<T> extends StatefulWidget {
  final FutureCallback<T> futureCallback;
  final ContentLoaderBuilder<T> builder;

  ContentLoader({@required this.builder, @required this.futureCallback});

  @override
  State<StatefulWidget> createState() =>
      _ContentLoaderState<T>(builder, futureCallback);
}

class _ContentLoaderState<T> extends State<ContentLoader> {
  final ContentLoaderBuilder<T> builder;
  final FutureCallback<T> futureCallback;
  Future<T> _future;

  _ContentLoaderState(this.builder, this.futureCallback) {
    _load();
  }

  void _load() {
    _future = futureCallback();
  }

  Widget _error(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Failed to Load"),
        FlatButton(
          child: Text("RETRY"),
          onPressed: () => setState(() => _load()),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: LoadingIndicator());
            break;
          case ConnectionState.done:
            if (snapshot.hasError) return _error(context);
            return builder(context, snapshot.data);
          default:
            return _error(context);
        }
      },
    );
  }
}

// class ContentLoader<T> extends StatelessWidget {
//   final Future<T> future;
//   final ContentLoaderBuilder<T> builder;
//   final void Function() reload;
//   ContentLoader({
//     @required this.future,
//     @required this.builder,
//     this.reload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<T>(
//       future: future,
//       builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return Center(child: LoadingIndicator());
//           case ConnectionState.done:
//             if (snapshot.hasError) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Failed to Load"),
//                   FlatButton(
//                     child: Text("RETRY"),
//                     onPressed: () => reload(),
//                   )
//                 ],
//               );
//             }
//             return builder(context, snapshot.data);
//           default:
//             return Text("Unknown Error");
//         }
//       },
//     );
//   }
// }
