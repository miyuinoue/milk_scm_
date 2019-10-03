import java.util.ArrayList;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedWriter;


Maker maker;
Superstock superstock;
Supershelf supershelf;

//Track track;
MakerTracks makertracks;
SuperTracks supertracks;
Customer customer;



int day = 1;
int span =90;
int T = 1; //倉庫から商品棚への品出し期間の総数
int E = 14; //賞味期限の最大日数
int maker_demand = 0;
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
int produce = 0;
int customernum=100;

//int price = 150;

//int customernum = 50;
//int sales_size = 0;

ArrayList<Milkstock> customer_buy = new ArrayList<Milkstock>();




void setup(){
    maker = new Maker();
    superstock = new Superstock();
    supershelf = new Supershelf();
    //track = new Track();
    makertracks = new MakerTracks();
    supertracks = new SuperTracks();

    customer = new Customer();
}


void draw(){


  while(day<=span){
    int randomnum = (int)(30 + randomGaussian() * 15);//正規乱数    
    if(randomnum >= 0)customernum = randomnum;
    else customernum = 0;
    
    //customernum = 30;
    
    if(day == 1){
      maker.maker_first();    
      supershelf.super_first();
      //customer.c_daychange();
      
      maker.newstock(400);
      maker.shipment(makertracks,200);//注文数は前日のスーパーからの注文から
      superstock.delivery(makertracks);
      superstock.price(150);//牛乳は150円
      this.restock = shelf_capacity - supershelf.inventories();
      superstock.stocking(supertracks, this.restock);//（shelfの最大在庫量 - shelfの現在の在庫量）の値を補充
      supershelf.restock(supertracks);
      customer.c_daychange();
      
     
      new_file();
      makertracks.maker_newlist();
      supertracks.super_newlist();
      
      //customernum = customer.customer_first();

    }

    for(int t=1; t<=T; t++){
      if(t==1){
        
        maker.shipment(makertracks,order);//注文数は前日のスーパーからの注文から
        
        superstock.delivery(makertracks);

      }
      

      for(int i=0; i<customernum; i++){
        customer.probability(supershelf);
        supershelf.sales(customer.buy());

      }

      if(t==T){
        
        this.restock = shelf_capacity - supershelf.inventories();
        superstock.stocking(supertracks, this.restock);//（shelfの最大在庫量 - shelfの現在の在庫量）の値を補充
        supershelf.restock(supertracks);
        
        maker.maker_appdate();
        maker.demand_forecast();
        maker.standard_deviation();
        maker.safty_stock();
                   
        maker.newstock(produce);//昨日計算した生産量で生産       
        produce = maker.produce();//明日の分の生産量を計算（生産計画リードタイムを1にするため
        //demand = 200;
        //production = maker_capacity - maker.inventories();        

        

        supershelf.super_appdate();
        supershelf.demand_forecast();
        supershelf.standard_deviation();
        supershelf.safty_stock();
        //order = supershelf.order(superstock.inventories(), supershelf.inventories());//発注数計算
        order = supershelf.order(superstock.inventories());//発注数計算
        
        //order = 100;

        maker.waste();
        superstock.waste();
        supershelf.waste();
        

      }
    }
        
    maker.maker_file();
    superstock.stock_file();
    supershelf.shelf_file();
    makertracks.maker_addlist();
    supertracks.super_addlist();
    customer.customer_file();   
    
    add_file();


    maker.m_daychange();
    superstock.stock_daychange();
    supershelf.shelf_daychange();
    customer.c_daychange();
    
    superstock.discount((int)(150*0.7));//150円の3割引き
    supershelf.discount((int)(150*0.7));//150円の3割引き


    day++;
  }
  

}


