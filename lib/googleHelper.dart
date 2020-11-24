String searchNear = """
query searchNear( \$dlatitude: Float!, \$dlongitude: Float!) {
      searchNear(latitude: \$dlatitude, longitude: \$dlongitude) {
            id,
            address,
            latitude,
            longitude,
            price
    }
}
""";

String addOrder = """
mutation addBooking(\$userAccountId: Int!,\$parkSpotId: Int!,\$carInfoId: Int!) {
  addBooking(userAccountId: \$userAccountId, parkSpotId: \$parkSpotId, carInfoId: \$carInfoId) {
    id
  }
}
""";
