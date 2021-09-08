import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/calendarPageView.dart';


class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //TODO: ドロップダウンリストを作成
        // Expanded(child:),
        Expanded(
          flex: 8,
          child: CalendarPageView(),
        ),
      ],
    );
  }

}