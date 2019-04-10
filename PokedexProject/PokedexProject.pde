import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;
import java.util.HashMap;
import java.util.TreeMap;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.util.Collections;
Map<String,Pokemon> pokeMap;//map that stores all pokemon with their names as keys
Map<Integer, String> idToName;//stores each name for getting from only the id
Boolean switched = false, highlight = false, help = true, typeChart = false, auto = true;//leave false to be interactive, set to true to leave it running
int mode = 0;//0 is randomly, 1 is numerically, 2 is Alphabetically 
String generation, tempSearch="0";
PImage[] icons;
PImage chart;
Pokemon current;
ArrayList<String> names;
color mainCol;

void setup(){
  loadMap();
  current = pokeMap.get("Bulbasaur");
  names = new ArrayList<String>(pokeMap.keySet());
  println(names);
  for(int i=0; i<names.size(); i++){
    pokeMap.get(names.get(i)).alphaI = i+1;
  }mainCol = color(200,20,20);
  //colors = new HashMap<String, color>();
  icons = new PImage[812];
  loadImages();
  size(1280,720);
}

void draw(){
  changeColor();
  background(switched?100:mainCol);
  showBase();
  if(auto){
    if(frameCount%200==0)
      nextPoke();
  }if(typeChart){
    image(chart, 0, 0, width, height);
  }if(help){
    showHelp();
  }
}

void mousePressed(){
  if(highlight)
    link("https://bulbapedia.bulbagarden.net/w/index.php?title="+current.name+"_(Pok%C3%A9mon)");
  else
    switched = !switched;
}

void mouseMoved(){
  highlight = (mouseX>985&&mouseX<1245&&mouseY<295&&mouseY>35);
}

void keyPressed(){
  switch(keyCode){
    case 65://a
      auto = !auto;
      break;
    case 83://s
      switched = !switched;
      break;
    case 84://t
      typeChart = !typeChart;
      break;
    case 72://h
      help = !help;
      break;
    case 78://n
      mode = 1;
      break;
    case 77://m
      mode = 2;
      break;
    case 82://r
      mode = 0;
      break;
    case 32://space bar
      tempSearch="0";
      break;
    case 48://0
      tempSearch += 0;
      break;
    case 49://1
      tempSearch += 1;
      break;
    case 50://2
      tempSearch += 2;
      break;
    case 51://3
      tempSearch += 3;
      break;
    case 52://4
      tempSearch += 4;
      break;
    case 53://5
      tempSearch += 5;
      break;
    case 54://6
      tempSearch += 6;
      break;
    case 55://7
      tempSearch += 7;
      break;
    case 56://8
      tempSearch += 8;
      break;
    case 57://9
      tempSearch += 9;
      break;
    case ENTER://Enter key
      if(parseInt(tempSearch)!=0&&parseInt(tempSearch)<names.size()+1&&getPoke(parseInt(tempSearch))!=null)
        current = getPoke(parseInt(tempSearch));
      println(tempSearch);
      break;
    case 39://Right Arrow
      nextPoke();
      break;
    case 37://Left Arrow
      prevPoke();
      break;
  }
}

void showBase(){ // displays the base area for each pokemon to appear in
  noStroke();
  fill((switched?mainCol:100),(highlight?50:0));
  rect(985,35,260,260);
  fill(switched?mainCol:100);
  rect(0,0,1280,30);
  rect(0,0,30,720);
  rect(0,690,1280,30);
  rect(1250,0,30,720);
  rect(35,35,500,650);
  rect(540,300,705,385);
  rect(540,35,440,260);
  fill(250);
  textSize(32);
  text("Biology", 550, 300, 690, 650);
  textSize(20);
  text(current.biology, 550, 340, 690, 650);
  if(current.infoBox!=null)
    for(int i=0; i<current.infoBox.size(); i++)
      text(current.infoBox.get(i), i%2==1?300:40, 30*(i/2+1)+10, 500, 550);
  textSize(14);
  if(current.typeEffectiveness!=null)
    for(int i=3; i<current.typeEffectiveness.size(); i++){
      if(i%3==1){
        text(current.typeEffectiveness.get(i), 820, 25*((i-3)/3+1)+10, 500, 550);
      }else if(i%3>.5){
        text(current.typeEffectiveness.get(i), 690, 25*((i-3)/3+1)+10, 500, 550);
      }else{
        text(current.typeEffectiveness.get(i), 560, 25*((i-3)/3+1)+10, 500, 550);
      }
    }
  image(icons[current.index-1], 985, 35, 260, 260);
}

