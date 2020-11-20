String addParkingSpotMutation = """
mutation AddParkingSpot(\$address: String!,\$userAccountId: Int!, \$latitude: Float!, \$longitude: Float!, \$price: Float!,) {
  addParkingSpot(address: \$address, userAccountId: \$userAccountId, latitude: \$latitude, longitude: \$longitude, price: \$price) {
    id
  }
}
""";


String queryByUid = """
query GetParkingSpotsByUserId( \$nUid: Int!) {
      parkingSpotsByUserId(userAccountId: \$nUid) {
            id,
            address,
            latitude,
            longitude,
            price
    }
}
""";

String updateParkingSpot = """
mutation updateParkingSpot(\$id: Int!, \$address: String!, \$latitude: Float!, \$longitude: Float!, \$price: Float!,) {
  updateParkingSpot(id: \$id, address: \$address, latitude: \$latitude, longitude: \$longitude, price: \$price) {
      id,
      address,
      latitude,
      longitude,
      price
  }
}
""";
