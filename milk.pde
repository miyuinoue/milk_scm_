class Milk{
  int production_date;
  int waste_date;
  int expiration;
  int movingday_maker_super;
  int movingday_stock_shelf;
  
  Milk(){
    production_date = -1;
    waste_date = -1;
    movingday_maker_super = -1;
    movingday_stock_shelf = -1;
  }
  
  void newmilk(){
    this.expiration = E;
    this.production_date = day;
  }
  
  int daychange(){
    expiration--;
    return expiration;
  }
  
  
}
