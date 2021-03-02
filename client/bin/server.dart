import 'package:get_server/get_server.dart';

void main() {
  runApp(
    GetServer(
      home: FolderWidget('app/web'),
      getPages: [
        GetPage(name: '/welcome', page: () => Welcome()),
      ],
    ),
  );
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Welcome to NJCK!');
  }
}
