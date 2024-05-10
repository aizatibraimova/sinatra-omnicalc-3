require "sinatra"
require "sinatra/reloader"
require "http"
require "sinatra/cookies"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get("/umbrella") do
  erb(:umbrella_form)
end

post("/process_umbrella") do
  @user_location = params.fetch("user_loc")

  url_encoded_string = @user_location.gsub(" ", "+")

  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encoded_string}&key=AIzaSyDKz4Y3bvrTsWpPRNn9ab55OkmcwZxLOHI"

  @raw_response = HTTP.get(gmaps_url).to_s

  @parsed_response = JSON.parse(@raw_response)

  @loc_hash = @parsed_response.dig("results", 0, "geometry", "location")

  @latitude = @loc_hash.fetch("lat")
  @longitude = @loc_hash.fetch("lng")

  cookies["last_location"] = @user_location
  cookies["last_lat"] = @latitude
  cookies["last_lng"] = @longitude


require "http"
pirate_weather_api_key =  ENV.fetch("PIRATE_WEATHER_KEY")
# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{@latitude},#{@longitude}"

# Place a GET request to the URL
raw_pirate_weather_data = HTTP.get(pirate_weather_url)

require "json"

parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)

@currently_hash = parsed_pirate_weather_data.fetch("currently")

@current_temp = @currently_hash.fetch("temperature")

@current_summary = @currently_hash.fetch("summary")

@rain_chance = @currently_hash.fetch("precipProbability")

precip_prob_threshold = 0.10

any_precipitation = false


  erb(:umbrella_result)
end
