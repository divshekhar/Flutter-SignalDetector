import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _signalStrength = 'Not Found';
  static const platform = const MethodChannel('signalStrength');

  Future<void> _getSignalStrength() async {
    String signal;
    try {
      final int result = await platform.invokeMethod('getSignalStrength');

      signal = result.toString();
    } on PlatformException catch (e) {
      signal = "'${e.message}'.";
    }

    setState(() {
      _signalStrength = signal + " dbm";
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future getPermission() async {
    var result =
        await SimplePermissions.requestPermission(Permission.ReadPhoneState);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signal Detector'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _getSignalStrength();
            },
            child: Text('Signal'),
          ),
          Text("Signal:"),
          Text(_signalStrength),
        ],
      ),
    );
  }
}
