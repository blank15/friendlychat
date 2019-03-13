import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(new FriendlychatApp());

const String _name = "Yudistiro Septian";
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);


class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Friendly Chat",
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _message = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    void _handleSubmitted(String text) {
      _textController.clear();
      setState(() {
        _isComposing = false;
      });
      ChatMessage chatMessage = new ChatMessage(
        text: text,
        animationController: new AnimationController(
            duration: new Duration(milliseconds:
            400),
            vsync: this),
      );
      setState(() {
        _message.insert(0, chatMessage);
      });
      chatMessage.animationController
      .forward();
    }

    Widget _buildTextComposer() {
      return new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String text){
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Kirim pesan"),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS ?
                    new CupertinoButton(
                      child:new Text("Kirim"),
                      onPressed: _isComposing ? () =>
                        _handleSubmitted(_textController.text) : null
                      ,
                    ):
                    new IconButton(icon: new Icon(Icons.send),
                        onPressed: _isComposing ?
                        () => _handleSubmitted(_textController.text) : null)
              )
            ],
          ));
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text("Mantap"),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_,int index) => _message[index],
                  itemCount: _message.length,
            )
          ),
          new Divider(height: 1.0,),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
      for(ChatMessage message in _message){
        message.animationController.dispose();
      }
      super.dispose();
  }


}

class ChatMessage extends StatelessWidget{

  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {

    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name,style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
