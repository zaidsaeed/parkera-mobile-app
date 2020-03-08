class SignUpMutQueries {
  // String addUser(String firstname, String lastname, String email, String phone,
  //     String userRole) {
  //   return """
  //     mutation{
  //         addUser(firstname: "$firstname", lastname: "$lastname", email: "$email", phone: "$phone", user_role: "$userRole", password: "$password"){
  //           name
  //           lastName
  //         }
  //     }
  //    """;
  // }

  String addUser = """
  mutation AddUser(\$firstname: String!, \$lastname: String!, \$email: String!, \$phone: String!, \$user_role: String!, \$password: String!) {
    addUser(firstname: \$firstname, lastname: \$lastname, email: \$email, phone: \$phone, user_role: \$user_role, password: \$password) {
      firstname
      id
    }
  }
""";
}
