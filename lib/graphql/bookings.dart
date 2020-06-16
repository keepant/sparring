final String getAllBookings = """ 
    query GetAllBookings(\$status: String!){
      bookings (where: {booking_status: {_eq: \$status}} order_by: {created_at: desc}){
        id
        date
        time_start
        time_end
        booking_status
        payment_method
        payment_status
        total_price
        user {
          id
          name
          username
          email
          date_of_birth
          sex
          phone_number
        }
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
    query GetBooking(\$id: uuid!){
      bookings (where: {id: {_eq: \$id}}){
        id
        date
        time_start
        time_end
        booking_status
        payment_method
        payment_status
        total_price
        user {
          id
          name
          username
          email
          date_of_birth
          sex
          phone_number
        }
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