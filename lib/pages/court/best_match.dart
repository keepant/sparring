import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/court_card.dart';
import 'package:intl/intl.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/search_court.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/court/court_detail.dart';

class BestMatch extends StatelessWidget {
  final int id;
  final String location;
  final String date;
  final String time;

  BestMatch({
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
          documentNode: gql(getAllCourt),
          pollInterval: 10,
          variables: {
            'date': date,
            'time': timeParam,
            'name': '%' + location + '%'
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
          
          if (result.data['court'].length == 0) {
            return EmptyListWidget(
              title: I18n.of(context).noCourtText,
              subTitle: I18n.of(context).noCourtSearchText,
              image: null,
              packageImage: PackageImage.Image_4,
            );
          }

          return ListView.builder(
            itemCount: result.data['court'].length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var court = result.data['court'][index];
              var img = result.data['court'][index]['court_images'][0];

              return CourtCard(
                imgUrl: img['name'],
                title: court['name'],
                location: court['address'],
                price: court['price_per_hour'],
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: CourtDetail(
                      id: court['id'],
                      name: court['name'],
                      address: court['address'],
                      lat: court['latitude'],
                      long: court['longitude'],
                      date: date,
                      time: timeParam,
                      price: court['price_per_hour'],
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
