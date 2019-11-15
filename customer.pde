class Customer {
  int customertotal = 0;
  IntList c = new IntList(); 

  float iexp = 0;
  double jexp;
  int getexp; 
  double vsum;
  double probability = 0;
  int notbuy;
  int fresh_max;
  int fresh_min;
  int money_max;
  int money_min;

  float A = 30;  //振幅
  float w = 12;  //角周波数（周期）

  //float freshness = 0.661;//①
  //float money = -0.123;//①

  //float freshness = 50.0;//②
  //float money = 50.0;//②


  ArrayList<Double> prob = new ArrayList<Double>();
  ArrayList<Double> u = new ArrayList<Double>();


  IntList fresh_list = new IntList();
  IntList money_list = new IntList();
  ArrayList<Double> f = new ArrayList<Double>();//fresh
  ArrayList<Double> p = new ArrayList<Double>();//price  

  ArrayList<Integer> select_fre = new ArrayList<Integer>();
  ArrayList<Integer> select_pri = new ArrayList<Integer>();

  Customer() {
  }


  void c_daychange() {
    buy.add(new Milkstock());
    c.clear();     
    customertotal = 0;

    for (int i=0; i<14; i++) {
      select_fre.set(i, 0);
      select_pri.set(i, 0);
    }
    this.notbuy = 0;
  }


  void fresh_price() {
    //4～14日の賞味期限を正規化するためにfresh_listに格納
    for (int i=E; i>=(sales_deadline-1); i--) {
      fresh_list.append(i);
    }

    //100円から200円までの価格を正規化するためにmoney_listに格納
    for (int i=100; i<=200; i++) {
      money_list.append(i);
    }

    fresh_max = fresh_list.max();
    fresh_min = fresh_list.min();
    money_max = money_list.max();
    money_min = money_list.min();
  }


  void customer_first() {
    for (int i=0; i<14; i++) {
      select_fre.add(0);
      select_pri.add(0);
    }
  }

  int random_customer(int d) {
    float ave = 20 + A * sin(w * radians(d));
    float random = ave + randomGaussian() * 10;//平均が循環変動ave・分散10の正規乱数

    if (random >= 0)c.append((int)random);
    else c.append(0);
    customertotal += c.get(c.size()-1);

    return c.get(c.size()-1);
  }

  //int random_customer(){
  //  int cnum = 0;

  //  if(r == 0){
  //    double random = Math.random();

  //    if(0.01 < random && random < 0.99){
  //      cnum = customer_1();

  //    }else if(random < 0.99){
  //      cnum = customer_2();
  //      r++;

  //    }else if(0.01 < random){
  //      cnum = customer_3();
  //      r--;
  //    } 
  //  }else if(r > 0){
  //    cnum = customer_2();
  //    r++;

  //    if(r == 21)r = 0;

  //  }else if(r < 0){
  //    cnum = customer_3();
  //    r--;

  //    if(r == -21)r = 0;
  //  }

  //  return cnum;
  //}

  ////正規乱数平均20人
  ////一日のt期ごとの来客数をcに格納
  //int customer_1(){

  //  //t期の客数の決定
  //  int randomnum = (int)(20 + randomGaussian() * 5);
  //  if(randomnum >= 0)c.append(randomnum);
  //  else c.append(0);

  //  customertotal += c.get(c.size()-1);

  //  return c.get(c.size()-1);
  //}

  ////正規乱数平均50人
  //int customer_2(){

  //  int randomnum = (int)(60 + randomGaussian() * 5);
  //  if(randomnum >= 0)c.append(randomnum);
  //  else c.append(0);

  //  customertotal += c.get(c.size()-1);

  //  return c.get(c.size()-1);
  //}

  ////正規乱数平均5人
  //int customer_3(){

  //  int randomnum = (int)(5 + randomGaussian() * 2);
  //  if(randomnum >= 0)c.append(randomnum);
  //  else c.append(0);

  //  customertotal += c.get(c.size()-1);

  //  return c.get(c.size()-1);
  //}


  //count番目の牛乳を購入する
  int buy() {     
    double random_num = sum() * Math.random();
    double prob_sum = 0;
    int count = 0 ;


    //count番目の牛乳を購入する 
    for (int i=0; i<prob.size(); i++) {
      prob_sum += prob.get(i);
      if (prob_sum >= random_num) {
        count = i;
        break;
      }
    }

    return count;
  }


  ////選択確率P①
  //void probability(Supershelf supershelf){
  //  prob.clear();

  //  if(supershelf.size() == 0)return;

  //  for(int i=0; i<supershelf.size() ;i++){
  //    if(supershelf.get(i).size() == 0)continue;

  //    if(supershelf.get(i).exp_search() < sales_deadline){
  //      continue;
  //    }else{

  //      for(int j=0; j<supershelf.get(i).size(); j++){
  //        jexp = (float)(Math.exp(utility(supershelf.get(i).get(j).expiration, supershelf.get(i).get(j).price)) / sum(supershelf));
  //        prob.add(jexp);
  //      }
  //    }
  //  }

  //  prob.add(notbuy()/sum(supershelf));//買わない効用を付け足す
  //}


  ////選択確率sum①
  //float sum(Supershelf supershelf){
  //  vsum = 0;

  //  if(supershelf.size() == 0)return vsum;

  //  for(int i=0; i<supershelf.size() ;i++){
  //    if(supershelf.get(i).size() == 0)continue;

  //    if(supershelf.get(i).exp_search() < sales_deadline){
  //      continue;
  //    }else{
  //      for(int j=0; j<supershelf.get(i).size(); j++){
  //        vsum += Math.exp(utility(supershelf.get(i).get(j).expiration, supershelf.get(i).get(j).price));
  //      }
  //    }
  //  }

  //  vsum += notbuy();//買わない効用を付け足す

  //  return vsum;
  //}



  //選択確率P②
  void probability() {
    prob.clear();
    u.clear();

    for (int i=0; i<f.size(); i++) {
      jexp = Math.exp(utility(f.get(i), p.get(i)));  

      prob.add(jexp);
      u.add(utility(f.get(i), p.get(i)));
    }    

    prob.add(Math.exp(notbuy()));//買わない効用を付け足す
  }


  //選択確率sum②
  double sum() {
    vsum = 0;

    for (int i=0; i<f.size(); i++) {
      vsum += Math.exp(utility(f.get(i), p.get(i)));
    }
    vsum += Math.exp(notbuy());//買わない効用を付け足す

    return vsum;
  }



  //効用U
  double utility(double f, double m) {
    return (freshness * f + money * m);
  }


  //  //買わない選択肢のVの割合①
  //  float notbuy(){
  //    //0.661,-0.123の時で最も効用vが大きかったもの（7日105円）-8.288
  //    return (float)Math.exp(-13.162001);//16.023（定数項）    -13.162001（小さい）
  //  }


  //買わない選択肢のVの割合②
  float notbuy() {
    return 30 + 30;//この時，効用が合計で100くらいで買わないが考慮されなくなる
  }


  //freshとmoneyの正規化
  void normalization(Supershelf supershelf) { 
    f.clear();
    p.clear();

    if (supershelf.size() == 0)return;

    int getnum = supershelf.sales_deadline();

    for (int i=getnum; i<supershelf.size(); i++) {
      for (int j=0; j<supershelf.get(i).size(); j++) {
        double x = (supershelf.get(i).get(j).expiration - fresh_min)/(double)(fresh_max - fresh_min);  
        double y = 1.0 - (supershelf.get(i).get(j).price - money_min)/(double)(money_max - money_min);

        f.add(x);
        p.add(y);
      }
    }
  }


  //void utility_list() {
  //  for (int i=0; i<fresh_list.size(); i++) {
  //    ArrayList<Double> list = new ArrayList<Double>();
  //    for (int j=0; j<money_list.size(); j++) {
  //      println(i+"+"+j);
  //      list.add(utility(fresh_list.get(i), money_list.get(j)));
  //    }
  //    utility_list.add(list);
  //  }
  //}



  void select_milk() {
    if (buy.size() == 0)return;

    for (int i=0; i<buy.get(buy.size()-1).size(); i++) {  
      if (1 <= buy.get(buy.size()-1).get(i).expiration && buy.get(buy.size()-1).get(i).expiration <=14) {

        int num = 14 - buy.get(buy.size()-1).get(i).expiration;
        select_fre.set(num, select_fre.get(num)+1);
        
      } else if (buy.get(buy.size()-1).get(i).expiration == 0) {

        this.notbuy++;
      }
    }
  }


  void select_price() {
    if (buy.size() == 0)return;

    for (int i=0; i<buy.get(buy.size()-1).size(); i++) {
      //if ((150-buy.get(buy.size()-1).get(i).price)/5 

        switch(buy.get(buy.size()-1).get(i).price) {
      case 150:
        select_pri.set(0, select_pri.get(0)+1);
        break;

      case 145:
        select_pri.set(1, select_pri.get(1)+1);
        break;

      case 140:
        select_pri.set(2, select_pri.get(2)+1);
        break;

      case 135:
        select_pri.set(3, select_pri.get(3)+1);
        break;

      case 130:
        select_pri.set(4, select_pri.get(4)+1);
        break;

      case 125:
        select_pri.set(5, select_pri.get(5)+1);
        break;

      case 120:
        select_pri.set(6, select_pri.get(6)+1);
        break;

      case 115:
        select_pri.set(7, select_pri.get(7)+1);
        break;

      case 110:
        select_pri.set(8, select_pri.get(8)+1);
        break;

      case 105:
        select_pri.set(9, select_pri.get(9)+1);
        break;

      case 100:
        select_pri.set(10, select_pri.get(10)+1);
        break;

      case 3:
        select_pri.set(11, select_pri.get(11)+1);
        break;

      case 2:
        select_pri.set(12, select_pri.get(12)+1);
        break;

      case 1:
        select_pri.set(13, select_pri.get(13)+1);
        break;
      }
    }
  }


  //選択回数のリスト
  void customer_list() {
    ArrayList<Integer> list = new ArrayList<Integer>();

    list.add(day);//日にち
    list.add(this.customertotal);//来店数
    //選択回数
    list.add(this.notbuy);//買わない
    for (int i=0; i<(14-sales_deadline+1); i++) {
      list.add(this.select_fre.get(i));
    }

    for (int i=0; i<(14-sales_deadline+1); i++) {
      list.add(this.select_pri.get(i));
    }

    customer_list.add(list);
  }


  void prob_newfile() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\prob_fresh"+freshness+"_price"+money+".csv")));
      file.println("");

      file.print("[PLOB]");
      file.println("");

      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }


  void prob_file(Supershelf supershelf) {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\prob_fresh"+freshness+"_price"+money+".csv"), true));
      file.println("");


      file.print("date: " + day);
      file.println("");
      file.print("inv:"+(supershelf.inventories()+1));//1個販売した後なので1少ない
      file.println("");
      file.print("probsize:"+prob.size());
      file.println("");

      for (int i=0; i<prob.size(); i++) {
        file.print(prob.get(i));
        file.println("");
      }


      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }


  void newfile() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\customer_"+freshness+"_"+money+".csv")));

      file.println("");
      file.print(",");

      file.print("[CUSTOMER]");
      file.println("");

      file.print("日付");

      file.print(",");
      file.print("来店数");
      file.print(",");
      file.print("選択回数");
      file.print(",");
      file.println("");

      int kakaku = 150;
      file.print(",");
      file.print(",");

      file.print("買わない");

      for (int i=14; i>=sales_deadline; i--) {
        file.print(",");
        file.print(i + "日");
      }

      for (int i=14; i>=sales_deadline; i--) {
        file.print(",");
        file.print(kakaku + "円");
        kakaku -= 5;
      }
      file.print(",");


      file.println("");
      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }



  void addfile() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\customer_"+freshness+"_"+money+".csv"), true));


      for (int i=0; i<customer_list.size(); i++) {
        for (int j=0; j<customer_list.get(i).size(); j++) {
          file.print(customer_list.get(i).get(j));
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


  void customer_newlist() {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\customer_fresh"+freshness+"_price"+money+".csv")));
      file.println("");

      file.print("[CUSTOMER]");
      file.println("");

      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }



  void customer_addlist(Supershelf supershelf) {
    try {
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\customer_fresh"+freshness+"_price"+money+".csv"), true));
      file.println("");

      file.print("date: " + day);
      file.println("");
      file.print("customer: " + customertotal);
      file.println("");
      file.print("notbuy: " + this.notbuy);
      file.println("");
      file.print("inventory: " + supershelf.inventories());
      file.println("");

      if (buy.size() == 0) {
        file.print(",");
        file.println("");
      } else {
        file.print("number");
        file.print(",");
        for (int i=0; i<buy.get(buy.size()-1).size(); i++) {
          file.print(i+1);
          file.print(",");
        }
        file.println("");
        file.print(",");

        for (int i=0; i<buy.get(buy.size()-1).size(); i++) {
          file.print(buy.get(buy.size()-1).get(i).expiration);
          file.print(",");
        }
        file.println("");
        file.print(",");

        for (int i=0; i<buy.get(buy.size()-1).size(); i++) {
          file.print(buy.get(buy.size()-1).get(i).price);
          file.print(",");
        }
        file.println("");
      }


      file.close();
    }
    catch (IOException e) {
      println(e);
      e.printStackTrace();
    }
  }
}
