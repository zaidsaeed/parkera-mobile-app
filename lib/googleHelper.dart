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