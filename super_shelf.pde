class Supershelf extends ArrayList <Milkstock>{
  int restock;
  
  IntList s = new IntList();
  
  int order_quantity = 0;
  float standard_deviation = 0;
  float demand_forecast = 0;
  int safty_stock_super=0; 
  
  int visitors = 0;
  int total_visits = 0;
  int sales_num = 0;
  
  int sales_loss; 
  int total_num = 0;
  int shelf_waste;
  
  int leadtime = 0;
  int ordercycle = 1;
  
  

 Supershelf(){

 }
 
   //日付が変わると賞味期限が-1日される
  void shelf_daychange(){
    for(int i=0; i < this.size(); i++){
      this.get(i).daychange();
    }
    this.visitors = 0;
    this.sales_num = 0;
    sales_loss = 0;

}
  
  
  void super_first() {
    for (int i=0; i<7; i++) {
      s.append(100);
    }
  }


  void super_appdate() {
    s.remove(0);  
    s.append(this.sales_num);
  }


  void demand_forecast() {
    float sum = 0;
    for (int i=0; i<7; i++) {
      sum += s.get(i);
    }
    this.demand_forecast = sum/7;
  }


  void standard_deviation() {
    float var=0;
    for (int i=0; i<7; i++) {
      var+=(s.get(i) - this.demand_forecast)*(s.get(i) - this.demand_forecast);
    }
    this.standard_deviation = (float)Math.sqrt(var/(7-1));
  }


  void safty_stock() {
    safty_stock_super = (int)Math.ceil(1.65 * this.standard_deviation * Math.sqrt(this.leadtime +this.ordercycle));
  }
  
  
  //発注量o
    //int order(int istock, int ishelf){
  int order(int istock){
    int capa = 0;
    order_quantity = (int)ceil((this.leadtime + this.ordercycle) * this.demand_forecast - (istock) + safty_stock_super);
    //order_quantity = (int)ceil((this.leadtime + this.ordercycle) * this.demand_forecast - (istock + ishelf) + safty_stock_super);
    

    if(order_quantity < 0)order_quantity = 0;
  
    //capa = (shelf_capacity + stock_capacity) - (istock + ishelf);
    capa = stock_capacity - istock;    
    if(capa < order_quantity)order_quantity = capa;

    return order_quantity;
  }
 
  
  //在庫量
  //5日の在庫は一日の最後に廃棄になるのでカウントしない
  int inventories(){
    int inv = 0;

    for(int i=0; i<this.size() ;i++){

      if(this.get(i).exp_search() <= 5){
        continue;
      }else{
        inv += this.get(i).size();
      }
    }

    return inv;
  }

 
 
 //前期に足らなかった牛乳を補充する
 void restock(SuperTracks supertracks){
   if(supertracks.size() == 0)return;
   
   restock = 0;
   noexpiration = true;
   int i = supertracks.size()-1;
   
   for(int j=0; j<supertracks.get(i).size(); j++){
     if(supertracks.get(i).get(j).size() == 0)continue;     

     
     
     //int e = supertracks.get(i).get(j).exp_search();
     //if(e == -1)continue;//エラー

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにある場合
     int e = supertracks.get(i).get(j).exp_search();

     if(this.size() != 0){
       for(int l=0; l<this.size(); l++){

         if(e == this.get(l).exp_search()){
           noexpiration = false;
           for(int m=0; m<supertracks.get(i).get(j).size(); m++){
             this.get(l).add(supertracks.get(i).get(j).get(m));
             restock++;
           }
         }
       }
     }

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにない場合 or スーパーの倉庫が空の場合
     if(noexpiration == true || this.size() == 0){
       this.add(new Milkstock());
       for(int n=0; n<supertracks.get(i).get(j).size(); n++){
         this.get(this.size()-1).add(supertracks.get(i).get(j).get(n));
         restock++;
       }
     }
     
   }
 }   
 
 
 //販売
 void sales(int c){
   this.visitors++;
   
   boolean sales = false; 
   //int loss = 0;
   int count=0;
    
   if(this.size() == 0 || c == -1){
      sales_loss++;
      return;
   }
   
   for(int i=0; i<this.size() ;i++){
      
     if(this.get(i).exp_search() < 5){
       continue;
     }else{
       for(int j=0; j<this.get(i).size(); j++){         
         if(count==c){
           customer_buy.get(customer_buy.size()-1).add(this.get(i).remove(j));
           this.total_num++;
           this.sales_num++;
           sales = true;
           return;
         }      
         count++;
           
       }
     }
   }

  
   if(sales == false)sales_loss++;

 }
 
  //販売期限を過ぎた牛乳を廃棄する
  void waste(){
    shelf_waste = 0;
    for(int i=0; i<this.size(); i++){
      shelf_waste += this.get(i).waste(sales_deadline);
    }

  }
  
  
  //賞味期限が残り3日になったら3割引きする
  void discount(int d){
    //int d = 3;//残り日数
    for(int i=0; i<this.size() ;i++){
      if(this.get(i).exp_search() != 5 & this.get(i).exp_search() != 6 & (this.get(i).exp_search() != 7)){  
        continue;
      }else{
        for(int j=0; j<this.get(i).size(); j++){
          this.get(i).get(j).price = d;
          //println(this.get(i).get(j).price);
        }
      }
    }   
  }
 
 
 
 void shelf_file(){
   try{
     PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super_shelf\\"+"shelf_"+day+".csv")));
     file.println("");

     file.print("[SUPERSTOCK]");
     file.println("");

     file.print("date: " + day);
     file.println("");
     file.print("shinadashi: " + restock);
     file.println("");
     file.print("visitors: " + this.visitors);
     file.println("");
     file.print("loss: " + sales_loss);
     file.println("");
     file.print("total: " + this.total_num);
     file.println("");
     file.print("order: " + order_quantity);
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
         file.print(this.get(i).exp_search());
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
