final String getTeam = """
  query getTeam(\$id: String!){
    team(where: {user_id: {_eq: \$id}}) {
      id
      name
      address
      logo
      user_id
      created_at
    }
  }
""";

final String addTeam = """ 
  mutation addTeam(\$name: String!, \$address: String!, \$id: String!, \$logo: String!){
    insert_team(objects: {
      name: \$name
      address: \$address
      user_id: \$id
      logo: \$logo
    }) {
      affected_rows
    }
  }
""";

final String updateTeam = """
  mutation updateTeam(\$id: Int!, \$name: String!, \$address: String!){
    update_team(where: {id: {_eq: \$id}} _set: {
      name: \$name
      address: \$address
    }) {
      affected_rows
    }
  }
""";

final String updateLogo = """
  mutation updateLogo(\$id: Int!, \$logo: String!){
    update_team(where: {id: {_eq: \$id}} _set: {
      logo: \$logo
    }) {
      affected_rows
    }
  }
""";