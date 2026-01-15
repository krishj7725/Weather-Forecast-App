class CityData {
  // A large list of major world cities for your autocomplete
  static final List<String> cities = [
    // --- North America ---
    "New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia",
    "San Antonio", "San Diego", "Dallas", "San Jose", "Austin", "Jacksonville",
    "San Francisco", "Columbus", "Fort Worth", "Indianapolis", "Charlotte",
    "Seattle", "Denver", "Washington", "Boston", "El Paso", "Nashville",
    "Detroit", "Las Vegas", "Portland", "Memphis", "Toronto", "Montreal",
    "Vancouver", "Calgary", "Ottawa", "Edmonton", "Mexico City", "Guadalajara",
    "Monterrey", "Puebla", "Tijuana",

    // --- Europe ---
    "London", "Birmingham", "Manchester", "Glasgow", "Liverpool", "Paris",
    "Marseille", "Lyon", "Toulouse", "Nice", "Berlin", "Hamburg", "Munich",
    "Cologne", "Frankfurt", "Stuttgart", "Dusseldorf", "Rome", "Milan", "Naples",
    "Turin", "Palermo", "Madrid", "Barcelona", "Valencia", "Seville", "Zaragoza",
    "Amsterdam", "Rotterdam", "Brussels", "Antwerp", "Vienna", "Zurich", "Geneva",
    "Stockholm", "Oslo", "Copenhagen", "Helsinki", "Dublin", "Lisbon", "Porto",
    "Athens", "Prague", "Budapest", "Warsaw", "Bucharest", "Istanbul", "Moscow",
    "Saint Petersburg",

    // --- Asia ---
    "Tokyo", "Yokohama", "Osaka", "Nagoya", "Sapporo", "Seoul", "Busan", "Incheon",
    "Beijing", "Shanghai", "Guangzhou", "Shenzhen", "Chengdu", "Hong Kong",
    "Taipei", "Mumbai", "Delhi", "Bangalore", "Hyderabad", "Ahmedabad", "Chennai",
    "Kolkata", "Surat", "Pune", "Jaipur", "Bangkok", "Jakarta", "Ho Chi Minh City",
    "Hanoi", "Kuala Lumpur", "Singapore", "Manila", "Dubai", "Abu Dhabi", "Riyadh",
    "Jeddah", "Doha", "Tel Aviv", "Jerusalem", "Tehran", "Baghdad",

    // --- South America ---
    "Sao Paulo", "Rio de Janeiro", "Brasilia", "Salvador", "Fortaleza",
    "Buenos Aires", "Cordoba", "Rosario", "Santiago", "Bogota", "Medellin",
    "Cali", "Lima", "Caracas", "Quito", "Montevideo",

    // --- Africa ---
    "Cairo", "Alexandria", "Lagos", "Kano", "Kinshasa", "Johannesburg",
    "Cape Town", "Durban", "Nairobi", "Addis Ababa", "Casablanca", "Algiers",
    "Tunis", "Khartoum", "Accra",

    // --- Oceania ---
    "Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide", "Auckland",
    "Wellington", "Christchurch"
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(cities);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}