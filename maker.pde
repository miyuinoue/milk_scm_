class Maker extends ArrayList <Milkstock> {
  int order_num = 0;
  int delivery_num = 0;
  int total_num =0;
  int maker_loss;
  int maker_waste;
  int maker_totalwaste = 0;

  IntList m = new IntList();

  float standard_deviation = 0;
  float demand_forecast = 0;
  int safty_stock_maker = 0;

  int production_volume = 0;
  int maker_max = 100;//一日に生産できる数量
  int capa = 0;

  int shipment_size = 0;

  int leadtime = 1;
  int ordercycle = 1;
  float safety_factor = 1.65;

  int getexp;


  Maker() {
  }

  //日付が変わると賞味期限が-1日される
  void m_daychange() {
    for (int i=0; i < this.size(); i++) {
      this.get(i).daychange();
    }
  }

  void maker_first() {
    m.clear();
    for (int i=0; i<7; i++) {
      m.append(100);
    }
  }

  void maker_appdate() {
    m.remove(0);
    m.append(order_num);
  }


  void demand_forecast() {
    float sum = 0;
    for (int i=0; i<7; i++) {
      sum += m.get(i);
    }
    this.demand_forecast = sum/7;
  }


  void standard_deviation() {
    float var = 0;
    for (int i=0; i<7; i++) {
      var += (m.get(i) - this.demand_forecast)*(m.get(i) - this.demand_forecast);
    }
    this.standard_deviation = (float)Math.sqrt(var/(7-1));
  }


  void safty_stock() {

    safty_stock_maker = (int)Math.ceil(this.safety_factor * this.standard_deviation * Math.sqrt(this.leadtime + this.ordercycle));
  }



  //生産量q
  int produce() {
    int inventories = inventories();
    production_volume = (int)Math.ceil((this.leadtime + this.ordercycle)*this.demand_forecast - inventories + safty_stock_maker);

    if (production_volume < 0)production_volume = 0;

    production_volume += maker_loss;//機会損失分も追加で生産する

    //capa = maker_capacity - inventories;//倉庫の空き容量  
    //if(capa < production_volume)production_volume = capa;



    return production_volume;
  }


  //在庫量
  //10日の在庫は一日の最後に廃棄になるのでカウントしない
  int inventories() {
    int inv = 0;

    for (int i=0; i<this.size(); i++) {

      if (this.get(i).exp_search() <= delivery_deadline) {
        continue;
      } else {
        inv += this.get(i).size();
      }
    }
    return inv;
  }



  //前日に生産した牛乳が倉庫に入る
  void newstock(int m) {
    this.add(new Milkstock());
    this.get(this.size()-1).makemilk(m);
  }


  //賞味期限が古い商品から順に出荷shipmentする
  void shipment(MakerTracks makertracks, int o) {   
    order_num = o;
    this.shipment_size = 0;
    maker_loss = 0;
    makertracks.add(new Track((14-delivery_deadline+1)));//Track(5)


    int carry;
    for (int i=stock_search(); i<this.size(); i++) {
      carry= min(o, this.get(i).size());
      o -= carry;

      for (int j=0; j<carry; j++) {
        makertracks.addtrack(this.get(i).remove(0));
        this.shipment_size++;
      }
      if (o<=0) break;
    }

    maker_loss = o;
  
    this.total_num += this.shipment_size;
  }


  //納品期限を過ぎた牛乳を廃棄する
  void waste() {
    maker_waste = 0;
    for (int i=0; i<this.size(); i++) {
      maker_waste += this.get(i).waste(delivery_deadline);
    }

    maker_totalwaste += maker_waste;
  }

  int stock_search() {
    for (int i=this.size()-1; i>=0; i--) {
      if (this.get(i).size() == 0)continue;

      if (this.get(i).exp_search() < delivery_deadline) {
        this.getexp = i+1;
        break;
      }
    }

    return this.getexp;
  }



  void maker_list() {
    ArrayList<Integer> list = new ArrayList<Integer>();

    list.add(day);//日にち
    //賞味期限14日～10日ごとの在庫量
    for (int i=14; i>=delivery_deadline; i--) {
      boolean m = false;
      for (int j=0; j<this.size(); j++) {

        if (this.get(j).exp_search() == i) {
          list.add(this.get(j).size());
          m = true;
        }
      }
      if (m == false) {
        list.add(0);
      }
    }
    list.add(this.order_num);//受注数量
    list.add((int)this.demand_forecast);//需要予測
    list.add((int)this.standard_deviation);//標準偏差
    list.add(this.safty_stock_maker);//安全在庫
    list.add(this.capa);//空き容量
    list.add(this.production_volume);//生産量
    list.add(this.shipment_size);//出荷量
    list.add(this.maker_loss);//機会損失
    list.add(this.maker_waste);//廃棄量
    list.add(this.maker_totalwaste);//総廃棄量

    maker_list.add(list);
  }


  void addfile() {
    try {
      //PrintWriter file = new PrintWriter(new FileWriter(new File("/Users/miyuinoue/Desktop/milk_scm/scm_" + month() + "_" + day() +"/maker/maker_"+freshness+"_"+money+".csv"),true));
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\milk_scm\\scm_"+ month() + "_" + day() +"\\maker\\maker_"+freshness+"_"+money+".csv"),true));

      file.println("");

      file.print("day");
      file.print(",");

      //maker
      file.print("syoumikigenn");//14～10日//期末在庫なので次の日に処理が行われる
      for (int i=14; i>(delivery_deadline-1); i--) {
        file.print(",");
      }
      file.print("zyutyuu");
      file.print(",");
      file.print("zyuyouyosoku");
      file.print(",");
      file.print("hyouzyunnhennsa");
      file.print(",");
      file.print("annzennzaiko");
      file.print(",");
      file.print("akiyouryou");
      file.print(",");
      file.print("seisann-ryo");
      file.print(",");
      file.print("syuxtuka-ryo");
      file.print(",");
      file.print("kikaisonnsitsu");
      file.print(",");
      //file.print("総出荷量");
      //file.print(",");
      file.print("haiki-ryo");
      file.print(",");
      file.print("total-haiki-ryo");
      file.print(",");
      file.println("");

      for (int i=14; i>(delivery_deadline-1); i--) {
        file.print(",");
        file.print(i + "niti");
      }
      file.println("");



      for (int i=0; i<maker_list.size(); i++) {
        for (int j=0; j<maker_list.get(i).size(); j++) {
          file.print(maker_list.get(i).get(j));
          file.print(",");
        }
        file.println("");
      }

      file.println("");

      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }
}
