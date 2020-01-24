import 'package:flutter/material.dart';

enum ControlsMode { BLACK, WHITE, ALTERNATE, ERASE }

class ControlsWidget extends StatelessWidget {

  final ControlsMode mode;
  final Function(ControlsMode mode) modeChanged;

  const ControlsWidget({Key key, @required this.mode, this.modeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return        Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(icon: CircleAvatar(child: Text('A'),
            backgroundColor: mode == ControlsMode.ALTERNATE ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(ControlsMode.ALTERNATE),),
        IconButton(icon: CircleAvatar(child: Text('B'),
            backgroundColor: mode == ControlsMode.BLACK ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(ControlsMode.BLACK),),
        IconButton(icon: CircleAvatar(child: Text('W'),
            backgroundColor: mode == ControlsMode.WHITE ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(ControlsMode.WHITE),),
        IconButton(icon: CircleAvatar(child: Text('E'),
            backgroundColor: mode == ControlsMode.ERASE ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(ControlsMode.ERASE),),
      ],
    );
  }
}
