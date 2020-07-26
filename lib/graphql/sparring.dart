final getAllSparring = """
  query getAllSparring(\$team: uuid!, \$status: String!){
    sparring(where: {
      _and: [
        {
          _or: [
            {team_1_id :{_eq: \$team}}
            {team_2_id : {_eq: \$team}}
          ]
        }
        {
          status: {_eq: \$status}
        }
      ]
    }) {
      id
      date
      time_start
      time_end
      location
      status
      created_at
      team1 {
        id
        name
        address
        logo
      }
      team2 {
        id
        name
        address
        logo
      }
    }
  }
""";

final String getSparringDetail = """ 
  query getSparringDetail(\$id: Int!){
    sparring(where: {id: {_eq: \$id}}) {
      id
      date
      time_start
      time_end
      status
      location
        team1 {
          id
          name
          logo
          address
          users{
            id
            name
            address
            profile_picture
            phone_number
          }
        }
      team2 {
        id
        name
        logo
        address
        users{
          id
          name
          address
          profile_picture
          phone_number
        }
      }
    }
  }
""";

final String insertSparring = """
  mutation insertSparring(\$date: String!, \$time_start: String!, \$time_end: String!, \$team_id: uuid!, \$court_id: Int!){
    insert_sparring(
      objects: {
        date: \$date
        time_start: \$time_start
        time_end: \$time_end
        team_1_id: \$team_id
        court_id: \$court_id
      }
    ) {
      affected_rows
    }
  }
""";

final String getSearchSparring = """
  query getSearchSparring(\$team_id: uuid!){
    sparring(where: {
      _and: [
        {
          team_1_id: {_eq: \$team_id}
          
        }
        {
          status: {_eq: "searching"}
        }
      ]
    }) {
      id
      date
      time_start
      time_end
      court{
        id
        name
        address
        latitude
        longitude
      }
      team1 {
        id
        name
        logo
        address
      }
    }
  }
""";