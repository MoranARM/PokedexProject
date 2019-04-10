class Pokemon implements Comparable<Pokemon>{
  String wikiCode, mainType="", name, biology="";//text explaining the pokemon biology
  ArrayList<String> typeEffectiveness;
  ArrayList<String> evolution;
  ArrayList<String> infoBox;
  int index=-1, alphaI;
  Pokemon(String xml, String n, int ind){
    name = n;
    index = ind;
    wikiCode=xml;
    try{
      Scanner data=new Scanner(wikiCode);
      int count=0;
      String tempEff="", tempEvo="", tempInfo="";
      while(data.hasNextLine()){
        String s=data.nextLine();
        if(s.contains("==")&&(s.contains("Biology")||s.contains("Type effectiveness")||s.contains("Evolution"))){
          count++;
          s=data.nextLine();
          do{
            if(count==1){
              biology+=s;
            }else if(count==2){
              tempEff+=s.replaceAll("}}","")+"\n";
            }else if(count==3){
              tempEvo+=s+"\n";
            }
            s=data.nextLine();
          }while(!s.equals(""));
        }else if(s.contains("{{Pokémon Infobox")){
          s=data.nextLine();
          do{
            tempInfo+=s+"\n";
            s=data.nextLine();
          }while(!s.contains("}}"));
        }
      }typeEffectiveness=new ArrayList<String>(Arrays.asList(tempEff.split("\n")));
      //for(int i=0; i<typeEffectiveness.size(); i++){
      //  if(typeEffectiveness.get(i).contains("="))
      //    typeEffectiveness.set(i, typeEffectiveness.get(i).substring(1, typeEffectiveness.get(i).indexOf("="))+" = "+typeEffectiveness.get(i).substring(typeEffectiveness.get(i).indexOf("=")+1));
      //}
      for(int i=0; i<typeEffectiveness.size(); i++){
        if(typeEffectiveness!=null && typeEffectiveness.size()>4)
          if(typeEffectiveness.get(i).contains("=") && typeEffectiveness.get(i).indexOf("=")+1!=typeEffectiveness.size())
            typeEffectiveness.set(i, typeEffectiveness.get(i).substring(1, typeEffectiveness.get(i).indexOf("="))+" = "+typeEffectiveness.get(i).substring(typeEffectiveness.get(i).indexOf("=")+1));
      }
      /*for(int i=typeEffectiveness.size()-1; i>=0; i--){
          if(!typeEffectiveness.get(i).contains("0")||!typeEffectiveness.get(i).contains("25")){
            typeEffectiveness.remove(i);
          }
      }*/
      evolution=new ArrayList<String>(Arrays.asList(tempEvo.split("\n")));
      //for(int i=0; i<evolution.size(); i++){
      //  if(evolution.get(i).contains("=") && evolution.get(i).indexOf("=")!=evolution.get(i).length()-1)
      //    evolution.set(i, evolution.get(i).substring(1, evolution.get(i).indexOf("="))+" = "+evolution.get(i).substring(evolution.get(i).indexOf("=")+1));
      //}
      String[] blackList = {"jname", "jtranslit", "tmname", "u2dex", "egggroup", "expyield"};
      infoBox=new ArrayList<String>(Arrays.asList(tempInfo.split("\n")));
      for(int i=infoBox.size()-1; i>=0; i--){
        if(infoBox.get(i).contains("="))
          infoBox.set(i, infoBox.get(i).substring(1, infoBox.get(i).indexOf("="))+" = "+infoBox.get(i).substring(infoBox.get(i).indexOf("=")+1));
        if(infoBox.get(i).contains("type1 = "))
          mainType = infoBox.get(i).substring(infoBox.get(i).indexOf("= ")+1);
        //for(int j=0; j<blackList.length; j++)
        //  if(infoBox.get(i).contains(blackList[j]))
        //    infoBox.remove(i);
      }
      data.close();
    }catch(Exception e){
      e.printStackTrace();
    }
  }
  
  int compareTo(Pokemon other){
    if(index<other.index)
      return 1;
    if(index>other.index)
      return -1;
    return 0;
  }
  
  String toString(){
    println(wikiCode);
    return wikiCode;
  }
}
