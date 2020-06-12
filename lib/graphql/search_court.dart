final String getAllCourt = """ 
    query GetAllCourt(\$date: date!, \$time: time!, \$name: String!){
      court (
        where: {
          _and: [
            {
              _or: [
                {name: {_ilike: \$name}}
                {address: {_ilike: \$name}}
              ]
            }
            {
              _not: {
                bookings: {
                  _and: [
                    {date: {_eq: \$date}}
                    {status: {_eq: "upcoming"}}
                    {time_start: {_eq: \$time}}
                  ]
                }
              }
            }
          ]
      }){
        id
        name
        address
        price_per_hour
        latitude
    		longitude
        court_images {
          id
          name
        }
      }
    }
  """;

final String getAllCourtByHigherPrice = """ 
    query GetAllCourtByHigherPrice(\$date: date!, \$time: time!, \$name: String!){
      court (
        where: {
          _and: [
            {
              _or: [
                {name: {_ilike: \$name}}
                {address: {_ilike: \$name}}
              ]
            }
            {
              _not: {
                bookings: {
                  _and: [
                    {date: {_eq: \$date}}
                    {status: {_eq: "upcoming"}}
                    {time_start: {_eq: \$time}}
                  ]
                }
              }
            }
          ]
      }  order_by: {price_per_hour: desc} ){
        id
        name
        address
        price_per_hour
        latitude
    		longitude
        court_images {
          id
          name
        }
      }
    }
  """;

final String getAllCourtByLowerPrice = """ 
    query GetAllCourtByLowerPrice(\$date: date!, \$time: time!, \$name: String!){
      court (
        where: {
          _and: [
            {
              _or: [
                {name: {_ilike: \$name}}
                {address: {_ilike: \$name}}
              ]
            }
            {
              _not: {
                bookings: {
                  _and: [
                    {date: {_eq: \$date}}
                    {status: {_eq: "upcoming"}}
                    {time_start: {_eq: \$time}}
                  ]
                }
              }
            }
          ]
      }  order_by: {price_per_hour: asc} ){
        id
        name
        address
        price_per_hour
        latitude
    		longitude
        court_images {
          id
          name
        }
      }
    }
  """;

final String getCourt = """ 
    query GetCourt(\$id: Int!){
      court(
        where: {
          id: {
            _eq: \$id
          }
        }
      ) {
        id
        name 
        address
        price_per_hour
        latitude
        longitude
        open_day
        closed_day
        open_hour
        closed_hour
        court_images {
          id
          name
        }
        court_facilities {
          id
          name
        }
      }
    }
  """;
