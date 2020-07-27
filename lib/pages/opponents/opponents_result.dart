import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/components/opponent_card.dart';
import 'package:sparring/graphql/sparring.dart';
import 'package:sparring/pages/opponents/edit_search.dart';
import 'package:sparring/pages/opponents/opponent_detail.dart';
import 'package:sparring/pages/utils/utils.dart';
import 'package:intl/intl.dart';

class OpponentsResult extends StatefulWidget {
  final String location;
  final String date;
  final String time;

  OpponentsResult({
    Key key,
    this.location,
    this.date,
    this.time,
  }) : super(key: key);

  @override
  _OpponentsResultState createState() => _OpponentsResultState();
}

class _OpponentsResultState extends State<OpponentsResult>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String getTime = DateFormat.H()
        .format(DateTime.parse("2020-01-01 " + widget.time))
        .toString();
    String timeParam = getTime + ":00";

    return Scaffold(
      backgroundColor: Color(0xffdee4eb),
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
                ..text = widget.location +
                    "\n" +
                    formatDate(widget.date) +
                    " at " +
                    widget.time,
              style: TextStyle(
                height: 1,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: null,
              decoration: InputDecoration(
                enabled: false,
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              ),
            ),
          ),
        ),
      ),
      body: GraphQLProvider(
        client: API.guestClient,
        child: Query(
          options: QueryOptions(
            documentNode: gql(getAvailableSparring),
            pollInterval: 1,
            variables: {
              'name': '%${widget.location}%',
              'date': widget.date,
              'time': timeParam,
            },
          ),
          builder: (QueryResult result,
              {FetchMore fetchMore, VoidCallback refetch}) {
            if (result.loading) {
              return Loading();
            }

            if (result.hasException) {
              return Center(
                child: Text(result.exception.toString()),
              );
            }

            if (result.data['sparring'].length == 0) {
              return Center(
                child: EmptyListWidget(
                  title: 'No opponents',
                  subTitle: 'No opponent match with the search',
                  image: null,
                  packageImage: PackageImage.Image_4,
                ),
              );
            }

            return ListView.builder(
              itemCount: result.data['sparring'].length,
              itemBuilder: (context, index) {
                var sparring = result.data['sparring'][index];
                var court = sparring['court'];
                var team = sparring['team1'];

                return OpponentCard(
                  teamName: team['name'],
                  teamLogo: team['logo'],
                  court: court['name'],
                  date: sparring['date'],
                  timeStart: sparring['time_start'],
                  timeEnd: sparring['time_end'],
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: OpponentDetail(
                        id: sparring['id'],
                      ),
                      withNavBar: false,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
