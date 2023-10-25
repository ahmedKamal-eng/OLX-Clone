import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../HomeScreen/home_screen.dart';
import '../widgets/listview_wedget.dart';

class SearchProduct extends StatefulWidget {
  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _searchQueryController = TextEditingController();

  String searchQuery = '';
  bool _isSearching = false;

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search Here...',
        border: InputBorder.none,
        helperStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
            onPressed: () {
              if (_searchQueryController == null ||
                  _searchQueryController.text.isEmpty) {
                Navigator.pop(context);
                return;
              }
              _clearSearchQuery();
            },
            icon: Icon(Icons.clear)),
      ];
    }

    return <Widget>[
      IconButton(
        onPressed: _startSearch,
        icon: Icon(Icons.search),
      ),
    ];
  }

  _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
          _stopSearch();
    }));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearch() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _buildTitle(BuildContext context) {
    return const Text('Search Product ..');
  }

  _buildBackButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: _isSearching ? BackButton() : _buildBackButton(),
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("items")
            .where('itemModel',
                isGreaterThanOrEqualTo: _searchQueryController.text.trim())
            .where("status", isEqualTo: 'approved').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
                shrinkWrap: true,

                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ListViewWidget(
                    docId: snapshot.data.docs[index].id,
                    itemColor: snapshot.data.docs[index]['itemColor'],
                    img1: snapshot.data.docs[index]['userImage1'],
                    img2: snapshot.data.docs[index]['userImage2'],
                    img3: snapshot.data.docs[index]['userImage3'],
                    img4: snapshot.data.docs[index]['userImage4'],
                    img5: snapshot.data.docs[index]['userImage5'],
                    userImg: snapshot.data.docs[index]['imgPro'],
                    name: snapshot.data.docs[index]['userName'],
                    date: snapshot.data.docs[index]['time'].toDate(),
                    userId: snapshot.data.docs[index]['id'],
                    itemModel: snapshot.data.docs[index]['itemModel'],
                    postId: snapshot.data.docs[index]['postId'],
                    itemPrice: snapshot.data.docs[index]['itemPrice'],
                    description: snapshot.data.docs[index]['description'],
                    lat: snapshot.data.docs[index]['lat'],
                    lng: snapshot.data.docs[index]['lng'],
                    address: snapshot.data.docs[index]['address'],
                    userNumber: snapshot.data.docs[index]['userNumber'],
                  );
                }

              // return ListViewWidget(
              //   docId: cubit.items[index].id,
              //   itemColor: cubit.items[index].itemColor,
              //   img1: cubit.items[index].userImages[0],
              //   img2: cubit.items[index].userImages[1],
              //   img3: cubit.items[index].userImages[2],
              //   img4: cubit.items[index].userImages[3],
              //   img5: cubit.items[index].userImages[4],
              //   userImg: cubit.items[index].imgPro,
              //   name: cubit.items[index].userName,
              //   date: cubit.items[index].time,
              //   userId: cubit.items[index].id,
              //   itemModel: cubit.items[index].itemModel,
              //   postId: cubit.items[index].postId,
              //   itemPrice: cubit.items[index].itemPrice,
              //   description: cubit.items[index].description,
              //   lat: cubit.items[index].lat,
              //   lng: cubit.items[index].lng,
              //   address: cubit.items[index].address,
              //   userNumber: cubit.items[index].userNumber,
              // );

            );
          } else {
            return Text("there is no data");
          }
        },

      ),
    );
  }
}
