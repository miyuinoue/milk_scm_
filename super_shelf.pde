class Supershelf extends ArrayList <Milkstock>{
  int e;
  
  IntList s = new IntList();
  
  int order_quantity = 150;
  double standard_devision = 10;
  int demand_forecast = 100;
  int sales_size = 0;

  int safty_stock_super=0;  
  
  int leadtime = 0;
  int ordercycle = 1;
  
  

 Supershelf(){

 }
 
   //日付が変わると賞味期限が-1日される
  void shelf_daychange(){
    for(int i=0; i < this.size(); i++){
      this.get(i).daychange();
    }
  }
  
  
  void super_first() {
    for (int i=0; i<7; i++) {
      s.append(70);
    }
  }

  void super_appdate() {
    s.remove(0);  
    s.append(this.sales_size); 
    sales_size = 0;
  }

  void demand_forecast() {
    int sum = 0;
    for (int i=0; i<7; i++) {
      sum += s.get(i);
    }
    demand_forecast = sum/7;
  }

  void standard_deviation() {
    int var=0;
    for (int i=0; i<7; i++) {
      var+=(s.get(i)-demand_forecast)*(s.get(i)-demand_forecast);
    }
    standard_devision=Math.sqrt(var/(7-1));
  }

  void safty_stock() {
    safty_stock_super = (int)(1.65*standard_devision);
  }
  
  //発注量o
  int order(int istock, int ishelf){
    order_quantity = (leadtime + ordercycle)*demand_forecast - 1 - (istock + ishelf) + safty_stock_super;
    
    return order_quantity;
  }
  
  //在庫量
  int inventories(){
    int inv = 0;
   int size = (E - sales_deadline + 1); //10
    int num;
    if(this.size() < size){
      num = 0;
    }else{
      num = this.size()-size;
    }

    for(int i=num; i<this.size(); i++){
      inv += this.get(i).size();
    }
    
    return inv;
  }

 
 
 
 
 //前期に足らなかった牛乳を補充する
 void restock(Track track){
   noexpiration = true;
   int i = track.super_track.size()-1;
   
   for(int j=0; j<track.super_track.get(i).size(); j++){
     
     if(track.super_track.get(i).get(j).size() == 0)continue;

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにある場合
     e = track.super_track.get(i).get(j).search();
     if(this.size() != 0){
       for(int l=0; l<this.size(); l++){
         if(this.get(l).size() == 0)continue;

         if(e == this.get(l).search()){
           noexpiration = false;
           for(int m=0; m<track.super_track.get(i).get(j).size(); m++){
             this.get(l).add(track.super_track.get(i).get(j).get(m));
           }
         }
       }
     }

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにない場合 or スーパーの倉庫が空の場合
     if(noexpiration == true || this.size() == 0){
       this.add(new Milkstock());
       for(int n=0; n<track.super_track.get(i).get(j).size(); n++){
         this.get(this.size()-1).add(track.super_track.get(i).get(j).get(n));
       }
     }
     
   }
 }
 
 
 
 void shelf_file(){
   try{
     PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super_shelf\\"+"super_"+day+".csv"), true));
     file.println("");

     file.print("[SUPERSTOCK]");
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


     for(int i=0; i<this.size(); i++){
       file.print(i+1);
       file.print(",");
       
       if(this.get(i).size() == 0){
         file.print(" ");
         file.print(",");
         file.print(" ");
       }else{
         file.print(this.get(i).search());
         file.print(",");
         file.print(this.get(i).get(0).production_date);
       }
        
        file.print(",");
        file.print(this.get(i).size());


       //file.print("productiondate: " + this.get(i).get(0).production_date);
       //file.print(",");
       //file.print("volume: " + this.get(i).size());
       //file.print(",");
       //file.print("expiration: " + this.get(i).get(0).expiration);
       //file.print(",");
       //file.print("wastedate: " + this.get(i).get(0).waste_date);
       //file.print(",");
       //file.print("wastevolume:" + maker_waste);

       file.println("");
     }

     file.close();
   }catch (IOException e) {
     println(e);
     e.printStackTrace();
   }

 }
 
}
