/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_base.dart';

class TdLoadingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdLoadingPageState();
}

class _TdLoadingPageState extends State<TdLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Loading示例页'),
        ),
        body: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _dividerWidget("类型"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        TDLoading.show(
                            context: context,
                            duration: 2,
                            icon: TDLoadingIcon.circle);
                      },
                      child: const Text('纯图标-转圈')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        TDLoading.show(
                            context: context,
                            duration: 2,
                            icon: TDLoadingIcon.activity);
                      },
                      child: const Text('纯图标-菊花')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        TDLoading.show(
                            context: context,
                            duration: 2,
                            icon: TDLoadingIcon.point);
                      },
                      child: const Text('纯图标-点')),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    TDLoading.show(
                        context: context, duration: 2, text: "加载中...");
                  },
                  child: const Text('纯文字')),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      TDLoading.show(
                          context: context,
                          duration: 2,
                          text: "加载中...",
                          icon: TDLoadingIcon.activity);
                    },
                    child: const Text('图标+文字 竖排')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      TDLoading.show(
                          context: context,
                          duration: 2,
                          text: "加载中...",
                          icon: TDLoadingIcon.activity,
                          style: TDLoadingStyle.horizontal);
                    },
                    child: const Text('图标+文字 横排')),
              ]),
              _dividerWidget("规格"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        TDLoading.show(
                          context: context,
                          duration: 2,
                          icon: TDLoadingIcon.circle,
                          size: TDLoadingSize.large,
                          text: "加载中...",
                        );
                      },
                      child: const Text('大')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        TDLoading.show(
                            context: context,
                            duration: 2,
                            icon: TDLoadingIcon.circle,
                            size: TDLoadingSize.medium,
                            text: "加载中...");
                      },
                      child: const Text('中')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        TDLoading.show(
                            context: context,
                            duration: 2,
                            icon: TDLoadingIcon.circle,
                            size: TDLoadingSize.small,
                            text: "加载中...");
                      },
                      child: const Text('小')),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _dividerWidget(String title) {
    return Row(
      children: [
        const Spacer(),
        const TDDivider(
          height: 1,
          width: 100,
        ),
        const SizedBox(
          width: 10,
        ),
        TDText(title),
        const SizedBox(
          width: 10,
        ),
        const TDDivider(
          height: 1,
          width: 100,
        ),
        const Spacer(),
      ],
    );
  }
}
