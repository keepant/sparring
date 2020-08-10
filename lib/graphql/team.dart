final String getTeam = """
  query getTeam(\$id: String!){
    users(where: {id: {_eq: \$id}}) {
      team {
        id
        name
        address
        logo
        created_at
      }
    }
  }
""";

final String addTeam = """ 
  mutation addTeam(\$id: String!, \$team_id: uuid!, \$name: String!, \$address: String!, \$logo: String!){
    insert_team(objects: {
      id: \$team_id,
      name: \$name,   
      address: \$address,
      logo: \$logo
    }) {
      affected_rows
    }
    update_users(where: {id: {_eq: \$id}} _set: {
      team_id: \$team_id
    }) {
      affected_rows	
    }
  }
""";

final String updateTeam = """
  mutation updateTeam(\$id: uuid!, \$name: String!, \$address: String!){
    update_team(where: {id: {_eq: \$id}} _set: {
      name: \$name
      address: \$address
    }) {
      affected_rows
    }
  }
""";

final String updateLogo = """
  mutation updateLogo(\$id: uuid!, \$logo: String!){
    update_team(where: {id: {_eq: \$id}} _set: {
      logo: \$logo
    }) {
      affected_rows
    }
  }
""";