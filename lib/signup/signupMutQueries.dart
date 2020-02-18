class SignUpMutQueries {
  // String addUser(String firstname, String lastname, String email, String phone,
  //     String userRole) {
  //   return """
  //     mutation{
  //         addUser(firstname: "$firstname", lastname: "$lastname", email: "$email", phone: "$phone", user_role: "$userRole"){
  //           name
  //           lastName
  //         }
  //     }
  //    """;
  // }

  String addUser = """
  mutation AddUser(\$firstname: String!, \$lastname: String!, \$email: String!, \$phone: String!, \$user_role: String!) {
    addUser(firstname: \$firstname, lastname: \$lastname, email: \$email, phone: \$phone, user_role: \$user_role) {
      firstname
    }
  }
""";
}
