class Track extends ArrayList <Milkstock>{

 ArrayList<Track> maker_track = new ArrayList<Track>(); 
 ArrayList<Track> super_track = new ArrayList<Track>(); 
 
  
  Track(int num){
    for(int i=0; i<num; i++){
      this.add(new Milkstock());
    }
  }
  

  void maker_addtrack(Milk milk){
    milk.movingday_maker_super = day;

    switch(milk.expiration){
      case 14:
        this.get(0).add(milk);
        break;
      case 13:
        this.get(1).add(milk);
        break;
      case 12:
        this.get(2).add(milk);
        break;
      case 11:
        this.get(3).add(milk);
        break;
      case 10:
        this.get(4).add(milk);
        break;
    }

  }
  
  void super_addtrack(Milk milk){
    milk.movingday_stock_shelf = day;

    switch(milk.expiration){
      case 14:
        this.get(0).add(milk);
        break;
      case 13:
        this.get(1).add(milk);
        break;
      case 12:
        this.get(2).add(milk);
        break;
      case 11:
        this.get(3).add(milk);
        break;
      case 10:
        this.get(4).add(milk);
        break;
      case 9:
        this.get(5).add(milk);
        break;
      case 8:
        this.get(6).add(milk);
        break;
      case 7:
        this.get(7).add(milk);
        break;
      case 6:
        this.get(8).add(milk);
        break;
      case 5:
        this.get(9).add(milk);
        break;
    }
    
    
  }


  void maker_list(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\makertrack\\"+"makertrack"+day+".csv"), true));
      file.println("");

      file.print("[MAKERTRACK]");
      file.println("");

      file.print("date: " + day);
      file.println("");
      
      file.print("number");
      file.print(",");
      file.print("expiration");
      file.print(",");
      file.print("seisanbi");
      file.print(",");
      file.print("size");
      file.println(" ");
      
      
      for(int i=0; i < maker_track.size(); i++){
        for(int j=0; j < 5; j++){
          file.print(i+1);
          file.print(",");
          //file.print("makertrack");
          
          if(maker_track.get(i).get(j).size() == 0){
            file.print(" ");
            file.print(",");
            file.print(" "); 
          }else{
            file.print(maker_track.get(i).get(j).search());
            file.print(",");
            file.print(maker_track.get(i).get(j).get(0).production_date);
          }
          
          file.print(",");
          file.print(maker_track.get(i).get(j).size());
          file.println("");
          
        }
      }

      file.close();
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }

  }
  
  void super_list(){
    //println(day);
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\supertrack\\"+"supertrack"+day+".csv"), true));
      file.println("");

      file.print("[SUPERTRACK]");
      file.println("");

      file.print("date: " + day);
      file.println("");
      
      file.print("number");
      file.print(",");
      file.print("expiration");
      file.print(",");
      file.print("seisanbi");
      file.print(",");
      file.print("size");
      file.println(" ");
      
      for(int i=0; i < super_track.size(); i++){
        for(int j=0; j < 10; j++){
          file.print(i+1);
          file.print(",");
          //file.print("makertrack");
          
          if(super_track.get(i).get(j).size() == 0){
            file.print(" ");
            file.print(",");
            file.print(" "); 
          }else{
            file.print(super_track.get(i).get(j).search());
            file.print(",");
            file.print(super_track.get(i).get(j).get(0).production_date);
          }
          
          file.print(",");
          file.print(super_track.get(i).get(j).size());
          file.println("");
          
        }
      }

      file.close();
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }

  }
}
