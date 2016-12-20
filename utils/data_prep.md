
```python
import numpy as np
```

### Create list of cities and populations


```python
outFile = open('/Users/taburaad/Desktop/cities3.txt', 'w')

with open('/Users/taburaad/Desktop/cities2.txt') as inFile:
    for line in inFile:
        line = ','.join(line.split(',')[:2]) +','+ ''.join(line.split(',')[2:])
        print line
        outFile.write(line)
        
outFile.close()
```

    Tokyo/Yokohama,Japan,33200000
    
    New York Metro,USA,17800000
    
    Sao Paulo,Brazil,17700000
    
    Seoul/Incheon,South Korea,17500000
    
    Mexico City,Mexico,17400000
    
    Osaka/Kobe/Kyoto,Japan,16425000
    
    Manila,Philippines,14750000
    
    Mumbai,India,14350000
    
    Delhi,India,14300000
    
    Jakarta,Indonesia,14250000
    
    Lagos,Nigeria,13400000
    
    Kolkata,India,12700000
    
    Cairo,Egypt,12200000
    
    Los Angeles,USA,11789000
    
    Buenos Aires,Argentina,11200000
    
    Rio de Janeiro,Brazil,10800000
    
    Moscow,Russia,10500000
    
    Shanghai,China,10000000
    
    Karachi,Pakistan,9800000
    
    Paris,France,9645000
    
    Istanbul,Turkey,9000000
    
    Nagoya,Japan,9000000
    
    Beijing,China,8614000
    
    Chicago,USA,8308000
    
    London,UK,8278000
    
    Shenzhen,China,8000000
    
    Essen/D\xc3\xbcsseldorf,Germany,7350000
    
    Tehran,Iran,7250000
    
    Bogota,Colombia,7000000
    
    Lima,Peru,7000000
    
    Bangkok,Thailand,6500000
    
    Johannesburg/East Rand,South Africa,6000000
    
    Chennai,India,5950000
    
    Taipei,Taiwan,5700000
    
    Baghdad,Iraq,5500000
    
    Santiago,Chile,5425000
    
    Bangalore,India,5400000
    
    Hyderabad,India,5300000
    
    St Petersburg,Russia,5300000
    
    Philadelphia,USA,5149000
    
    Lahore,Pakistan,5100000
    
    Kinshasa,Congo,5000000
    
    Miami,USA,4919000
    
    Ho Chi Minh City,Vietnam,4900000
    
    Madrid,Spain,4900000
    
    Tianjin,China,4750000
    
    Kuala Lumpur,Malaysia,4400000
    
    Toronto,Canada,4367000
    
    Milan,Italy,4250000
    
    Shenyang,China,4200000
    
    Dallas/Fort Worth,USA,4146000
    
    Boston,USA,4032000
    
    Belo Horizonte,Brazil,4000000
    
    Khartoum,Sudan,4000000
    
    Riyadh,Saudi Arabia,4000000
    
    Singapore,Singapore,4000000
    
    Washington,USA,3934000
    
    Detroit,USA,3903000
    
    Barcelona,Spain,3900000
    
    Houston,USA,3823000
    
    Athens,Greece,3685000
    
    Berlin,Germany,3675000
    
    Sydney,Australia,3502000
    
    Atlanta,USA,3500000
    
    Guadalajara,Mexico,3500000
    
    San Francisco/Oakland,USA,3229000
    
    Montreal.,Canada,3216000
    
    Monterey,Mexico,3200000
    
    Melbourne,Australia,3162000
    
    Ankara,Turkey,3100000
    
    Recife,Brazil,3025000
    
    Phoenix/Mesa,USA,2907000
    
    Durban,South Africa,2900000
    
    Porto Alegre,Brazil,2800000
    
    Dalian,China,2750000
    
    Jeddah,Saudi Arabia,2750000
    
    Seattle,USA,2712000
    
    Cape Town,South Africa,2700000
    
    San Diego,USA,2674000
    
    Fortaleza,Brazil,2650000
    
    Curitiba,Brazil,2500000
    
    Rome,Italy,2500000
    
    Naples,Italy,2400000
    
    Minneapolis/St. Paul,USA,2389000
    
    Tel Aviv,Israel,2300000
    
    Birmingham,UK,2284000
    
    Frankfurt,Germany,2260000
    
    Lisbon,Portugal,2250000
    
    Manchester,UK,2245000
    
    San Juan,Puerto Rico,2217000
    
    Katowice,Poland,2200000
    
    Tashkent,Uzbekistan,2200000
    
    Fukuoka,Japan,2150000
    
    Baku/Sumqayit,Azerbaijan,2100000
    
    St. Louis,USA,2078000
    
    Baltimore,USA,2076000
    
    Sapporo,Japan,2075000
    
    Tampa/St. Petersburg,USA,2062000
    
    Taichung,Taiwan,2000000
    
    Warsaw,Poland,2000000
    
    Denver,USA,1985000
    
    Cologne/Bonn,Germany,1960000
    
    Hamburg,Germany,1925000
    
    Dubai,UAE,1900000
    
    Pretoria,South Africa,1850000
    
    Vancouver,Canada,1830000
    
    Beirut,Lebanon,1800000
    
    Budapest,Hungary,1800000
    
    Cleveland,USA,1787000
    
    Pittsburgh,USA,1753000
    
    Campinas,Brazil,1750000
    
    Harare,Zimbabwe,1750000
    
    Brasilia,Brazil,1625000
    
    Kuwait,Kuwait,1600000
    
    Munich,Germany,1600000
    
    Portland,USA,1583000
    
    Brussels,Belgium,1570000
    
    Vienna,Austria,1550000
    
    San Jose,USA,1538000
    
    Damman,Saudi Arabia,1525000
    
    Copenhagen,Denmark,1525000
    
    Brisbane,Australia,1508000
    
    Riverside/San Bernardino,USA,1507000
    
    Cincinnati,USA,1503000
    
    Accra,Ghana, 1500000
    


