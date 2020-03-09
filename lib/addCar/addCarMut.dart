String addCarMutation = """
mutation AddCar(\$license: String!, \$model: String!, \$color: String!, \$userAccountId: Int!) {
  addCar(license: \$license, model: \$model, color: \$color, userAccountId: \$userAccountId) {
    id
  }
}
""";


String queryByUid = """
query GetcarsByUserId( \$nUid: Int!) {
      carsByUserId(userAccountId: \$nUid) {
        license,
        model,
        color
    }
}
""";

