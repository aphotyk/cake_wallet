import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/subaddress_list/subaddress_list_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/receive/qr_image.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/widgets/nav_bar.dart';

class ReceivePage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Receive';

  final _shareButtonImage = Image.asset('assets/images/share_button.png');

  @override
  Widget trailing(BuildContext context) => ButtonTheme(
        minWidth: double.minPositive,
        child: FlatButton(onPressed: () {}, child: _shareButtonImage),
      );

  @override
  Widget body(BuildContext context) =>
      SingleChildScrollView(child: ReceiveBody());

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Scaffold(
        backgroundColor: _isDarkTheme ? PaletteDark.darkThemeBlack
            : Palette.lightGrey2,
        resizeToAvoidBottomPadding: false,
        appBar: NavBar(
            leading: leading(context),
            middle: middle(context),
            trailing: trailing(context),
            backgroundColor: _isDarkTheme ? Theme.of(context).backgroundColor
                : Colors.white),
        body: SafeArea(child: body(context)));
  }
}

class ReceiveBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);
    final subaddressListStore = Provider.of<SubaddressListStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    Color _currentColor, _notCurrentColor;
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) {
      _currentColor = PaletteDark.darkThemeViolet;
      _notCurrentColor = PaletteDark.darkThemeBlack;
      _isDarkTheme = true;
    }
    else {
      _currentColor = Palette.purple;
      _notCurrentColor = Colors.white;
      _isDarkTheme = false;
    }

    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(35.0),
          color: _isDarkTheme ? Theme.of(context).backgroundColor
              : Colors.white,
          child: Column(
            children: <Widget>[
              Observer(builder: (_) {
                return Row(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                        flex: 2,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: QrImage(
                            data: walletStore.subaddress.address,
                            backgroundColor: Colors.white,
                          ),
                        )),
                    Spacer(
                      flex: 1,
                    )
                  ],
                );
              }),
              Observer(builder: (_) {
                return Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: walletStore.subaddress.address));
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Copied to Clipboard',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ));
                          },
                          child: Text(
                            walletStore.subaddress.address,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: _isDarkTheme ? PaletteDark.darkThemeTitle
                                    : Colors.black
                            ),
                          ),
                        ),
                      ),
                    ))
                  ],
                );
              }),
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: _isDarkTheme ? PaletteDark.darkThemeGrey
                                : Palette.lightBlue
                        ),
                        hintText: 'Amount',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                    : Palette.lightGrey,
                                width: 1.0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                    : Palette.lightGrey,
                                width: 1.0))),
                    onSubmitted: (value) {
                      // _validateAmount(value);
                    },
                  ))
                ],
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
              color: _isDarkTheme ? PaletteDark.darkThemeBlack : Palette.lightGrey2,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Subaddresses',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: _isDarkTheme ? PaletteDark.darkThemeGrey
                              : Colors.black
                      ),
                    ),
                    trailing: Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                          color: _isDarkTheme ? PaletteDark.darkThemeViolet : Palette.purple,
                          shape: BoxShape.circle
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(Routes.newSubaddress),
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        child: Icon(
                          Icons.add,
                          color: Palette.violet,
                          size: 22.0,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                        : Palette.lightGrey,
                    height: 1.0,
                  )
                ],
              ),
            ))
          ],
        ),
        Observer(builder: (_) {
          return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subaddressListStore.subaddresses.length,
              separatorBuilder: (context, i) {
                return Divider(
                  color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                      : Palette.lightGrey,
                  height: 1.0,
                );
              },
              itemBuilder: (context, i) {
                final subaddress = subaddressListStore.subaddresses[i];
                final isCurrent =
                    walletStore.subaddress.address == subaddress.address;
                final label = subaddress.label.isNotEmpty
                    ? subaddress.label
                    : subaddress.address;

                return Container(
                  color: isCurrent ? _currentColor : _notCurrentColor,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          label,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: _isDarkTheme ? PaletteDark.darkThemeGrey
                                  : Colors.black
                          ),
                        ),
                        onTap: () => walletStore.subaddress = subaddress,
                      ),
                    ],
                  ),
                );
              });
        })
      ],
    )));
  }
}
