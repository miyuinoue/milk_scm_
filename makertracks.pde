class MakerTracks extends ArrayList <Track>{
  
  MakerTracks(){
  }
  
  void addtrack(Milk milk){
    this.get(this.size()-1).maker_addtrack(milk);
  }
  
  void maker_newlist(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\track\\"+"makertrack.csv")));
      file.println("");

      file.print("[MAKERTRACK]");
      file.println("");

      file.print("date");
      file.print(",");
      
      file.print("expiration");     
      for(int i=14; i>9; i--){
        file.print(",");
      }
      file.print("size");
      
      file.println(" ");
      
      for(int i=14; i>9; i--){
        file.print(",");
        file.print(i);
      }
      file.println(" ");

      
      file.close();
    
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }  
  }      
    
  
  void maker_addlist(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\track\\"+"makertrack.csv"),true));
      
      file.print(day);
      file.print(","); 
           
      for(int j=0; j < 5; j++){
        if(this.size() == 0){
          file.print(" ");
          file.print(",");
        }else{
          file.print(this.get(this.size()-1).get(j).size());
          file.print(",");
        }
      }
      file.println(" ");

      file.close();  
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }
   
  
}
