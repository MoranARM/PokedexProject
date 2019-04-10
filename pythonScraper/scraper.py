#!/usr/bin/python
import requests
from bs4 import BeautifulSoup
import xml.etree.cElementTree as ET

def new_soup(url):  # function to create new html objects from bs
    return BeautifulSoup(requests.get(url).content, 'html5lib')

URL = "https://bulbapedia.bulbagarden.net/wiki/List_of_Pokemon_by_National_Pokedex_number"
soup = new_soup(URL)
# print(soup.prettify())  # prints out the html

poke_names = []  # a list to store the names that will be used to go to each wikicode page
poke_wiki = []  # a list to store each pokemons wikicode

id = 0  # keeps track of the corresponding pokemon id
for table in soup.findAll('table', attrs={'align': 'center'}):  # loop through each generation's table
    for row in table.tbody.findAll('tr')[1:]:  # loop through the rows
        title = row.findAll('td')[2].find('a')['title']  # temp store the title (name)
        if((id!=0 and poke_names[id-1]!=title) or id==0):  # prevents duplicates
            poke_names.insert(id, title)
            print (poke_names[id]+' '+str(id+1))
            id += 1 

# After collecting the names of each pokemon, the wikicode is taken from their respective urls
# A new xml document is made containing all of the pokemon wikicode sorted by id

root = ET.Element('root')
for i in range(len(poke_names)-1):
    poke_wiki.insert(i, new_soup('https://bulbapedia.bulbagarden.net/w/index.php?title='+poke_names[i]+'_(Pok%C3%A9mon)&action=edit').textarea.string)
    ET.SubElement(root, 'pokemon', id=str(i), name=poke_names[i]).text = poke_wiki[i]  # adds in each of the pokemon wikicode in a pokemon subtag 

file = ET.ElementTree(root)  # creates the Element Tree 
file.write('bulbWikiCode.xml')  # writes the tree to an actual file

chart = ET.Element('chart')  # Starting a similar process over to hold the type mathup chart
type_table = new_soup('https://bulbapedia.bulbagarden.net/wiki/Type').find('table', attrs={'style': 'border: 2px solid #111; background:#555; margin-right: 5px; margin-bottom: 5px'}).tbody.findAll('tr')
ET.SubElement(chart, 'type', index=str(0), name='x').text = 'x'
first_col = type_table[1].findAll('th')[1:]
for i in range(len(first_col)):  # goes through and adds in the first row of only types
    type = first_col[i].find('a')['title']
    ET.SubElement(chart, 'type', index=str(i+1), name=''+type).text = type

for row in type_table[2:-1]:  # Goes through the rows containing types and values
    type = row.find('a')['title']
    ET.SubElement(chart, 'type', index='0', name=''+type).text = type  # add in the type from the row
    col = row.findAll('td')
    for i in range(len(col)):
        val = '0.5x' if ('½×' in col[i].string) else ''+col[i].string.strip()  # fixes 1/2 to be 0.5 for later math and removes whitespace
        ET.SubElement(chart, 'value', index=str(i), name=''+val).text = val

type_chart = ET.ElementTree(chart)
type_chart.write('typeMatchup.xml')  # new file is made holding the type matchup chart

# The final data needed is the images of each pokemon
for i in range(len(poke_names)-1):
    temp_url = 'https:'+new_soup('https://bulbapedia.bulbagarden.net/w/index.php?title='+poke_names[i]+'_(Pok%C3%A9mon)').find('img', attrs={'alt': ''+poke_names[i]})['src']
    print(temp_url)
    r = requests.get(temp_url)
    with open(''+poke_names[i]+'.png','wb') as f:  # creates the image and names it
        f.write(r.content)  # writes the image