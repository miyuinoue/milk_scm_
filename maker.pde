class Maker extends ArrayList <Milkstock>{
  int production_volume = 200;
  int maker_loss;
  int maker_waste;

  IntList m = new IntList();

  double standard_deviation = 10;
  int demand_forecast = 200;
  int average_ini = 270;
  int shipment_size = 0;
  int safty_stock_maker = 0;

  int leadtime = 1;
  int ordercycle = 1;
  

  Maker(){
    //production_volume = 0;
  }

  //日付が変わると賞味期限が-1日される
  void m_daychange(){
    for(int i=0; i < this.size(); i++){
      this.get(i).daychange();
    }
  }

  void maker_first() {
    for (int i=0; i<7; i++) {
      m.append(150);
    }
  }

  void maker_appdate() {
    m.remove(0);
    m.append(this.shipment_size);
    shipment_size = 0;
  }

  void demand_forecast(){
    int sum = 0;
    for(int i=0; i<7;i++){
      sum += m.get(i);
    }
    this.demand_forecast = sum/7;
  }

  void standard_deviation(){
    int var = 0;
    for(int i=0; i<7; i++){
      var += (m.get(i) - demand_forecast)*(m.get(i) - demand_forecast);
    }
    standard_deviation = Math.sqrt(var/(7-1));
  }

  void safty_stock() {
    safty_stock_maker=(int)(1.65*standard_deviation);
  }


  //生産量q
  int produce(int i){
    production_volume = (leadtime + ordercycle)*demand_forecast - 1 - i + safty_stock_maker;
    
    return production_volume;
  }
  
  //在庫量
  int inventories(){
    int inv = 0;
    int size = (E - delivery_deadline + 1); //5
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


  //前日に生産した牛乳が倉庫に入る
  void newstock(int d){
        //println(d + ":");
    this.add(new Milkstock());
    this.get(this.size()-1).makemilk(d);
  }


  //賞味期限が古い商品から順に出荷shipmentする
  //古い順に、納品できるかの判定を行い、牛乳一つずつtrackのboxに入れる
  void shipment(Track track , int d){

    //track.maker_newtrack();
    //賞味期限が10日～14日までの在庫のみ
    int size = (E - delivery_deadline + 1); //5
    //int d = demand;
    int num;

    if(this.size() < size){
      num = 0;
    }else{
      num = this.size()-size;
    }

    track.maker_track.add(new Track(5));
    outside: while(d > 0){

      if(this.get(num).size() == 0){
        
        if(num == this.size()-1){
          maker_loss += d;
          break outside;
        }
        
        num++;
      }
      
      while(this.get(num).size() > 0){
        track.maker_track.get(track.maker_track.size()-1).maker_addtrack(this.get(num).remove(0));
        d--;

        if(d == 0)break;

        //if(this.get(num).size() == 0){
        //  num++;

        //  break;
        //}     
      }
      //if(num == this.size()-1)break;
    }

    for(int i=0; i<track.maker_track.get(track.maker_track.size()-1).size(); i++){
      //println(track.maker_track.get(track.maker_track.size()-1).get(i).size() +"#");
      shipment_size += track.maker_track.get(track.maker_track.size()-1).get(i).size();
      
    }
    //println(shipment_size);
    //println(milk_num);
  }

  //納品期限を過ぎた牛乳を廃棄する
  void m_waste(){
    maker_waste = 0;
    for(int i=0; i<this.size(); i++){
      maker_waste += this.get(i).waste(delivery_deadline);
    }

  }



  void maker_file(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\maker\\"+"maker"+day+".csv"), true));
      file.println("");

      file.print("[MAKER]");
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





  ////賞味期限が古い商品から順に出荷shipmentする
  //void start_shipment(int o){
  //  println("　super注文数：" + o);
  //  if(o > maker_totalinv){
  //    demand_quantity = maker_totalinv;
  //    println("　　機会ロス：" + (o - maker_totalinv));
  //  }else{
  //    demand_quantity = o;
  //  }

   // //賞味期限r日だけで出荷分がまかなえるかどうかの判定
   // //賞味期限日別で出荷のArrayListに入れる
   // int num = 0;
   // while(demand_quantity > 0){
   //   ArrayList<Milk> shipment = new ArrayList<Milk>();
   //
   //   while(inventories.get(num).size() > 0){
   //     shipment.add(inventories.get(num).get(0));
   //     inventories.get(num).remove(0);
   //     demand_quantity--;
   //
   //     if(demand_quantity == 0 || inventories.get(num).size() == 0){
   //       total_shipment.add(shipment);
   //       if(inventories.get(num).size() == 0){
   //         inventories.remove(num);
   //         num--;
   //       }
   //       break;
   //     }
   //   }
   //   num++;
   // }

  //  syuxtuka_num = 0;
  //  for(int i=0; total_shipment.size() > i; i++){
  //    syuxtuka_num += total_shipment.get(i).size();
  //  }
  //  print("  maker出荷数：" + syuxtuka_num + "       ");
  //  for(int i=0; total_shipment.size() > i; i++){
  //    print(total_shipment.get(i).size() + "  ");
  //  }
  //  println(" ");
  //  for(int i=0; inventories.size() > i; i++){
  //    println("　　" + inventories.get(i).get(0).expiration + "日：" + inventories.get(i).size());
  //  }
  //  //println("totalinv" + maker_totalinv);
  //}

  ////出荷を終えたArrayListを空にする
  //void end_shipment(){
  //  total_shipment.clear();
  //}


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


  ////前日の発注量までを使って生産数を決定する
  //int production(int d){
  //  demand = d;
  //  p = demand;
  //  return p;
  //}






  //void standard_deviation(){
  //  int var = 0;
  //  for(int i=0; i<7; i++){
  //    var+ = inventories.
  //}
