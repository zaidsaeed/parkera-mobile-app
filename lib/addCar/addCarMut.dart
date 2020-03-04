String addCarMutation = """
mutation AddCar(\$license: String!, \$model: String!, \$color: String!, \$userAccountId: Int!) {
  addCar(license: \$license, model: \$model, color: \$color, userAccountId: \$userAccountId) {
    id
  }
}
""";