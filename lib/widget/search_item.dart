import 'package:app_tracker_search/model/icon_model.dart';
import 'package:app_tracker_search/types/search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchItem extends StatelessWidget {
  final SearchListData data;
  const SearchItem(this.data, {Key? key}) : super(key: key);

  Widget _icon(BuildContext context) {
    return Consumer<IconModel>(builder: (context, model, child) {
      if (context
          .watch<IconModel>()
          .icons
          .where((element) => element.packageName == data.packageName)
          .isEmpty) {
        return const CircularProgressIndicator();
      } else {
        return Image.memory(
          context
              .watch<IconModel>()
              .icons
              .where((element) => element.packageName == data.packageName)
              .first
              .icon,
          width: 150,
          height: 150,
        );
      }
    });
  }

  void showIcon(BuildContext context) async {
    context.read<IconModel>().getIcon(data.packageName);
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(data.appName),
            content: _icon(context),
            actions: [
              TextButton(
                onPressed: () async {
                  // await saveIcon(
                  //     'https://bot.k2t3k.tk/api/appIcon?packageName=${data.packageName}');
                  const snackBar = SnackBar(
                    content: Text('保存成功'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // Navigator.of(context).pop();
                },
                child: const Text("保存到相册"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("关闭"),
              ),
            ],
          );
        });
  }

  Future<void> copyMore(BuildContext context) async {
    int? i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请选择'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('复制包名'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('复制启动项'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 3);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('复制 appfilter.xml'),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      switch (i) {
        case 1:
          Clipboard.setData(ClipboardData(text: data.packageName));
          const snackBar = SnackBar(
            content: Text('已复制包名'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case 2:
          Clipboard.setData(ClipboardData(text: data.activityName));
          const snackBar = SnackBar(
            content: Text('已复制启动项'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case 3:
          Clipboard.setData(ClipboardData(
              text:
                  '<item component="ComponentInfo{${data.packageName}/${data.activityName}}" drawable="${data.appName}"/>'));
          const snackBar = SnackBar(
            content: Text('复制 appfilter.xml'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: data.activityName));
        const snackBar = SnackBar(
          content: Text('已复制启动项'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onDoubleTap: () {
        showIcon(context);
      },
      onLongPress: () {
        copyMore(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('应用名：${data.appName}'),
            Text('包名：${data.packageName}'),
            Text('启动项：${data.activityName}'),
          ],
        ),
      ),
    );
  }
}
