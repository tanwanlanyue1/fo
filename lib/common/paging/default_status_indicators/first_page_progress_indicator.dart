import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

class FirstPageProgressIndicator extends StatelessWidget {
  const FirstPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: LoadingIndicator(),
  );
}
