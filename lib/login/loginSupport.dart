class loginSupport {
  static String readRepositories = """
    query GetAuthenticationbyEmail( \$nEmail: String!) {
      getAuthenticationbyEmail(email: \$nEmail) {
        password,
        userAccountId
      }
    }
  """;
}
