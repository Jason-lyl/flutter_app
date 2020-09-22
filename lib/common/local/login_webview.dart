import 'package:flutter/material.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

class LoginWebView extends StatefulWidget {
  final String url;
  final String title;

  LoginWebView(this.url, this.title);

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  _renderTitle() {
    if (widget.url == null || widget.url.length == 0) {
      return new Text(widget.title);
    }
    return new Row(children: [
      new Expanded(
          child: new Container(
        child: new Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ))
    ]);
  }

  renderLoading() {
    return new Center(
      child: new Container(
        width: 200.0,
        height: 200.0,
        padding: new EdgeInsets.all(4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
            new Container(width: 10.0),
            new Container(
              child: new Text(GSYLocalizations.i18n(context).load_more_text,
                  style: GSYConstant.middleText),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebViewPlugin.onStateChanged
        .listen((WebViewStateChanged stateChanged) {
      if (mounted) {
        if (stateChanged.type == WebViewState.shouldStart) {
          print("shouldStart ${stateChanged.url}");
        }
        if (stateChanged.url != null &&
            stateChanged.url.startsWith("gsygithubapp://authed")) {
          var code = Uri.parse(stateChanged.url).queryParameters["code"];
          print("code ${code}");
          flutterWebViewPlugin.reloadUrl("about:blank");
          Navigator.of(context).pop(code);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          WebviewScaffold(
            appBar: new AppBar(
              title: _renderTitle(),
            ),
            initialChild: renderLoading(),
            url: widget.url,
          )
        ],
      ),
    );
  }
}
