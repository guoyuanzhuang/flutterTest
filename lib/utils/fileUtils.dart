import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

var httpClient = new HttpClient();

void main() {
  getAppPath();
}

getAppPath() async {
  try {
    print('临时目录: ' + (await getTemporaryDirectory()).path);
    //----/data/user/0/com.toly1994.toly/cache
    print('文档目录: ' + (await getApplicationDocumentsDirectory()).path);
    //----/data/user/0/com.toly1994.toly/file
    print('sd卡目录: ' + (await getExternalStorageDirectory()).path);
    //----/storage/emulated/0
  } catch (err) {
    print(err);
  }
}
