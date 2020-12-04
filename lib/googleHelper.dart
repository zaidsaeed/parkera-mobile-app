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
mutation addBooking(\$userAccountId: Int!,\$parkSpotId: Int!,\$carInfoId: Int!,\$duration: Int!) {
  addBooking(userAccountId: \$userAccountId, parkSpotId: \$parkSpotId, carInfoId: \$carInfoId, duration: \$duration) {
    id
  }
}
""";

String deleteOrder = """
mutation deleteBooking(\$id: Int!) {
  deleteBooking(id: \$id) {
    id
  }
}
""";
