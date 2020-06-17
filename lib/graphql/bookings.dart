final String getAllBookings = """ 
    query GetAllBookings(\$status: String!){
      bookings (where: {booking_status: {_eq: \$status}} order_by: {created_at: asc}){
        id
        date
        time_start
        time_end
        booking_status
        total_price
    		court{
          id
          name
          address
 					phone_number
          latitude
          longitude
          price_per_hour
          court_images {
            id
            name
          }
        }
      }
    }
  """;

final String getBooking = """ 
    query GetBooking(\$id: Int!){
      bookings (where: {id: {_eq: \$id}}){
        id
        date
        time_start
        time_end
        booking_status
        total_price
        order_id
        qty
    		court{
          id
          name
          address
 					phone_number
          latitude
          longitude
          price_per_hour
          court_images {
            id
            name
          }
        }
      }
    }
  """;

final String addBooking = """
  mutation addBooking(
    \$date: String!,
    \$time_start: String!,
    \$time_end: String!,
    \$booking_status: String!,
    \$total_price: Int!,
    \$user_id: String!,
    \$court_id: Int!,
    \$qty: Int!,
    \$order_id: String!,
  ){
    action: insert_bookings(
      objects: {
        date: \$date,
        time_start: \$time_start,
        time_end: \$time_end,
        booking_status: \$booking_status,
        total_price: \$total_price,
        user_id: \$user_id,
        court_id: \$court_id,
        qty: \$qty,
        order_id: \$order_id
      }
    ){
      affected_rows
    }  
  }
""";