void new_file(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\file\\"+""+"scm"+".csv")));
      file.println("");
      file.print(",");
      
      file.print("[MAKER]");
      for(int i=0; i<11;i++){
        file.print(",");
      }
      file.print(",");
      
      file.print("[SUPERSTOCK]");      
      for(int i=0; i<15;i++){
        file.print(",");
      }
      file.print(",");
      file.print("[SUPERSHELF]");
      
      
      file.println("");
      
      file.print("日付");   
      file.print(",");
      
      //maker
      file.print("賞味期限");//14～10日//期末在庫なので次の日に処理が行われる
      for(int i=14; i>9; i--){
        file.print(",");
      }
      file.print("生産量");
      file.print(",");
      file.print("受注数量");
      file.print(",");
      file.print("出荷量");
      file.print(",");
      file.print("機会ロス");
      file.print(",");
      file.print("総出荷量"); 
      file.print(",");
      file.print("廃棄量"); 
      file.print(",");
      
      //superstock
      file.print(",");
      file.print("賞味期限");//14～
      for(int i=14; i>4; i--){
        file.print(",");
      } 
      file.print("納品量");
      file.print(",");
      file.print("品出し出荷量");
      file.print(",");     
      file.print("機会ロス");
      file.print(",");
      file.print("総品出し量");
      file.print(",");
      file.print("廃棄量"); 
      file.print(",");
      
      //supershelf
      file.print(",");
      file.print("賞味期限");//14～5日
      for(int i=14; i>4; i--){
        file.print(",");
      }
      file.print("品出し納品量");
      file.print(",");
      file.print("来客数");//販売数と在庫数をいれるべき？
      file.print(",");
      file.print("販売数");
      file.print(",");
      file.print("機会ロス");
      file.print(",");
      file.print("発注量");
      file.print(",");
      file.print("必要補充数量");
      file.print(",");
      file.print("総販売量");
      file.print(",");
      file.print("廃棄量"); 
      file.print(",");
      file.println(",");
      
      
      //maker
      for(int i=14; i>9; i--){
        file.print(",");
        file.print(i);
      }
      
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      
      //stock
      for(int i=14; i>4; i--){
        file.print(",");
        file.print(i);        
      }
      
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      file.print(",");
      
      //shelf
      for(int i=14; i>4; i--){
        file.print(",");
        file.print(i);        
      }
      
      
      
      file.println("");     
      file.close();
    
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }  
    
    
}



void add_file(){
  try{
    PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\file\\"+""+"scm"+".csv"),true));

    file.print(day);
    file.print(","); 
    
    //maker
    for(int i=14; i>9; i--){
      boolean m = false;  
      //if(maker
      for(int j=0; j<maker.size();j++){

        if(maker.get(j).exp_search() == i){
          file.print(maker.get(j).size());
          file.print(",");
          m = true;
          //i--;
        }
      }
      
      if(m == false){
          file.print("0");
          file.print(",");
      }
    }
    
    //file.print(maker.production_volume);
    file.print(maker.production_volume);
    file.print(",");
    file.print(maker.order_num);
    file.print(",");
    file.print(maker.shipment_size);
    file.print(",");
    file.print(maker.maker_loss);
    file.print(",");
    file.print(maker.total_num);
    file.print(","); 
    file.print(maker.maker_waste);
    file.print(",");
    
    //superstock
    file.print(",");

    for(int i=14; i>4; i--){
      boolean st = false;      
      for(int j=0; j<superstock.size();j++){

        if(superstock.get(j).exp_search() == i){
          file.print(superstock.get(j).size());
          file.print(",");
          st = true;
        }
      }
      
      if(st == false){
          file.print("0");
          file.print(",");
      }
    }
    
    file.print(superstock.delivery);
    file.print(",");
    file.print(superstock.stock_num);
    file.print(","); 
    file.print(superstock.stock_loss);
    file.print(",");
    file.print(superstock.total_num);
    file.print(",");  
    file.print(superstock.stock_waste);
    file.print(",");
 
    
    //supershelf
    file.print(",");
    for(int i=14; i>4; i--){
      boolean sh = false;      
      for(int j=0; j<supershelf.size();j++){

        if(supershelf.get(j).exp_search() == i){
          file.print(supershelf.get(j).size());
          file.print(",");
          sh = true;
        }
      }
      
      if(sh == false){
          file.print("0");
          file.print(",");
      }
    }
    
    file.print(supershelf.restock);
    file.print(",");
    file.print(supershelf.visitors);
    file.print(",");
    file.print(supershelf.sales_num);
    file.print(",");
    file.print(supershelf.sales_loss);
    file.print(",");
    file.print(supershelf.order_quantity);
    file.print(",");
    file.print(this.restock);
    file.print(",");
    file.print(supershelf.total_num);
    file.print(",");
    file.print(supershelf.shelf_waste);
    file.print(",");

    
    
    file.println("");
    
    file.close();
  }catch (IOException e) {
    println(e);
    e.printStackTrace();
  }  
       
}    
    
    
