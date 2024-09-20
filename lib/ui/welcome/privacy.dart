import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = void Function(String key);

class PrivacyView extends StatefulWidget {
  final String data;
  final List<String> keys;
  final TextStyle? style;
  final TextStyle? keyStyle;
  final OnTapCallback? onTapCallback;

  const PrivacyView({
    super.key,
    required this.data,
    required this.keys,
    this.style,
    this.keyStyle,
    this.onTapCallback,
  });

  @override
  _PrivacyViewState createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  final List<String> _list = [];

  @override
  void initState() {
    _split();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <InlineSpan>[
            ..._list.map((e) {
              if (widget.keys.contains(e)) {
                return TextSpan(
                  text: e,
                  style: widget.keyStyle ??
                      TextStyle(color: Theme.of(context).primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.onTapCallback?.call(e);
                    },
                );
              } else {
                return TextSpan(text: e, style: widget.style);
              }
            }).toList()
          ]),
    );
  }

  void _split() {
    int startIndex = 0;
    Map<String, dynamic>? index;
    while ((index = _nextIndex(startIndex)) != null) {
      int i = index?['index'];
      String sub = widget.data.substring(startIndex, i);
      if (sub.isNotEmpty) {
        _list.add(sub);
      }
      _list.add(index?['key']);

      startIndex = i + (index?['key'] as String).length;
    }
  }

  Map<String, dynamic>? _nextIndex(int startIndex) {
    int currentIndex = widget.data.length;
    String? key;
    for (var element in widget.keys) {
      int index = widget.data.indexOf(element, startIndex);
      if (index != -1 && index < currentIndex) {
        currentIndex = index;
        key = element;
      }
    }
    if (key == null) {
      return null;
    }
    return {'key': key, 'index': currentIndex};
  }
}
