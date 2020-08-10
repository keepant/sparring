import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sparring/pages/court/best_match.dart';
import 'package:sparring/pages/court/edit_search.dart';
import 'package:sparring/pages/court/higest_price.dart';
import 'package:sparring/pages/court/lowest_price.dart';
import 'package:sparring/pages/utils/utils.dart';

class SearchResult extends StatefulWidget {
  final String location;
  final String time;
  final String date;

  SearchResult({Key key, this.location, this.time, this.date})
      : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchControl = new TextEditingController();

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Best match"),
    new Tab(text: "Lowest price"),
    new Tab(text: "Highest price")
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          },
        ),
        title: InkWell(
          onTap: () {
            showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context, scrollController) => EditSearch(
                scrollController: scrollController,
                location: widget.location,
                date: widget.date,
                time: widget.time,
              ),
            );
          },
          child: Container(
            height: 45,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: TextField(
              controller: _searchControl
                ..text =
                    widget.location + "\n" + formatDate(widget.date) + " at " + widget.time,
              style: TextStyle(
                  height: 1, fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: null,
              decoration: InputDecoration(
                  enabled: false,
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
            ),
          ),
        ),
        bottom: TabBar(
          isScrollable: false,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorRadius: 5,
            indicatorHeight: 35.0,
            indicatorColor: Colors.white,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          BestMatch(
            location: widget.location,
            date: widget.date,
            time: widget.time,
          ),
          LowestPrice(
            location: widget.location,
            date: widget.date,
            time: widget.time,
          ),
          HighestPrice(
            location: widget.location,
            date: widget.date,
            time: widget.time,
          )
        ],
      ),
    );
  }
}
