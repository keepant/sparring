final String getBookings = """ 
    query {
      bookings {
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
          address
 					phone_number
          latitude
          longitude
          price_per_hour
        }
      }
    }
  """;