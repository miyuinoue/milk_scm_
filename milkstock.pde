class Milkstock extends ArrayList <Milk>{
  int waste_size;

  Milkstock(){
  }

  void daychange(){
    for(int i=0; i<this.size(); i++){
      this.get(i).daychange();
    }
  }

  void makemilk(int p){
    for(int i=0; i<p;i++){
      this.add(new Milk());
      this.get(this.size()-1).newmilk();
    }
  }

  //num日（販売・納品期限）と賞味期限が一緒の場合は廃棄
  int waste(int num){
    int waste_size = 0;
    //int error = 100;//100でいいのか？
    if(this.size() == 0)return 0;
    
    if (this.get(0).expiration == num) {      
      for (int i=0; i<this.size(); i++) {
        this.get(i).waste_date = day;
      }
      
      waste_size = this.size();
    }
    
    return waste_size;
  }



  //賞味期限何日かの探索
  int exp_search(){
    int error = 100;//100でいいのか？
    if(this.size() == 0)return error;
    
    return this.get(0).expiration;
  }
  


}
