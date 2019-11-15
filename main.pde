import java.util.ArrayList;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedWriter;

Milkstock milkstock;

Maker maker;
Superstock superstock;
Supershelf supershelf;

Track track;
MakerTracks makertracks;
SuperTracks supertracks;
Customer customer;



int day = 1;
int span = 180;
int T = 3; //倉庫から商品棚への品出し期間の総数
int E = 14; //賞味期限の最大日数
int maker_demand = 0;
int order = 0;

int sales_deadline = 5; //計算で出す
int delivery_deadline = 10; //計算で出す

boolean noexpiration;

int shelf_capacity = 50;
int stock_capacity = 100;
int maker_capacity = 300;
int restock = 0;
int super_loss;
int produce = 0;

int daynum = 1;

float freshness = 0;
float money = 0;

int customernum;
int r = 0;

int timemaker = 1;
int timesuper = 1;

ArrayList<Milkstock> buy = new ArrayList<Milkstock>();
ArrayList<ArrayList<Integer>> maker_list = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> stock_list = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> shelf_list = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> customer_list = new ArrayList<ArrayList<Integer>>();

ArrayList<ArrayList<Double>> utility_list = new ArrayList<ArrayList<Double>>();


ArrayList<Integer> maker_waste;
ArrayList<Integer> super_waste;
ArrayList<ArrayList<Integer>> maker_wastes = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> super_wastes = new ArrayList<ArrayList<Integer>>();





void setup() {
  milkstock = new Milkstock();
  maker = new Maker();
  superstock = new Superstock();
  supershelf = new Supershelf();
  track = new Track();
  makertracks = new MakerTracks();
  supertracks = new SuperTracks();
  customer = new Customer();
}


void draw() {

  customer.fresh_price();//正規化するための賞味期限と価格のリストの作成

  for (int a=0; a<5; a++) {
    for (int b=0; b<=5; b++) {
      freshness = b;

      maker_waste = new ArrayList<Integer>();
      super_waste = new ArrayList<Integer>();

      for (int c=0; c<=1; c+=10) {
        money = c;

        reset();

        int ms = millis();

        main_scm();//68981

        maker_waste.add(maker.maker_totalwaste);
        super_waste.add((superstock.stock_totalwaste + supershelf.shelf_totalwaste));
        
        println(ms);
      }
      maker_wastes.add(maker_waste);
      super_wastes.add(super_waste);
    }

    makerwaste_file();
    superwaste_file();
  }



  println("fin.");

  exit();
}


void main_scm() {
  while (day<=span) {

    if (day == 1) {
      maker.maker_first();
      supershelf.super_first();
      customer.customer_first();//位置

      //customer.customer_newlist();
      //customer.prob_newfile();
    }

    for (int t=1; t<=T; t++) {
      if (t==1) {
        maker.shipment(makertracks, order);//前日のスーパーからの受注数からトラックに積み出荷する

        superstock.delivery(makertracks);//トラックがスーパー倉庫に納品する，stockの牛乳を150円にする
      }

      this.restock = shelf_capacity - supershelf.inventories();
      superstock.stocking(supertracks, this.restock);//（shelfの最大在庫量 - shelfの現在の在庫量）をトラックに積む
      supershelf.restock(supertracks);//トラックに入れた牛乳をstockからshelfに品出しする


      //人数の決定
      customernum = customer.random_customer(day);
      //customernum = customer.random_customer();


      ////客の選択確率を計算し，購入．①
      //for(int i=0; i<customernum; i++){
      //  customer.probability(supershelf);
      //  supershelf.sales(customer.buy());
      //}


      //客の選択確率を計算し，購入．②
      for (int i=0; i<customernum; i++) {
        customer.normalization(supershelf);//賞味期限と価格を正規化
        customer.probability();
        supershelf.sales(customer.buy());

        //customer.prob_file(supershelf);
      }


      if (t==T) {

        //メーカの需要予測
        maker.maker_appdate();
        maker.demand_forecast();
        maker.standard_deviation();
        maker.safty_stock();

        maker.newstock(produce);//昨日計算した生産量を生産
        produce = maker.produce();//明日の分の生産量計算（生産計画リードタイムを1にするため）


        //スーパーの需要予測
        supershelf.super_appdate();
        supershelf.demand_forecast();
        supershelf.standard_deviation();
        supershelf.safty_stock();
        order = supershelf.order(superstock.inventories(), supershelf.inventories());//発注数計算

        //廃棄
        maker.waste();
        superstock.waste();
        supershelf.waste();
      }
    }

    customer.select_milk();
    customer.select_price();

    //リストの追加
    maker.maker_list();
    superstock.stock_list();
    supershelf.shelf_list();
    customer.customer_list();

    makertracks.maker_addlist();
    supertracks.super_addlist();

    //add_file();


    maker.m_daychange();
    superstock.stock_daychange();
    supershelf.shelf_daychange();
    customer.c_daychange();


    //superstock.discountalways(5);//毎日5円引き
    //supershelf.discountalways(5);//毎日5円引き

    superstock.discount3((int)(150*0.7));//150円の3割引き
    supershelf.discount3((int)(150*0.7));//150円の3割引き

    day++;
  }
  maker.addfile();
  super_addfile();
  customer.addfile();
}



