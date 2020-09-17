String addParkingSpotMutation = """
mutation AddParkingSpot(\$address: String!,\$userAccountId: Int!, \$latitude: Float!, \$longitude: Float!, \$price: Float!,) {
  addParkingSpot(address: \$address, userAccountId: \$userAccountId, latitude: \$latitude, longitude: \$longitude, price: \$price) {
    id
  }
}
""";