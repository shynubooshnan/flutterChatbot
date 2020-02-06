
import 'ChatAssistHomePage.dart';
import 'package:flutter/material.dart';
import 'ChatMessage.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatAssistStateFulHomePage extends State<ChatAssistHomePage> {

  //private methods
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  Icon _chatIcon = new Icon(Icons.send);
  bool _isLoading = false;

  Widget buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Ask your queries.."),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: _chatIcon,
                  onPressed: () => handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  ///Message submit handling function
  void handleSubmitted(String text) {
    if(text.isEmpty ||
        _isLoading)
      return;
    _isLoading = true;
    _textController.clear();
    //change chat icon
    _chatIcon = new Icon(Icons.message);
    //show loading
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return Center(child: CircularProgressIndicator(),);
//        });
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Shynu",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  ///response handling
  void response(query) async {
    _textController.clear();
    try{
      AuthGoogle authGoogle =
      await AuthGoogle(fileJson: "assets/credentials.json")
          .build();
      Dialogflow digFlow = Dialogflow(authGoogle: authGoogle, language: Language.english);
      AIResponse response = await digFlow.detectIntent(query);
      ChatMessage message = new ChatMessage(
        text: response.getMessage() ??
            new CardDialogflow(response.getListMessage()[0]).title,
        name: "Bot",
        type: false,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
    catch (e) {
      print("Error: $e");
    }

    //reset loading flag
    _isLoading = false;
    //change chat icon
    _chatIcon = new Icon(Icons.send);

    //hide loading
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Chat Assistant"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: buildTextComposer(),
        )
      ]),
    );
  }
}