void reset() {
  day = 1;

  maker.maker_totalwaste = 0;
  supershelf.shelf_totalwaste = 0;
  superstock.stock_totalwaste = 0;

  buy.clear();
  maker_list.clear();
  stock_list.clear();
  shelf_list.clear();
  customer_list.clear();
  utility_list.clear();


  maker_waste.clear();
  super_waste.clear();
  maker_wastes.clear();
  super_wastes.clear();

  superstock.stock.clear();

  customer.c.clear();
  customer.prob.clear();
  customer.u.clear();
  customer.f.clear();
  customer.p.clear();
  customer.select_fre.clear();
  customer.select_pri.clear();
  
  track.maker_track.clear();
  track.super_track.clear();

  milkstock.clear();
  maker.clear();
  superstock.clear();
  supershelf.clear();
  makertracks.clear();
  supertracks.clear();
}


void file_first() {

  //new_file();
  maker.newfile();
  super_newfile();
  customer.newfile();

  makertracks.maker_newlist();
  supertracks.super_newlist();
}


void super_newfile() {
  try {
    PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super\\super_"+freshness+"_"+money+".csv")));

    file.println("");
    file.print(",");
    file.print(",");

    file.print("[SUPERSTOCK]");
    for (int i=0; i<18; i++) {
      file.print(",");
    }

    file.print("[SUPERSHELF]");


    file.println("");

    file.print("日付");
    file.print(",");

    //superstock
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


    //stock
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
    file.print(",");
    file.print(",");

    //shelf
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



void super_addfile() {
  try {
    PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super\\super_"+freshness+"_"+money+".csv"), true));

    for (int i=0; i<stock_list.size(); i++) {
      for (int j=0; j<stock_list.get(i).size(); j++) {
        file.print(stock_list.get(i).get(j));
        file.print(",");
        if (j==stock_list.get(i).size()-1) {
          file.print(",");
          for (int k=0; k<shelf_list.get(i).size(); k++) {
            file.print(shelf_list.get(i).get(k));
            file.print(",");
          }
        }
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


void makerwaste_file() {
  try {

    PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\waste\\maker_waste.csv"), true));

    file.println("");
    file.print(timemaker);
    file.println("");

    for (int i=0; i<maker_wastes.size(); i++) {
      for (int j=0; j<maker_wastes.get(i).size(); j++) {
        file.print(maker_wastes.get(i).get(j));
        file.print(",");
      }
      file.println("");
    }

    timemaker++;


    file.println("");

    file.close();
  }
  catch (IOException e) {
    println(e);
    e.printStackTrace();
  }
}

void superwaste_file() {
  try {
    PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\waste\\super_waste.csv"), true));

    file.println("");
    file.print(timesuper);
    file.println("");

    for (int i=0; i<super_wastes.size(); i++) {
      for (int j=0; j<super_wastes.get(i).size(); j++) {
        file.print(super_wastes.get(i).get(j));
        file.print(",");
      }
      file.println("");
    }

    timesuper++;

    file.println("");

    file.close();
  }
  catch (IOException e) {
    println(e);
    e.printStackTrace();
  }
}
