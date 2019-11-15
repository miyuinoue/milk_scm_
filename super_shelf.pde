class Supershelf extends ArrayList <Milkstock> {
  int restock;

  IntList s = new IntList();

  int order_quantity = 0;
  float standard_deviation = 0;
  float demand_forecast = 0;
  int safty_stock_super=0;

  int visitors = 0;
  int total_visits = 0;
  int sales_num = 0;
  //int notbuy_num = 0;

  int sales_loss;
  int total_num = 0;
  int shelf_waste;
  int shelf_totalwaste = 0;

  int leadtime = 0;
  int ordercycle = 1;

  int getexp;



  Supershelf() {
  }

  //日付が変わると賞味期限が-1日される
  void shelf_daychange() {
    for (int i=0; i < this.size(); i++) {
      this.get(i).daychange();
      //this.get(i).discount();
    }
    this.visitors = 0;
    this.sales_num = 0;
    sales_loss = 0;
    //notbuy_num = 0;
  }


  void super_first() {
    s.clear();
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
  int order(int istock, int ishelf) {
    int capa = 0;
    int inv_sum = 0;
    int inv_plus = 0;

    //在庫は常に最低でも50個持っている状態にしたい///50でいいの？
    if ((istock + ishelf) >= shelf_capacity) {
      inv_sum = (istock + ishelf) - shelf_capacity;
    } else {
      inv_plus = shelf_capacity - (istock + ishelf);
    }

    order_quantity = (int)ceil((this.leadtime + this.ordercycle) * this.demand_forecast - inv_sum + safty_stock_super);//発注量計算

    if (order_quantity < 0)order_quantity = 0;//発注量<0の時は0

    order_quantity = order_quantity + (inv_plus + sales_loss);//既に在庫が50個以下だったら不足分も追加で発注する, 機会損失分も追加で発注する

    //空き容量との比較
    capa = (shelf_capacity + stock_capacity) - (istock + ishelf);
    if (capa < order_quantity)order_quantity = capa;


    return order_quantity;
  }


  //在庫量
  //5日の在庫は一日の最後に廃棄になるのでカウントしない
  int inventories() {
    int inv = 0;
    int getnum = sales_deadline();

    for (int i=getnum; i<this.size(); i++) {
      inv += this.get(i).size();
    }

    return inv;
  }



  //前期に足らなかった牛乳を補充する
  void restock(SuperTracks supertracks) {
    if (supertracks.size() == 0)return;

    restock = 0;
    noexpiration = true;
    int i = supertracks.size()-1;

    for (int j=0; j<supertracks.get(i).size(); j++) {
      if (supertracks.get(i).get(j).size() == 0)continue;



      //int e = supertracks.get(i).get(j).exp_search();
      //if(e == -1)continue;//エラー

      //納品された牛乳の賞味期限日数と同じ牛乳がstockにある場合
      int e = supertracks.get(i).get(j).exp_search();

      if (this.size() != 0) {
        for (int l=0; l<this.size(); l++) {

          if (e == this.get(l).exp_search()) {
            noexpiration = false;
            for (int m=0; m<supertracks.get(i).get(j).size(); m++) {
              this.get(l).add(supertracks.get(i).get(j).get(m));
              restock++;
            }
          }
        }
      }

      //納品された牛乳の賞味期限日数と同じ牛乳がstockにない場合 or スーパーの倉庫が空の場合
      if (noexpiration == true || this.size() == 0) {
        this.add(new Milkstock());
        for (int n=0; n<supertracks.get(i).get(j).size(); n++) {
          this.get(this.size()-1).add(supertracks.get(i).get(j).get(n));
          restock++;
        }
      }
    }
  }


  //販売
  void sales(int c) {
    this.visitors++;
    int count=0;

    if (this.inventories() == 0) {
      sales_loss++;
      return;
    }

    if (c > (this.inventories()-1)) { 
      buy.get(buy.size()-1).add(new Milk());
      //sales_loss++;
      //notbuy_num++;
      return;
    }

    int getnum = sales_deadline();

    for (int i=getnum; i<this.size(); i++) {
      for (int j=0; j<this.get(i).size(); j++) {
        //countとshelfの配列はどちらも0始まり
        if (count == c) {
          buy.get(buy.size()-1).add(this.get(i).remove(j));
          this.total_num++;
          this.sales_num++;

          return;
        }
        count++;
      }
    }
  }


  //販売期限を過ぎた牛乳を廃棄する
  void waste() {
    shelf_waste = 0;
    for (int i=0; i<this.size(); i++) {
      shelf_waste += this.get(i).waste(sales_deadline);
    }

    shelf_totalwaste += shelf_waste;
  }


  //賞味期限が残り3日になったら3割引きする
  void discount3(int d) {

    for (int i=0; i<this.size(); i++) {
      if (this.get(i).exp_search() != 5 & this.get(i).exp_search() != 6 & (this.get(i).exp_search() != 7)) {
        continue;
      } else {
        for (int j=0; j<this.get(i).size(); j++) {
          this.get(i).get(j).price = d;
        }
      }
    }
  }

  //毎日10円引きする
  void discountalways(int d) {
    for (int i=0; i<this.size(); i++) {
      for (int j=0; j<this.get(i).size(); j++) {
        this.get(i).get(j).price -= d;
      }
    }
  }


  int sales_deadline() {
    for (int i=supershelf.size()-1; i>=0; i--) {
      if (supershelf.get(i).size() == 0)continue;

      if (supershelf.get(i).exp_search() < sales_deadline) {
        getexp = i+1;
        break;
      }
    }

    return getexp;
  }


  void shelf_list() {
    ArrayList<Integer> list = new ArrayList<Integer>();

    //賞味期限ごとの在庫量
    for (int i=14; i>=sales_deadline; i--) {
      boolean sh = false;
      for (int j=0; j<this.size(); j++) {

        if (this.get(j).exp_search() == i) {
          list.add(this.get(j).size());
          sh = true;
        }
      }

      if (sh == false) {
        list.add(0);
      }
    }
    list.add(this.restock);//品出し納品量
    //来客数    
    for (int i=0; i<customer.c.size(); i++) {
      list.add(customer.c.get(i));
    }
    list.add(customer.customertotal);//総来客数


    list.add(this.sales_num);//販売数
    list.add((int)this.demand_forecast);//需要予測
    list.add((int)this.standard_deviation);//標準偏差
    list.add(this.safty_stock_super);//安全在庫
    list.add(this.order_quantity);//発注量
    list.add(this.sales_loss);//機会損失
    list.add(this.restock);//必要補充数量
    list.add(this.shelf_waste);//廃棄量
    list.add(this.shelf_totalwaste);//総廃棄量

    shelf_list.add(list);
  }


  void shelf_newfile() {
    try {
      //PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\file\\scm.csv")));

      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super_shelf\\shelf_"+freshness+"_"+money+".csv")));
      //PrintWriter file = new PrintWriter(new FileWriter(new File("/Users/miyuinoue/Desktop/ondlab/milk_scm_/file/scm1.csv")));//mac
      file.println("");
      file.print(",");

      file.print("[SUPERSHELF]");

      file.println("");

      file.print("日付");
      file.print(",");


      //supershelf
      file.print(",");
      file.print("賞味期限");//14～5日
      for (int i=14; i>(sales_deadline-1); i--) {
        file.print(",");
      }
      file.print("品出し納品量");//1期ごとの在庫量を出力する？
      file.print(",");
      file.print("来客数");
      for (int i=0; i<T; i++) {
        file.print(",");
      } 
      file.print("総来客数");//在庫数をいれるべき？
      file.print(",");
      file.print("販売数");
      file.print(",");
      file.print("需要予測");
      file.print(",");
      file.print("標準偏差");
      file.print(",");
      file.print("安全在庫");
      file.print(",");
      file.print("発注量");
      file.print(",");       
      file.print("機会損失");
      file.print(",");
      file.print("必要補充数量");
      file.print(",");
      //file.print("総販売量");
      //file.print(",");
      file.print("廃棄量");
      file.print(",");
      file.print("総廃棄量");
      file.print(",");

      file.println("");

      file.print(",");
      for (int i=14; i>(sales_deadline-1); i--) {
        file.print(",");
        file.print(i + "日");
      }
      file.print(",");
      file.print(",");
      for (int i=0; i<T; i++) {
        file.print((i+1) + "期"); 
        file.print(",");
      }



      file.println("");
      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }



  void shelf_addfile() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super_shelf\\shelf_"+freshness+"_"+money+".csv"), true));

      file.print(day);
      file.print(",");

      file.print(",");
      for (int i=14; i>(sales_deadline-1); i--) {
        boolean sh = false;
        for (int j=0; j<this.size(); j++) {

          if (this.get(j).exp_search() == i) {
            file.print(this.get(j).size() + "(" + this.get(j).get(0).price + ")");
            //file.print(this.get(j).size());
            file.print(",");
            sh = true;
          }
        }

        if (sh == false) {
          file.print("0");
          file.print(",");
        }
      }

      file.print(this.restock);
      file.print(",");
      for (int i=0; i<customer.c.size(); i++) {
        file.print(customer.c.get(i)); 
        file.print(",");
      }      
      file.print(customer.customertotal);

      file.print(",");
      file.print(this.sales_num);
      file.print(",");
      file.print(this.demand_forecast);
      file.print(",");
      file.print(this.standard_deviation);
      file.print(",");
      file.print(this.safty_stock_super);
      file.print(",");
      file.print(this.order_quantity);
      file.print(",");
      file.print(this.sales_loss);
      file.print(",");
      file.print(restock);
      file.print(",");
      //file.print(this.total_num);
      //file.print(",");
      file.print(this.shelf_waste);
      file.print(",");
      file.print(this.shelf_totalwaste);
      file.print(",");

      file.println("");


      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }
}
