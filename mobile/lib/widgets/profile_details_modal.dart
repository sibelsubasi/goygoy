import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/custom_routes/modal_from_top_route.dart';
import 'package:mobile/entities/login.dart';
import 'package:mobile/services/authentication.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/widgets/impl/decorated_user_image.dart';
import 'package:mobile/pages/login/logout.dart';

Future<void> showProfileDetailsModal({BuildContext context}) async {
  UserDetail _user = AuthenticationService.currentUser.userDetail;

  double popupHeight = 400;

  return await showModalTopRoute<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: popupHeight,
        padding: const EdgeInsets.only(bottom: 7.0),
        decoration: BoxDecoration(
          color: Config.COLOR_WHITE_GRAY,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(25, 25),
            bottomLeft: Radius.elliptical(25, 25),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 22.0,
          ),
          child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
              top: false,
              child: Card(
                color: Config.COLOR_WHITE_GRAY,
                elevation: 0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          SizedBox(height: 22),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 22),
                              DecoratedUserImage(
                                width: 40,
                                height: 40,
                                personId: _user.personId,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${_user.firstName} ${_user.lastName}", style: AppTheme.textMutedGray()),
                                    Text("${_user.bussinessCategory}", style: AppTheme.textHint()),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Config.COLOR_LIGHT_GRAY),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            onTap: () => Navigator.of(context).popAndPushNamed("/whois/detail", arguments: _user.personId),
                            leading: Image.asset("assets/img/profileIcon.png"),
                            title: Text("Profilim"),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () => Navigator.of(context).popAndPushNamed("/login/photo", arguments: _user.personId),
                            leading: Image.asset("assets/img/photoUploadIcon.png"),
                            title: Text("Fotoğraf Yükle"),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () => Navigator.of(context).popAndPushNamed("/login/password-change"),
                            leading: Image.asset("assets/img/passwordIcon.png"),
                            title: Text("Şifre Değiştir"),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () => doLogout(context),
                            leading: Image.asset("assets/img/logoutIcon.png"),
                            title: Text("Çıkış Yap"),
                            trailing: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
