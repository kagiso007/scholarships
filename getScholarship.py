from flask import Flask, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

@app.route('/urls', methods=['GET'])
def get_urls():
    url = 'https://www.internationalscholarships.dhet.gov.za/index.php/scholarships'  # Replace with the target URL
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    urls = []
    for a_tag in soup.find_all('a', href=True):
        urls.append(a_tag['href'])
    
    return jsonify(urls)

if __name__ == '__main__':
    app.run(debug=True)