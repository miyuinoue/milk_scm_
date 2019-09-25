class Customer extends Supershelf{
float iexp = 0;
float jexp;
float vsum;
float probability = 0;
float freshness = 0.661;
float money = -0.123;
//int customer = 0;

ArrayList<Float> prob = new ArrayList<Float>();

int price = 150;

IntList exp = new IntList();

Customer(){  

  }
  
    //日付が変わると賞味期限が-1日される
  int c_daychange(){
    customer_buy.add(new Milkstock());
    return 100;
    //return (int)random(100);
  }
  
  int customer_first() {
    int m;
    customer_buy.add(new Milkstock());
    //m=(int)random(100);
    m=100;
    //println("m"+m);
    return m;
  }
  
  
  //count番目の牛乳を購入する
  int buy(){ 
    double random_num = Math.random();
    int count =0 ;
    double prob_sum = 0;
  
    for(int i=0; i<prob.size();i++){
      prob_sum += prob.get(i);
      if(prob_sum >= random_num){
        break;
      }
    count++;
    }
   
    return count;
  }
  
  
  void probability(){
    prob.clear();
    
    if(supershelf.size() == 0)return;
    
    for(int i=0; i<supershelf.size() ;i++){
      if(supershelf.get(i).size() == 0)continue;
      
      if(supershelf.get(i).exp_search() < 5){
        continue;
      }else{
        int num = i;
        while(num < supershelf.size()){
          for(int j=0; j<supershelf.get(num).size(); j++){
            jexp = (float)(Math.exp(utility(supershelf.get(num).get(j).expiration, price)) / sum());
            prob.add(jexp);
          }
          num++;
        }
        break;
      }
    }
  }

  
  float sum(){
    vsum = 0;
    
    if(supershelf.size() == 0)return vsum;
    
    for(int i=0; i<supershelf.size() ;i++){
      if(supershelf.get(i).size() == 0)continue;
      
      if(supershelf.get(i).exp_search() < 5){
        continue;
      }else{
        int num = i;
        while(num < supershelf.size()){
          for(int j=0; j<supershelf.get(num).size(); j++){
            vsum += Math.exp(utility(supershelf.get(num).get(j).expiration, price));
          }
          num++;
        }
        break;
      }
    }
    return vsum;
  }

  float utility(int f, int m){
    iexp = freshness * f + money * m;
    return iexp;
  }
  
  
  
  void customer_file(){
    try{
      PrintWriter file = new PrintWriter(new FileWriter(new File("C:\\Users\\miumi\\iCloudDrive\\Desktop\\ondlab\\milk_scm_\\customer\\"+"customer"+day+".csv"), true));
      file.println("");

      file.print("[CUSTOMER]");
      file.println("");

      file.print("date: " + day);
      file.println("");
      file.print("customer: " + customernum);
      file.println("");


      file.print("number");
      file.print(",");
      file.print("expiration");
      file.print(",");
      file.print("seisanbi");
      file.print(",");
      file.print("size");
      file.println(" ");

      if(customer_buy.size()>0){
        for(int i=0; i<customer_buy.get(customer_buy.size()-1).size(); i++){
          file.print(i+1);
          file.print(",");

          if(customer_buy.get(customer_buy.size()-1).size() == 0){
            file.print(" ");
            file.print(",");
            file.print(" ");
          }else{
            file.print(customer_buy.get(customer_buy.size()-1).get(i).expiration);
            file.print(",");
            file.print(customer_buy.get(customer_buy.size()-1).get(i).production_date);
          }
          file.print(",");
          file.print(customer_buy.get(customer_buy.size()-1).size());
          file.println("");
        }
     
      }
      

      

      file.close();
    }catch (IOException e) {
      println(e);
      e.printStackTrace();
    }

  }
}
