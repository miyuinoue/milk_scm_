class Maker extends ArrayList <Milkstock>{
  int order_num = 0;
  int delivery_num = 0;
  int total_num =0;
  int maker_loss;
  int maker_waste;

  IntList m = new IntList();

  float standard_deviation = 0;
  float demand_forecast = 0;
  int safty_stock_maker = 0;

  int production_volume = 0;
  int maker_max = 100;//一日に生産できる数量

  int shipment_size = 0;

  int leadtime = 1;
  int ordercycle = 1;
  float safety_factor = 1.65;


  Maker(){

  }

  //日付が変わると賞味期限が-1日される
  void m_daychange(){
    for(int i=0; i < this.size(); i++){
      this.get(i).daychange();
    }
  }

  void maker_first() {
    for (int i=0; i<7; i++) {
      m.append(100);
    }
  }

  void maker_appdate() {
    m.remove(0);
    m.append(order_num);
  }


  void demand_forecast(){
    float sum = 0;
    for(int i=0; i<7;i++){
      sum += m.get(i);
    }
    this.demand_forecast = sum/7;
  }


  void standard_deviation(){
    float var = 0;
    for(int i=0; i<7; i++){
      var += (m.get(i) - this.demand_forecast)*(m.get(i) - this.demand_forecast);
    }
    this.standard_deviation = (float)Math.sqrt(var/(7-1));

  }


  void safty_stock() {
    
    safty_stock_maker = (int)Math.ceil(this.safety_factor * this.standard_deviation * Math.sqrt(this.leadtime + this.ordercycle));

}
  


  //生産量q
  int produce(){
    int capa = 0;
    int inventories = inventories();
    production_volume = (int)Math.ceil((this.leadtime + this.ordercycle)*this.demand_forecast - inventories + safty_stock_maker);

    if(production_volume < 0)production_volume = 0;
    
    capa = maker_capacity - inventories;//倉庫の空き容量
    if(production_volume > maker_max){
      production_volume = maker_max;//最大で100個しか作れない
      
      if(capa < production_volume)production_volume = capa;
    }
    

    return production_volume;
  }


  //在庫量
  //10日の在庫は一日の最後に廃棄になるのでカウントしない
  int inventories(){
    int inv = 0;

    for(int i=0; i<this.size() ;i++){
      
      if(this.get(i).exp_search() <= 10){
        continue;
      }else{
        inv += this.get(i).size();
      }
    }
    return inv;
  }



  //前日に生産した牛乳が倉庫に入る
  void newstock(int m){
    this.add(new Milkstock());
    this.get(this.size()-1).makemilk(m);
  }
  
  
  //賞味期限が古い商品から順に出荷shipmentする
  void shipment(MakerTracks makertracks , int o){   
    order_num = o;
    this.shipment_size = 0;
    maker_loss = 0;

    if(this.size() == 0){
      maker_loss = o;
      return;
    }

    //賞味期限が10日～14日までの在庫のみ
    makertracks.add(new Track(5));

    for(int i=0; i<this.size() ;i++){

      if(this.get(i).exp_search() < 10){
        continue;
      }else{
        int num = i;
        outside: while(o > 0){

          if(this.get(num).size() == 0){
            if(num == this.size()-1){
              maker_loss = o;
              break outside;
            }
            num++;
          }

          while(this.get(num).size() > 0){
            makertracks.addtrack(this.get(num).remove(0));
            this.shipment_size++;
            o--;
            //delivery_num++;

            if(o == 0)break outside;

          }
        }
        break;
      }
    }    
    this.total_num += delivery_num;
  }


  //納品期限を過ぎた牛乳を廃棄する
  void waste(){
    maker_waste = 0;
    for(int i=0; i<this.size(); i++){
      maker_waste += this.get(i).waste(delivery_deadline);
    }

  }



  void maker_file(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\maker\\"+"maker"+day+".csv")));
      file.println("");

      file.print("[MAKER]");
      file.println("");

      file.print("date: " + day);
      file.println("");
      file.print("produce: " + production_volume);
      file.println("");
      file.print("order: " + order_num);
      file.println("");
      file.print("delivery: " + delivery_num);
      file.println("");
      file.print("loss:" + maker_loss);
      file.println("");
      file.print("total:" + this.total_num);
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
       
      //for(int i=0; i<this.size(); i++){
      //  file.print(i+1);
      //  file.print(",");

      //  file.print("productiondate: " + this.get(i).get(0).production_date);
      //  file.print(",");
      //  file.print("volume: " + this.get(i).size());
      //  file.print(",");
      //  file.print("expiration: " + this.get(i).get(0).expiration);
      //  file.print(",");
      //  file.print("wastedate: " + this.get(i).get(0).waste_date);
      //  file.print(",");
      //  file.print("wastevolume:" + maker_waste);

        file.println("");
      }

      file.close();
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }

  }
}




  ////残りの賞味期限日数が納品期限を過ぎた牛乳を廃棄する
  //void maker_waste(){
  //  maker_wastecount = 0;
  //  for(int i = 0; i < inventories.size(); i++){
  //    for(int j = 0; j < inventories.get(i).size(); j++){
  //      if(inventories.get(i).get(0).expiration == 10){
  //        maker_wastecount += inventories.get(i).size();
  //        inventories.remove(i);
  //      }
  //    }
  //  }
  //  maker_totalhaiki += maker_wastecount;
  //  println("　maker廃棄数：" + maker_wastecount);
  //  println("　maker総廃棄数：" + maker_totalhaiki);
  //}
