import java.util.ArrayList;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedWriter;


Maker maker;
Superstock superstock;
Supershelf supershelf;
Track makertrack;
Track supertrack;
Customer customer;



int day = 1;
int span =90;
int T = 1; //倉庫から商品棚への品出し期間の総数
int E = 14; //賞味期限の最大日数
int demand = 0;
int order = 0;
int waste = 0;
int sales_deadline = 5; //計算で出す
int delivery_deadline = 10; //計算で出す
boolean noexpiration;

int shelf_capacity = 100;
int stock_capacity = 100;
int maker_capacity = 200;
int restock = 0;
int super_loss;
int customernum=100;

//int customernum = 50;
//int sales_size = 0;

ArrayList<Milkstock> customer_buy = new ArrayList<Milkstock>();




void setup(){
    maker = new Maker();
    superstock = new Superstock();
    supershelf = new Supershelf();
    makertrack = new Track(5);
    supertrack = new Track(10);
    customer = new Customer();
}


void draw(){
//スーパーからの需要を受け取ってから生産を開始する


  while(day<=span){
    if(day == 1){
      maker.maker_first();
      
      supershelf.super_first();

      
      supershelf.demand_forecast();
      supershelf.standard_deviation();
      supershelf.safty_stock();
      
      //customernum = customer.customer_first();

    }

    for(int t=1; t<=T; t++){
      if(t==1){
        
        maker.shipment(makertrack,order);//注文数は前日のスーパーからの注文から
        
        superstock.delivery(makertrack);

      }
      
      restock = shelf_capacity - supershelf.inventories();
      superstock.stocking(supertrack, restock);//（shelfの最大在庫量 - shelfの現在の在庫量）の値を補充
      supershelf.restock(supertrack);
      

              
      for(int i=0; i<customernum; i++){
        customer.probability();
        supershelf.sales(customer.buy());
      }

      if(t==T){
        
        maker.maker_appdate();
        maker.demand_forecast();
        maker.standard_deviation();
        maker.safty_stock();
        
        
        
        

              
        maker.newstock(demand);//昨日計算した生産量で生産
        
        demand = maker.produce(maker.inventories());//明日の分の生産量を計算（生産計画リードタイムを1にするため）

        

        supershelf.super_appdate();
        supershelf.demand_forecast();
        supershelf.standard_deviation();
        supershelf.safty_stock();
        order = supershelf.order(superstock.inventories(), supershelf.inventories());//発注数計算
//        supermarket.super_waste();

//        maker.m_waste();


      }
    }
        
    maker.maker_file();
    superstock.stock_file();
    supershelf.shelf_file();
    makertrack.maker_list();
    supertrack.super_list();
    customer.customer_file();


    maker.m_daychange();
    superstock.stock_daychange();
    supershelf.shelf_daychange();
    customernum = customer.c_daychange();//明日の来店数

    day++;
  }


}
