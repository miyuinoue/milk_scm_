class Superstock extends ArrayList <Milkstock> {
  int stock_loss;
  int delivery;
  IntList stock = new IntList();
  int total_num = 0;

  int stock_waste;
  int stock_totalwaste = 0;

  int p;
  int getexp;

  int nn=0;

  Superstock() {
  }

  //日付が変わると賞味期限が-1日される
  void stock_daychange() {
    for (int i=0; i < this.size(); i++) {
      this.get(i).daychange();
      //this.get(i).discount();
    }
    stock.clear();
  }


  //在庫量
  //5日sales_deadlineの在庫は一日の最後に廃棄になるのでカウントしない
  int inventories() {
    int inv = 0;

    for (int i=0; i<this.size(); i++) {

      if (this.get(i).exp_search() < sales_deadline) {
        continue;
      } else {
        inv += this.get(i).size();
      }
    }

    return inv;
  }


  //前日に発注した牛乳が納品される
  void delivery(MakerTracks makertracks) {
    if (makertracks.size() == 0)return;

    delivery = 0;
    noexpiration = true;
    int i = makertracks.size()-1;

    for (int j=0; j<makertracks.get(i).size(); j++) {
      if (makertracks.get(i).get(j).size() == 0)continue;

      int e = makertracks.get(i).get(j).exp_search();

      //納品された牛乳の賞味期限日数と同じ牛乳がstockにある場合
      if (this.size() != 0) {
        for (int k=0; k<this.size(); k++) {
          if (e == this.get(k).exp_search()) {
            noexpiration = false;
            for (int l=0; l<makertracks.get(i).get(j).size(); l++) {
              this.get(k).add(makertracks.get(i).get(j).get(l));
              this.get(k).price(milk_price(this.get(k).exp_search()));/////値段のつけ方！
              delivery++;
            }
          }
        }
      }

      //納品された牛乳の賞味期限日数と同じ牛乳がstockにない場合 or スーパーの倉庫が空の場合
      if (noexpiration == true || this.size() == 0 ) {
        this.add(new Milkstock());
        for (int m=0; m<makertracks.get(i).get(j).size(); m++) {
          this.get(this.size()-1).add(makertracks.get(i).get(j).get(m));
          this.get(this.size()-1).price(milk_price(this.get(this.size()-1).exp_search()));
          delivery++;
        }
      }
    }
  }



  //賞味期限が古い商品から順に品出しstockingする
  //古い順に、納品できるかの判定を行い、牛乳一つずつtrackのboxに入れる
  void stocking(SuperTracks supertracks, int s) {
    int stock_num = 0;
    supertracks.add(new Track(14-sales_deadline+1));

    int carry;
    for (int i=sales_deadline_search(); i<this.size(); i++) {
      carry= min(s, this.get(i).size());
      s-=carry;

      for (int j=0; j<carry; j++) {
        supertracks.addtrack(this.get(i).remove(0));
        stock_num++;
      }
      if (s<=0) break;
    }

    stock_loss = s;
    
    stock.append(stock_num);
    this.total_num += stock_num;
  }


  //販売期限を過ぎた牛乳を廃棄する
  void waste() {
    stock_waste = 0;
    for (int i=0; i<this.size(); i++) {
      stock_waste += this.get(i).waste(sales_deadline);
    }

    stock_totalwaste += stock_waste;
  }


  int milk_price(int r) {

    switch( r ) {
    case 14:
      this.p = 150;
      break;
    case 13:
      this.p = 145;
      break; 
    case 12:
      this.p = 140;
      break;
    case 11:
      this.p = 135;
      break;
    case 10:
      this.p = 130; 
      break;
    case 9:
      this.p = 125;
      break;
    case 8:
      this.p = 120;
      break;
    case 7:
      this.p = 115;
      break;
    case 6:
      this.p = 110;
      break;
    case 5:
      this.p = 105;
      break;
    }

    return this.p;
  }


  //賞味期限が残り3日になったら3割引きする
  void discount3(int d) {
    //int d = 3;//残り日数
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


  void stock_list() {
    ArrayList<Integer> list = new ArrayList<Integer>();

    list.add(day);//日にち
    //賞味期限ごとの在庫量
    for (int i=14; i>(sales_deadline-1); i--) {
      boolean st = false;
      for (int j=0; j<this.size(); j++) {

        if (this.get(j).exp_search() == i) {
          list.add(this.get(j).size());
          st = true;
        }
      }

      if (st == false) {
        list.add(0);
      }
    }
    list.add(this.delivery);//納品量
    //品出し出荷量
    if (this.stock.size()==0) {
      for (int i=0; i<3; i++)list.add(0);
    }
    for (int i=0; i<this.stock.size(); i++) {
      list.add(this.stock.get(i));
    }
    list.add(this.stock_loss);//機会損失
    list.add(this.stock_waste);//廃棄量
    list.add(this.stock_totalwaste);//総廃棄量


    stock_list.add(list);
  }

  int sales_deadline_search() {
    for (int i=this.size()-1; i>=0; i--) {
      if (this.get(i).size() == 0)continue;

      if (this.get(i).exp_search() < sales_deadline) {
        this.getexp = i+1;
        break;
      }
    }

    return this.getexp;
  }



  void stock_newfile() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("/Users/inouemiyu/Desktop/milk_scm/super1/stock_"+freshness+"_"+money+".csv")));
      file.println("");
      file.print(",");

      file.print("[SUPERSTOCK]");


      file.println("");

      file.print("日付");
      file.print(",");

      //superstock
      file.print(",");
      file.print("賞味期限");//14～
      for (int i=14; i>(sales_deadline-1); i--) {
        file.print(",");
      }
      file.print("納品量");
      file.print(",");
      file.print("品出し出荷量");
      for (int i=0; i<T; i++) {
        file.print(",");
      } 
      file.print("機会損失");
      file.print(",");
      //file.print("総品出し量");
      //file.print(",");
      file.print("廃棄量");
      file.print(",");
      file.print("総廃棄量");
      file.print(",");


      file.println("");

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
      file.print(",");
      file.print(",");
      file.print(",");



      file.println("");
      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }



  void stock_addfile() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("/Users/inouemiyu/Desktop/milk_scm/super1/stock_"+freshness+"_"+money+".csv"), true));

      file.print(day);
      file.print(",");

      file.print(",");

      for (int i=14; i>(sales_deadline-1); i--) {
        boolean st = false;
        for (int j=0; j<this.size(); j++) {

          if (this.get(j).exp_search() == i) {
            file.print(this.get(j).size() + "(" + this.get(j).get(0).price + ")");
            //file.print(this.get(j).size());
            file.print(",");
            st = true;
          }
        }

        if (st == false) {
          file.print("0");
          file.print(",");
        }
      }

      file.print(this.delivery);
      file.print(",");
      if (this.stock.size()==0) {
        for (int i=0; i<3; i++) {
          file.print("0");
          file.print(",");
        }
      }
      for (int i=0; i<this.stock.size(); i++) {
        file.print(this.stock.get(i));
        file.print(",");
      }
      file.print(this.stock_loss);
      file.print(",");
      //file.print(this.total_num);
      //file.print(",");
      file.print(this.stock_waste);
      file.print(",");
      file.print(this.stock_totalwaste);
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
