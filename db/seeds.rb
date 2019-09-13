race = Race.create(name: 'Israman', kind: Race::Kind::TRIATHLON, picture: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRU23_4tV3cvaSK4_T96H9_x6mrKzscc9cXW08nR0t2fjQyD8uO')

%w[
  25-01-2013
  17-01-2014
  29-01-2015
  29-01-2016
  27-01-2017
  26-01-2018
].each do |date|
  parsed_date = DateTime.strptime(date, '%d-%m-%Y')
  RaceEvent.create(race_id: race.id, year: parsed_date.year, occured_at: parsed_date)
end
