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
    poke_wiki.insert(i, new_soup('https://bulbapedia.bulbagarden.net/w/index.php?title='+ poke_names[i]+'_(Pok%C3%A9mon)&action=edit').textarea.string)
    ET.SubElement(root, 'pokemon', id=str(i), name=poke_names[i]).text = poke_wiki[i]

file = ET.ElementTree(root)
file.write('bulbWikiCode.xml')