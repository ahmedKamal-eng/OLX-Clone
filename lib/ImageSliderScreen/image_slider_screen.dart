import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:olx_app/utils/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSliderScreen extends StatefulWidget {
  final String title, urlImage1, urlImage2, urlImage3, urlImage4, urlImage5;
  final String itemColor, userNumber, description, address, itemPrice;
  final double lat, lng;

  ImageSliderScreen(
      {required this.title,
      required this.urlImage1,
      required this.urlImage2,
      required this.urlImage3,
      required this.urlImage4,
      required this.urlImage5,
      required this.itemColor,
      required this.userNumber,
      required this.description,
      required this.address,
      required this.itemPrice,
      required this.lat,
      required this.lng});

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen>
    with SingleTickerProviderStateMixin {
  static List<String> links = [];
  TabController? tabController;

  getLinks() {
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
    links.add(widget.urlImage3);
    links.add(widget.urlImage4);
    links.add(widget.urlImage5);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinks();
    tabController = TabController(length: 5, vsync: this);
  }

  String? url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Varela',
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 6, right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: MyColors.luckyPoint,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      widget.address,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontFamily: 'Varela', letterSpacing: 2),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * .5,
              width: size.width,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Carousel(
                  indicatorBarColor: MyColors.luckyPoint,
                  autoScrollDuration: Duration(milliseconds: 800),
                  animationPageDuration: Duration(milliseconds: 800),
                  activateIndicatorColor: Colors.black,
                  animationPageCurve: Curves.easeIn,
                  indicatorBarHeight: 30,
                  indicatorHeight: 10,
                  indicatorWidth: 10,
                  unActivatedIndicatorColor: Colors.grey,
                  stopAtEnd: false,
                  autoScroll: true,
                  items: [
                    Image.network(widget.urlImage1),
                    Image.network(widget.urlImage2),
                    Image.network(widget.urlImage3),
                    Image.network(widget.urlImage4),
                    Image.network(widget.urlImage5),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: Center(
                child: Text(
                  '\$ ${widget.itemPrice}',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 2,
                    fontFamily: 'Bebas',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brush_outlined),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.itemColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone_android),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(widget.userNumber),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                widget.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black.withOpacity(.8),
                  fontSize: 18
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 368),
                child: ElevatedButton(
                  onPressed: () async {


                    url ='https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}';

                    try
                      {
                        await launchUrl(Uri.parse(url!));
                      }
                    catch(e){
                      print(e.toString());
                      throw "Can not open the map";
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54),
                  ),
                  child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.location_pin,color: Colors.white,),
                      Text('Check Seller Location',style: TextStyle(color: Colors.white,fontSize: 20),),

                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),


          ],
        ),
      ),
    );
  }
}
