class MakerTracks extends ArrayList <Track>{
  
  MakerTracks(){
  }
  
  void addtrack(Milk milk){
    this.get(this.size()-1).maker_addtrack(milk);
  }
  
  //void maker_newlist(){
  //  try{
  //    PrintWriter file = new PrintWriter(new FileWriter(new File("/Users/miyuinoue/Desktop/milk_scm/scm_" + month() + "_" + day() +"/track/makertrack.csv")));
  //    file.println("");

  //    file.print("[MAKERTRACK]");
  //    file.println("");

  //    file.print("date");
  //    file.print(",");
      
  //    file.print("expiration");     
  //    for(int i=14; i>(delivery_deadline-1); i--){
  //      file.print(",");
  //    }
  //    file.print("size");
      
  //    file.println(" ");
      
  //    for(int i=14; i>(delivery_deadline-1); i--){
  //      file.print(",");
  //      file.print(i);
  //    }
  //    file.println(" ");

      
  //    file.close();
    
  //  }catch (IOException e) {
  //    println(e);
  //    e.printStackTrace();
  //  }  
  //}      
    
  
  void maker_addfile() {
    try {
      //PrintWriter file = new PrintWriter(new FileWriter(new File("/Users/miyuinoue/Desktop/milk_scm/scm_" + month() + "_" + day() +"/track/makertracks.csv"),true));
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\milk_scm\\scm_"+ month() + "_" + day() +"\\track\\makertracks.csv"),true));

      file.print("date");
      file.print(",");

      file.print("expiration");        
      file.println(" ");

      for (int i=14; i>=delivery_deadline; i--) {
        file.print(",");
        file.print(i + "niti");
      }
      file.println(" ");
      int date=1;

      for (int k=0; k<this.size(); k++) {
        file.print(date);
        file.print(",");
        date++;

        if (this.get(k).size() == 0) {
          for (int i=0; i<10; i++) {
            file.print("0");
            file.print(",");
          }
          file.println(" ");
        } else {

          for (int j=0; j < this.get(k).size(); j++) {
            file.print(this.get(k).get(j).size());
            file.print(",");
          }
          file.println(" ");
        }
      }
      file.println(" ");

      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }
   
  
}
