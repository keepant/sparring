import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:intl/intl.dart';
import 'package:sparring/api/api.dart';
import 'package:sparring/components/loading.dart';
import 'package:sparring/graphql/search_court.dart';
import 'package:uuid/uuid.dart';

const CHANNEL = "com.keepant.sparring";
const KEY_NATIVE = "showPaymentGateway";

class Payment extends StatefulWidget {
  final int courtId;
  final String date;
  final String time;
  final int qty;
  final String name;
  final int price;

  Payment({
    Key key,
    this.courtId,
    this.date,
    this.time,
    this.name,
    this.qty,
    this.price,
  }) : super(key: key);

  static const platform = const MethodChannel(CHANNEL);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String uuid = Uuid().v4();

  Future<Null> _showNativeView() async {
    await Payment.platform.invokeMethod(KEY_NATIVE, {
      "courtId": widget.courtId,
      "orderId": uuid,
      "name": widget.name,
      "price": widget.price.toString(),
      "qty": widget.qty.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.guestClient,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getCourt),
            pollInterval: 10,
            variables: {
              "id": widget.courtId,
            }),
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

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text("Payment details"),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: result.data['court'].length,
              itemBuilder: (context, index) {
                int qty = 2;
                var court = result.data['court'][index];
                var img = result.data['court'][index]['court_images'][0];
                var totalPrice = qty * court['price_per_hour'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(img['name']),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                      child: Text(
                        court['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(court['address']),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: InkWell(
                        child: Text(
                          "See court details",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13.0,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  size: 14.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(new DateFormat.yMMMMd('en_US')
                                    .format(DateTime.parse(widget.date))
                                    .toString()),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 14.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(new DateFormat.Hm()
                                        .format(DateTime.parse(
                                            '2020-06-01' + ' ' + widget.time))
                                        .toString() +
                                    " - " +
                                    new DateFormat.Hm()
                                        .format(DateTime.parse(
                                            '2020-06-01' + ' ' + widget.time))
                                        .toString()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(height: 10.0, color: Colors.black12),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                      child: Text(
                        'Invoice',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Price",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  qty.toString() + " hour" + " x ",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Rp " + court['price_per_hour'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Total price",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Rp " + totalPrice.toString(),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: RaisedButton(
              onPressed: () {
                _showNativeView();
              },
              padding: EdgeInsets.symmetric(vertical: 15.0),
              color: Theme.of(context).primaryColor,
              child: Text(
                "Checkout",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
