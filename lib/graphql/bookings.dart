final String getAllBookings = """ 
    query GetAllBookings(\$status: String!){
      bookings (where: {status: {_eq: \$status}} order_by: {created_at: desc}){
        id
        date
        time_start
        time_end
        status
        payment_info
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
    query GetBooking(\$id: Int!){
      bookings (where: {id: {_eq: \$id}}){
        id
        date
        time_start
        time_end
        status
        payment_info
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