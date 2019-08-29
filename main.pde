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



int day = 1;
int span = 10;
int T = 1; //倉庫から商品棚への品出し期間の総数
int E = 14; //賞味期限の最大日数
int demand = 0;
int order_num = 0;
int waste = 0;
int sales_deadline = 5; //計算で出す
int delivery_deadline = 10; //計算で出す
boolean noexpiration;

int shelf_capacity = 200;
int restock = 0;

void setup(){
    maker = new Maker();
    superstock = new Superstock();
    supershelf = new Supershelf();
    makertrack = new Track(5);
    supertrack = new Track(10);
}

void draw(){



  while(day<=span){
    if(day == 1){
      maker.maker_first();
      supershelf.super_first();
    }

    for(int t=1; t<=T; t++){
      if(t==1){
        demand = maker.produce(maker.inventories());
        order_num = supershelf.order(superstock.inventories(), supershelf.inventories());
        maker.newstock(demand);
        maker.shipment(makertrack,order_num);//注文数は前日のスーパーからの注文から
        //maker.maker_stock(maker.production(supermarket.order()));//生産数は前日の需要予測から

        //maker.m_waste();

      }

      superstock.delivery(makertrack);
      
      restock = shelf_capacity - supershelf.inventories();
      superstock.stocking(supertrack, restock);//（shelfの最大在庫量 - shelfの現在の在庫量）の値を補充
      supershelf.restock(supertrack);

      if(t==T){
        //supermarket.super_waste();

        maker.m_waste();


      }
    }
    maker.maker_appdate();
    maker.demand_forecast();
    maker.standard_deviation();
    maker.safty_stock();
    
    supershelf.super_appdate();
    supershelf.demand_forecast();
    supershelf.standard_deviation();
    supershelf.safty_stock();


    
    maker.maker_file();
    superstock.stock_file();
    supershelf.shelf_file();
    makertrack.maker_list();
    supertrack.super_list();


    maker.m_daychange();
    superstock.stock_daychange();
    supershelf.shelf_daychange();

    day++;
  }


}
