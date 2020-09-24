import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionEnvio.dart';

class MenuDrawerPage extends StatefulWidget {
  @override
  _MenuDrawerPageState createState() => _MenuDrawerPageState();
}

class _MenuDrawerPageState extends State<MenuDrawerPage> {
  int currentIndex = 0;
  int _selectDrawerItem = 0;
  PageController pageController = PageController();
  final List<Widget> _childrenPages = [
    HomePage(),
    HomePage(),
    HomePage(),
  ];

  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePage();
      case 1:
        return RecepcionEnvioPage();
        break;
      default:
    }
  }

  _onselectItem(int pos) {
    setState(() {
      _selectDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(text: titulosPage(_selectDrawerItem)),
      body: _getDrawerItemWidget(_selectDrawerItem),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Rolando Garcia"),
              accountEmail: Text("rgarcia@exact.com.pe"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  "R",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.check),
              onTap: () {
                _onselectItem(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Confirmar'),
              leading: Icon(Icons.check_box_outline_blank),
              onTap: () {
                _onselectItem(1);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
