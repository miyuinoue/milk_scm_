class Superstock extends ArrayList <Milkstock>{
  int e;
  int super_loss;



 Superstock(){

 }
 
   //日付が変わると賞味期限が-1日される
  void stock_daychange(){
    for(int i=0; i < this.size(); i++){
      this.get(i).daychange();
    }
  }
  
  //在庫量
  int inventories(){
    int inv = 0;
   int size = (E - sales_deadline + 1); //10
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


 //前日に発注した牛乳が納品される
 void delivery(Track track){
   noexpiration = true;
   int i = track.maker_track.size()-1;
   
   for(int j=0; j<track.maker_track.get(i).size(); j++){
     
     if(track.maker_track.get(i).get(j).size() == 0)continue;

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにある場合
     e = track.maker_track.get(i).get(j).search();
     if(this.size() != 0){
       for(int l=0; l<this.size(); l++){
         if(this.get(l).size() == 0)continue;

         if(e == this.get(l).search()){
           noexpiration = false;
           for(int m=0; m<track.maker_track.get(i).get(j).size(); m++){
             this.get(l).add(track.maker_track.get(i).get(j).get(m));
           }
         }
       }
     }

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにない場合 or スーパーの倉庫が空の場合
     if(noexpiration == true || this.size() == 0){
       this.add(new Milkstock());
       for(int n=0; n<track.maker_track.get(i).get(j).size(); n++){
         this.get(this.size()-1).add(track.maker_track.get(i).get(j).get(n));
       }
     }
     
   }
 }
 
 
 //賞味期限が古い商品から順に品出しstockingする
 //古い順に、納品できるかの判定を行い、牛乳一つずつtrackのboxに入れる
 void stocking(Track track , int order){
   //賞味期限が5日～14日までの在庫のみ
   int size = (E - sales_deadline + 1); //10
    //int d = demand;
    int num;
    
    if(this.size() < size){
      num = 0;
    }else{
      num = this.size()-size;
    }
    
    track.super_track.add(new Track(10));
    outside: while(order > 0){
      
      println(this.get(num).size()+"$$"+order);
      if(this.get(num).size() == 0){
        if(num == this.size()-1){
          super_loss += order;
          break outside;
        }
        num++;
      }

      while(this.get(num).size() > 0){     
        track.super_track.get(track.super_track.size()-1).super_addtrack(this.get(num).remove(0));
        order--;

        if(order == 0)break;

        //if(this.get(num).size() == 0){
          
        //  if(num == this.size()-1){
        //     super_loss += order;
        //     break outside;
        //  }
          
        //  num++;
        //  break;
        //}
      }
      
      //if(num == this.size()-1)break;
    }
  }
  
  

 void stock_file(){
   try{
     PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super_stock\\"+"super_"+day+".csv"), true));
     file.println("");

     file.print("[SUPERSTOCK]");
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


       //file.print("productiondate: " + this.get(i).get(0).production_date);
       //file.print(",");
       //file.print("volume: " + this.get(i).size());
       //file.print(",");
       //file.print("expiration: " + this.get(i).get(0).expiration);
       //file.print(",");
       //file.print("wastedate: " + this.get(i).get(0).waste_date);
       //file.print(",");
       //file.print("wastevolume:" + maker_waste);

       file.println("");
     }

     file.close();
   }catch (IOException e) {
     println(e);
     e.printStackTrace();
   }

 }



 // //残りの賞味期限日数が販売期限を過ぎた牛乳を廃棄する
 // void super_waste(){
 //   super_wastecount = 0;
 //   for(int i = 0; i < stocks.size(); i++){
 //     for(int j = 0; j < stocks.get(i).size(); j++){
 //       if(stocks.get(i).get(0).expiration == 5){
 //         super_wastecount += stocks.get(i).size();
 //         stocks.remove(i);
 //       }
 //     }
 //   }
 //   super_totalhaiki += super_wastecount;
 //   //println("　super廃棄数：" + maker_wastecount);
 //   //println("　super総廃棄数：" + maker_totalhaiki);
 // }


 ////メーカに牛乳を発注する
 //int order(){
 //  //order_quantity = 20;
 //  order_quantity = int(random(15,25));
 //  return order_quantity;
 //}






}
