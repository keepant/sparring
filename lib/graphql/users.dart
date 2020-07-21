final String getUserData = """
  query getUserData(\$id: String!){
    users(where: {id: {_eq: \$id}} ){
      id
      name
      username
      email
      date_of_birth
      sex
      address
      phone_number
      profile_picture
      created_at
      team{
        id
      }
    }
  }
""";

final String updateUser = """
  mutation updateUser(\$id: String!, \$name: String!, \$sex: String!, \$address: String!, \$phone: String!){
    update_users(where: {id: {_eq: \$id}} _set: {
      name: \$name
      sex: \$sex
      address: \$address
      phone_number: \$phone
    }) {	
      affected_rows
    }
  }
""";

final String updateProfilePicture = """
  mutation updateProfilePicture(\$id: String!, \$profile_picture: String!){
    update_users(where: {id: {_eq: \$id}} _set: {
      profile_picture: \$profile_picture
    }) {
      affected_rows
    }
  }
""";
