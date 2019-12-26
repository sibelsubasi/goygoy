// (C) 2019 All rights reserved.
// Proprietary License.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/pages/home/edit.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/validator.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';


class BubbleTab extends StatefulWidget {
  final String screenName = "/home/tabs/bubble";

  final File loadedImageFile;
  final List<Map> preparedBubble;
  const BubbleTab({Key key, this.loadedImageFile, this.preparedBubble,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BubbleTabState();
}

class BubbleTabState extends State<BubbleTab> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  File _loadedImage;

  String _description = "";
  bool _selectedBubble; //means right blue bubble
  List<Map> _bubbleList = [];

  double countOffset = 50.0;

  //*** TODO: SAĞ BALONCUK =  BEYAZ, SOL BALONCUK = MAVİ ***/



  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);

    if (mounted) {
      print("******* Welcome to Bubble Page ********");
      _loadedImage = widget.loadedImageFile;
      if (widget.preparedBubble != null) _bubbleList = widget.preparedBubble;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit(){
    _formKey.currentState.save();

    if (_formKey.currentState.validate() && _selectedBubble != null) {
      print("decription: $_description \nbubble: $_selectedBubble");

      List<Map> _wgPreparedBubble = _prepareBubble();

      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => EditPage(
                loadedImageFile: _loadedImage,
                preparedBubble: _wgPreparedBubble,
              )));

    }else{
      showErrorSheet(context: context, error: "Do not leave fields blank.");
    }
  }


  List<Map> _prepareBubble(){
    List<Map> _wg =  [];

    countOffset = countOffset + (_bubbleList.length * 50);

    _bubbleList.add(
        {
          "message": _description,
          "isRightBubble" : _selectedBubble,
          "position" : Offset(50, countOffset)
        },
    );

    _wg = _bubbleList;
    return _wg;
  }


  void _handleSelectedBubble(bool value) {
    setState(() {
      _selectedBubble = value;
    });
  }


  Widget _editBubble(){

    Widget _wg;

    _wg = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0,0,0,0),
          child: Column(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.create, size: 24, color: Config.COLOR_ORANGE_DARK,),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        RoundedTextField(
                          labelText: "Speech Field",
                          initialValue: null,
                          validator: (e) => Validator().required().validate(e),
                          onSaved: (e) => setState(() => _description = e),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.textsms, size: 24, color: Config.COLOR_ORANGE_DARK,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          activeColor: Config.COLOR_MEDIUM_GREEN,
                          value: false,
                          groupValue: _selectedBubble,
                          onChanged: _handleSelectedBubble,
                        ),
                        _selectedBubble == false
                            ? Text("Left Bubble", style: AppTheme.textListDefaultBody(),)
                            : Text("Left Bubble", style: AppTheme.textListDefaultSubBody(),),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          activeColor: Config.COLOR_MEDIUM_GREEN,
                          value: true,
                          groupValue: _selectedBubble,
                          onChanged: _handleSelectedBubble,
                        ),
                        _selectedBubble == true
                            ? Text("Right Bubble", style: AppTheme.textListDefaultBody(),)
                            : Text("Right Bubble", style: AppTheme.textListDefaultSubBody(),),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 1, child: Container(),),
                  Expanded(
                    flex: 2,
                    child: ActionButtonSmall(
                      buttonColor: Config.COLOR_ORANGE_DARK,
                      child: Text("Create", style: AppTheme.textButtonPositive()),
                      onPressed: () => _submit(),
                    ),
                  ),
                  Expanded(flex: 1, child: Container(),),
                ],
              ),

             ],
          ),
        ),
        ),

      ],
    );


    return _wg;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
        children: <Widget>[
          GradientPageHeader(
            title: "Create Bubble",
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 75),
            child: ListView(
              padding: EdgeInsets.all(24.0),
              children: <Widget>[
                _editBubble(),
              ],
            ),
          ),
          _isLoading ? Dialogs.aotIndicator(context) : Container(),
        ],
      ),
      ),
    ),
    );
  }
}
