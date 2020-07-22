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