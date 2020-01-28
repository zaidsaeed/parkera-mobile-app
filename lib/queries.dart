class Queries {
  String getAll() {
    return """ 
      {
        continents{
          name
        }
      }
    """;
  }
}