void changeColor(){
  switch(current.mainType){
    case " Grass":
      mainCol = color(120, 200, 80);
      break;
    case " Fire":
      mainCol = color(240, 128, 48);
      break;
    case " Water":
      mainCol = color(104, 144, 240);
      break;
    case " Bug":
      mainCol = color(168, 184, 32);
      break;
    case " Normal":
      mainCol = color(168, 168, 120);
      break;
    case " Flying":
      mainCol = color(168, 144, 240);
      break;
    case " Poison":
      mainCol = color(160, 64, 160);
      break;
    case " Dark":
      mainCol = color(112, 88, 72);
      break;
    case " Electric":
      mainCol = color(248, 208, 48);
      break;
    case " Psychic":
      mainCol = color(248, 88, 136);
      break;
    case " Ground":
      mainCol = color(224, 192, 104);
      break;
    case " Ice":
      mainCol = color(152, 216, 216);
      break;
    case " Steel":
      mainCol = color(184, 184, 208);
      break;
    case " Fairy":
      mainCol = color(238, 153, 172);
      break;
    case " Fighting":
      mainCol = color(192, 48, 48);
      break;
    case " Rock":
      mainCol = color(184, 160, 56);
      break;
    case " Ghost":
      mainCol = color(112, 88, 152);
      break;
    case " Dragon":
      mainCol = color(112, 56, 248);
      break;
  }
}

void showHelp(){//displays a help menu with easy instructions on what each key press can do
  fill(switched?mainCol:100);
  rect(35, 35, 1210, 650);
  textSize(20);
  fill(255);
  text("Welcome to our Pokedex Project's Help Menu! To exit hit H\n==Keys to change what is seen==\n"+
  "* A * ------------------------switch between automated and regular\n"+
  "* Space * --------------------clears any search entry by index number\n"+
  "* 0-9 * ----------------------types into a search value\n"+
  "* Enter * --------------------Searches for and grabs the pokemon\n"+
  "* click/s * ------------------switches the color sceme\n"+
  "* Right/Left Arrow Keys * ----Naviagte between Pokemon\n"+
  "* T * ------------------------Show the Type Matchup Table\n"+
  "* S * ------------------------Switch the color scheme\n"+
  "* H * ------------------------Toggle the Help Menu\n"+
  "* click on image * -----------Opens the link to the pokemon on Bulbapedia\n"+
  "* N * ------------------------Auto goes numerically\n"+
  "* M * ------------------------Auto goes Alphabetically\n"+
  "* R * ------------------------Auto goes randomly (Default)", 70, 45, 1245, 685);
}

void nextPoke(){//looks at the mode and decides how to navigate to the next one based off of that
  if(mode==0)//random
    current = getPoke((int)random(pokeMap.keySet().size())-1);
  if(mode==1)//numerically
    current = getPoke(current.index!=names.size()?current.index+1:1);
  if(mode==2)//alphabetically
    current = pokeMap.get(names.get(current.alphaI!=names.size()?current.alphaI+1:1));
}

void prevPoke(){//goes to the previous if not random mode, otherwise gives a new random
  if(mode==1)//numerically
    current = getPoke(current.index!=1?current.index-1:1);
  if(mode==2)//alphabetically
    current = pokeMap.get(names.get(current.alphaI!=1?current.alphaI-1:names.size()));
  if(mode==0)//otherwise random
    current = getPoke((int)random(pokeMap.keySet().size())-1);
}

void loadImages(){
  for(int i=0; i<idToName.size(); i++){
    if(idToName.get(i+1).equals("Type: Null"))//The name has an invalid syntax for image naming
      icons[i]=loadImage("Type_Null.png");
    else
      icons[i]=loadImage(idToName.get(i+1)+".png");
  }chart = loadImage("TypeMatchupChart.png");
  println("images loaded");
}

Pokemon getPoke(int nIndex){
  return pokeMap.get(idToName.get(nIndex));
}

void loadMap(){
  XML pokeData=loadXML("bulbWikiCode.xml");
  pokeMap=new TreeMap<String,Pokemon>();
  idToName = new TreeMap<Integer, String>();
  String[] childList=pokeData.listChildren();
  for(int i=0;i<childList.length;i++){
    pokeMap.put(pokeData.getChild(i).getString("name"),new Pokemon(pokeData.getChild(i).getContent(), pokeData.getChild(i).getString("name"), i+1));
    idToName.put(i+1, pokeData.getChild(i).getString("name"));
  }
}
