String addParkingSpotMutation = """
mutation AddParkingSpot(\$address: String!,\$userAccountId: Int!) {
  addParkingSpot(address: \$address, userAccountId: \$userAccountId) {
    id
  }
}
""";