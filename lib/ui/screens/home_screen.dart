import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/constants.dart';
import '../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String movieName = "Star Wars";
  String posterUrl = "https://www.digitalartsonline.co.uk/cmsdata/slideshow/3662115/star-wars-last-jedi-poster.jpg";
  String directedBy = "NN Kumar";
  late DateTime createdOn = DateTime.now();
  late DateTime updatedOn = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(App.height(context));
    print(App.width(context));
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: NestedScrollView(
        headerSliverBuilder: (_, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 55, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'MY WATCHLIST',
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 6,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index) => Container(
            height: 270,
            margin: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            child: Stack(
              children: [
                Container(
                  width: App.width(context) / 2.3,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        posterUrl,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  left: App.width(context) / 2.7,
                  child: Container(
                    height: 220,
                    width: App.width(context) / 1.9,
                    margin: EdgeInsets.symmetric(vertical: 25),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 6,
                          offset: Offset(0, 0.76),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieName,
                          style: GoogleFonts.lato(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        movieDetails("Directed by:", directedBy),
                        movieDetails("Created on:", createdOn.toString()),
                        movieDetails("Last Updated on", updatedOn.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: (){},
            elevation: 10,
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Padding movieDetails(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          text: title + "  ",
          style: GoogleFonts.lato(
            fontSize: 14,
            color: kGreyColor,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: data,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
