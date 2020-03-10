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
        id,
        license,
        model,
        color
    }
}
""";
String updateCar = """
mutation UpdateCar(\$id: Int!, \$license: String!, \$model: String!, \$color: String!, ) {
  updateCar(id: \$id, license: \$license, model: \$model, color: \$color) {
    id,
    license,
    model,
    color
  }
}
""";
