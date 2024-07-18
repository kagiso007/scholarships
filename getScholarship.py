import requests

from bs4 import BeautifulSoup
import pandas as pd
import time

# URL of the website to scrape
url = "https://www.imdb.com/chart/top"

# Send an HTTP GET request to the website
response = requests.get(url)

# Parse the HTML code using BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# Extract the relevant information from the HTML code
movies = []
for row in soup.select('tbody.lister-list tr'):
    title = row.find('td', class_='titleColumn').find('a').get_text()
    year = row.find('td', class_='titleColumn').find('span', class_='secondaryInfo').get_text()[1:-1]
    rating = row.find('td', class_='ratingColumn imdbRating').find('strong').get_text()
    movies.append([title, year, rating])

# Store the information in a pandas dataframe
df = pd.DataFrame(movies, columns=['Title', 'Year', 'Rating'])

# Add a delay between requests to avoid overwhelming the website with requests
time.sleep(1)

# Export the data to a CSV file
df.to_csv('top-rated-movies.csv', index=False)