### Create list of cities and their percentage population


```python
cities = []
probs = []

with open('/Users/taburaad/Desktop/cities3.txt') as inFile:
    for line in inFile:
        prob = float(line.split(',')[2])/660404000.0
        location = line.split(',')[:2]
        probs.append(prob)
        cities.append(','.join(location))
        
print cities
```

    ['Tokyo,Japan', 'New York,USA', 'Sao Paulo,Brazil', 'Seoul,South Korea', 'Mexico City,Mexico', 'Osaka,Japan', 'Manila,Philippines', 'Mumbai,India', 'Delhi,India', 'Jakarta,Indonesia', 'Lagos,Nigeria', 'Kolkata,India', 'Cairo,Egypt', 'Los Angeles,USA', 'Buenos Aires,Argentina', 'Rio de Janeiro,Brazil', 'Moscow,Russia', 'Shanghai,China', 'Karachi,Pakistan', 'Paris,France', 'Istanbul,Turkey', 'Nagoya,Japan', 'Beijing,China', 'Chicago,USA', 'London,UK', 'Shenzhen,China', 'Essen,Germany', 'Tehran,Iran', 'Bogota,Colombia', 'Lima,Peru', 'Bangkok,Thailand', 'Johannesburg,South Africa', 'Chennai,India', 'Taipei,Taiwan', 'Baghdad,Iraq', 'Santiago,Chile', 'Bangalore,India', 'Hyderabad,India', 'St Petersburg,Russia', 'Philadelphia,USA', 'Lahore,Pakistan', 'Kinshasa,Congo', 'Miami,USA', 'Ho Chi Minh City,Vietnam', 'Madrid,Spain', 'Tianjin,China', 'Kuala Lumpur,Malaysia', 'Toronto,Canada', 'Milan,Italy', 'Shenyang,China', 'Dallas/Fort Worth,USA', 'Boston,USA', 'Belo Horizonte,Brazil', 'Khartoum,Sudan', 'Riyadh,Saudi Arabia', 'Singapore,Singapore', 'Washington,USA', 'Detroit,USA', 'Barcelona,Spain', 'Houston,USA', 'Athens,Greece', 'Berlin,Germany', 'Sydney,Australia', 'Atlanta,USA', 'Guadalajara,Mexico', 'San Francisco/Oakland,USA', 'Montreal.,Canada', 'Monterey,Mexico', 'Melbourne,Australia', 'Ankara,Turkey', 'Recife,Brazil', 'Phoenix/Mesa,USA', 'Durban,South Africa', 'Porto Alegre,Brazil', 'Dalian,China', 'Jeddah,Saudi Arabia', 'Seattle,USA', 'Cape Town,South Africa', 'San Diego,USA', 'Fortaleza,Brazil', 'Curitiba,Brazil', 'Rome,Italy', 'Naples,Italy', 'Minneapolis/St. Paul,USA', 'Tel Aviv,Israel', 'Birmingham,UK', 'Frankfurt,Germany', 'Lisbon,Portugal', 'Manchester,UK', 'San Juan,Puerto Rico', 'Katowice,Poland', 'Tashkent,Uzbekistan', 'Fukuoka,Japan', 'Baku/Sumqayit,Azerbaijan', 'St. Louis,USA', 'Baltimore,USA', 'Sapporo,Japan', 'Tampa/St. Petersburg,USA', 'Taichung,Taiwan', 'Warsaw,Poland', 'Denver,USA', 'Cologne/Bonn,Germany', 'Hamburg,Germany', 'Dubai,UAE', 'Pretoria,South Africa', 'Vancouver,Canada', 'Beirut,Lebanon', 'Budapest,Hungary', 'Cleveland,USA', 'Pittsburgh,USA', 'Campinas,Brazil', 'Harare,Zimbabwe', 'Brasilia,Brazil', 'Kuwait,Kuwait', 'Munich,Germany', 'Portland,USA', 'Brussels,Belgium', 'Vienna,Austria', 'San Jose,USA', 'Damman,Saudi Arabia', 'Copenhagen,Denmark', 'Brisbane,Australia', 'Riverside/San Bernardino,USA', 'Cincinnati,USA', 'Accra,Ghana']



