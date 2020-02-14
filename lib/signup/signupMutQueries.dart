class SignUpMutQueries {
  String addUser(String firstname, String lastname, String email, String phone,
      String user_role) {
    return """
      mutation{
          addUser(firstname: "$firstname", lastname: "$lastname", email: "$email", phone: "$phone", user_role: "$user_role"){
            name
            lastName
          }
      }    
     """;
  }
}
