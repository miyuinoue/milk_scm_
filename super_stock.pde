class Superstock extends ArrayList <Milkstock>{
  int e;
  int stock_loss;
  int delivery;
  int stocking1 = 0;
  int stock_num = 0;
  int total_num = 0;
  



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

    for(int i=0; i<this.size() ;i++){
      if(this.get(i).size() == 0)continue;

      if(this.get(i).exp_search() < 5){
        continue;
      }else{
        int num = i;
        while(num < this.size()){
          inv += this.get(num).size();
          num++;
        }
        break;
      }
    }

    return inv;
  }


 //前日に発注した牛乳が納品される
 void delivery(Track track){
   if(track.maker_track.size() == 0)return;
   
   delivery = 0;
   noexpiration = true;
   int i = track.maker_track.size()-1;
   
   for(int j=0; j<track.maker_track.get(i).size(); j++){
     
     if(track.maker_track.get(i).get(j).size() == 0)continue;

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにある場合
     e = track.maker_track.get(i).get(j).exp_search();
     if(this.size() != 0){
       for(int k=0; k<this.size(); k++){
         if(this.get(k).size() == 0)continue;

         if(e == this.get(k).exp_search()){
           noexpiration = false;
           for(int l=0; l<track.maker_track.get(i).get(j).size(); l++){
             this.get(k).add(track.maker_track.get(i).get(j).get(l));
             delivery++;
           }
         }
       }
     }

     //納品された牛乳の賞味期限日数と同じ牛乳がstockにない場合 or スーパーの倉庫が空の場合
     if(noexpiration == true || this.size() == 0 ){
       this.add(new Milkstock());
       for(int m=0; m<track.maker_track.get(i).get(j).size(); m++){
         this.get(this.size()-1).add(track.maker_track.get(i).get(j).get(m));
         delivery++;
       }
     }
     
   }
 }

        
        
 //賞味期限が古い商品から順に品出しstockingする
 //古い順に、納品できるかの判定を行い、牛乳一つずつtrackのboxに入れる
 void stocking(Track track , int s){
   stocking1 = s;
   stock_num = 0;
   stock_loss = 0;
    
    if(this.size() == 0){
      stock_loss += s;
      return;
    }
    
       
    //賞味期限が5日～14日までの在庫のみ

    track.super_track.add(new Track(10));
    
    for(int i=0; i<this.size() ;i++){
      if(this.get(i).size() == 0)continue;
      
      if(this.get(i).exp_search() < 5){
        continue;
      }else{
        int num = i;
        outside: while(s > 0){
          
          if(this.get(num).size() == 0){
            if(num == this.size()-1){
              stock_loss += s;
              break outside;
            }
            num++;
          }

          while(this.get(num).size() > 0){     
            track.super_track.get(track.super_track.size()-1).super_addtrack(this.get(num).remove(0));
            s--;
            stock_num++;

            if(s == 0)break outside;
          }
        }
        break;
      }
    }
    
    this.total_num += stock_num;
  }
 
 

 void stock_file(){
   try{
     PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\super_stock\\"+"stock_"+day+".csv"), true));
     file.println("");

     file.print("[SUPERSTOCK]");
     file.println("");

     file.print("date: " + day);
     file.println("");
     file.print("nouhinn: " + delivery);
     file.println("");
     file.print("shinadashi: " + stock_num);
     file.println("");     
     file.print("total:" + this.total_num);
     file.println("");
     file.print("loss: " + stock_loss);
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
         file.print(this.get(i).exp_search());
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



}
