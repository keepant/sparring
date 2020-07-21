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