import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/court_card.dart';
import 'package:intl/intl.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/search_court.dart';
import 'package:sparring/pages/court/court_detail.dart';

class LowestPrice extends StatelessWidget {
  final int id;
  final String location;
  final String date;
  final String time;

  LowestPrice({
    Key key,
    this.id,
    this.location,
    this.date,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getTime =
        DateFormat.H().format(DateTime.parse("2020-01-01 " + time)).toString();
    String timeParam = getTime + ":00";

    DateTime tgl = DateTime.parse(date);

    print("date: " + tgl.toString() + " time: " + timeParam);

    return GraphQLProvider(
      client: API.guestClient,
      child: Query(
        options: QueryOptions(
          documentNode: gql(getAllCourtByLowerPrice),
          pollInterval: 1,
          variables: {
            'date': date,
            'time': timeParam,
            'name': '%' + location + '%'
          },
        ),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          return result.loading
              ? Loading()
              : result.hasException
                  ? Center(child: Text(result.exception.toString()))
                  : ListView.builder(
                      itemCount: result.data['court'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var court = result.data['court'][index];
                        var img =
                            result.data['court'][index]['court_images'][0];

                        return CourtCard(
                          imgUrl: img['name'],
                          title: court['name'],
                          location: court['address'],
                          price: court['price_per_hour'].toString(),
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: CourtDetail(
                                id: court['id'],
                                name: court['name'],
                                address: court['address'],
                                lat: court['latitude'],
                                long: court['longitude'],
                              ),
                              platformSpecific: false,
                              withNavBar: false,
                            );
                          },
                        );
                      },
                    );
        },
      ),
    );
  }
}
