import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({Key? key}) : super(key: key);

  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {

  showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Container(
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.exclamationCircle,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Sorry', style: GoogleFonts.lato(fontWeight: FontWeight.bold,),),
            ],
          ),
        ),
        content: Container(
          height: 50,
          child: Center(
            child: Text(
              'Please login or register to continue!!',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (_, bool innerBoxIsScrolled) {
          return [
            SliverPadding(
              padding: EdgeInsets.only(top: 24),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "User! ",
                                  style: GoogleFonts.openSans(
                                    fontSize: 17,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "😀",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => showLoginDialog(),
                        child: Icon(
                          Icons.logout,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(20, 25, 20, 30),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    focusColor: Colors.grey[300],
                    hoverColor: Colors.grey[300],
                    contentPadding: EdgeInsets.only(top: 3),
                    hintText: "Search for any movie",
                    prefixIcon: Icon(
                      FontAwesomeIcons.search,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'My Watchlist',
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => showLoginDialog(),
                      child: Icon(
                        FontAwesomeIcons.sort,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(
              "Use the Add Button below to add movies to your watchlist :)",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => showLoginDialog(),
            elevation: 10,
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.add,
              color: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
