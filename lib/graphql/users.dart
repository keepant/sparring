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
    }
  }
""";
