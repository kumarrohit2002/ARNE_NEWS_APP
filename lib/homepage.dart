import 'dart:convert';

import 'package:arne_news/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  // const Home({super.key});
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List items = ["HELLO MAN" , "NAMAS STAY", "DIRTY FELLOW" ];
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList=<NewsQueryModel>[];
  List<String> navBarItem=["Top NEWS","India","World","Finacnce","Health"];
  bool isLoading=true;

  getNewsByQuery(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2023-12-11&sortBy=publishedAt&apiKey=81e6c35d67034da283417bc9302ca248";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

      });
    });

  }


  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("world");
    // getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ARNE NEWS"),
        centerTitle: true,
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Wala Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") ==
                          "") {
                        print("Blank search");
                      } else {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,  // key bord me search wala icon aa jayega
                      onSubmitted: (value){
                        print(value);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Health"),
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: 55,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: navBarItem.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      print(navBarItem[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(15)),
                      child:Center(child: Text(navBarItem[index]
                        ,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
                      )
                      ) ,
                    ),
                  );
                }
              ),
            ),

            CarouselSlider(
                options : CarouselOptions(
                    height : 220,
                    autoPlay : true,
                    enlargeCenterPage : true
                ),
                items : items.map((item) {
                  return Builder(
                      builder: (BuildContext context){
                        return Container(
                          // margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          // Image.asset("images/braking_news.jpeg",),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                Container(

                                  margin: EdgeInsets.symmetric(horizontal: 1),
                                  height: 220,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset("images/braking_news.jpeg",
                                        fit: BoxFit.cover, // Set this to cover the entire container
                                      )),
                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                        child: Text("Braking News",
                                          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                        )
                                    )
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }).toList(),
            ),

            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Latest news",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsModelList.length,
                      itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          // Image.asset("images/braking_news.jpeg",),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 1.0,
                          child: Stack(
                            children: [
                              Container(

                                width: 400,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, ),
                                    // Image.asset("images/braking_news.jpeg",
                                    //   fit: BoxFit.cover, // Set this to cover the entire container
                                    // )
                                ),
                              ),
                              Positioned(
                                left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(newsModelList[index].newsHead,
                                            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                          ),
                                          Text(newsModelList[index].newsDes.length>50? "${newsModelList[index].newsDes.substring(0,55)}":newsModelList[index].newsDes,
                                            style: TextStyle(color: Colors.white),)
                                        ],
                                      )
                                  )
                              )
                            ],
                          ),
                        ),
                      );
                  }),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()=>{}, child: Text("show more"))
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // final List items = ["HELLO MAN" , "NAMAS STAY", "DIRTY FELLOW" ];
  }
}
