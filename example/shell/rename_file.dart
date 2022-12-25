import 'dart:io';

void main(){
  var dirPath = '/Users/zflyluo/Downloads/icons/';
  var dir = Directory(dirPath);
  if(!dir.existsSync()){
    print('dir not exist， exit');
    return;
  }

  print('dir  exist');
  dir.listSync().forEach((element) {
    var fileName = element.path.replaceFirst(dirPath, '');
    if(fileName.contains('-')){
      print('fileName $fileName contains -,rename _');
      var newName = fileName.replaceAll('-', '_');
      var newPath = '$dirPath$newName';
      print('newPath: $newPath');
      element.renameSync(newPath);
    } else {
      print('fileName $fileName not contains -');
    }
  });
}