```python
test = np.random.choice(cities, p=probs)
print test
```

    Mumbai,India


### Use cities list and their associated population ratios to create a randomized dataset assigning each 
### unique user with a city


```python
outFile = open('/Users/taburaad/Desktop/users_and_cities.txt', 'w')

with open('/Users/taburaad/Desktop/unique_users.txt') as inFile:
    for line in inFile:
        city = np.random.choice(cities, p=probs)
        outline = line[:-1] + ',' + city + '\n'
        outFile.write(outline)
        
outFile.close()
```


```python
outFile = open('/Users/taburaad/Desktop/cities.txt', 'w')

for element in cities:
    city = element.split(',')[0]
    line = '<option value="{}">{}</option>'.format(city,city)
```

### Create dictionary of genres


```python
tag_dict = {}
with open('/Users/taburaad/Documents/bigdata/msd_tagtraum.cls') as inFile:
    for line in inFile:
        track_id, tag = line.split()[:2][0], line.split()[:2][1]
        tag_dict[track_id] = tag
```

### Create big dataset of 1 million unique tracks and their associated genres, if they have one


```python
count = 0
outFile = open('/Users/taburaad/Desktop/unique_tracks_and_genre_pipe.txt', 'w')

with open('/Users/taburaad/Desktop/unique_tracks_pipe.txt') as inFile:
    for line in inFile:
        count +=1
        track_id = line.split('|')[0]
        if track_id in tag_dict:
            #print 'found', track_id, tag_dict[track_id]
            newLine = line[:-1] + "|" + tag_dict[track_id] + '\n'
            outFile.write(newLine)
        else:
            newLine = line[:-1] + "|" + 'unidentified-genre' + '\n'
            outFile.write(newLine)
outFile.close()
```
