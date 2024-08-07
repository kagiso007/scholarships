import requests
from bs4 import BeautifulSoup
import csv

# URL of the page to scrape
url = 'https://damelinconnect.co.za/bursaries-in-south-africa/?gad_source=1&gclid=CjwKCAjwhvi0BhA4EiwAX25uj4-tOK9vi_XsNS_hkFk8MEY_7j-phjS6EwJ1NX_gElm2EXfAVqVzdxoCrM8QAvD_BwE'

# Make a GET request to fetch the raw HTML content
response = requests.get(url)

# Parse the content with BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# Open a CSV file to write the results
with open('damelin_bursaries.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(['Title', 'Link'])

    # Iterate over each bursary entry and extract the details
    for entry in soup.find_all('section', class_='elementor-section'):
        # Extract the title
        title_element = entry.find('h2')
        if not title_element:
            continue
        title = title_element.get_text(strip=True)

        # Extract the link
        link_element = entry.find('a')
        link = link_element['href'] if link_element else 'No Link'

        # Write the details to the CSV file
        writer.writerow([title, description, link])

print('Data has been written to damelin_bursaries.csv')
