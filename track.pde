class Track extends ArrayList <Milkstock> {

//  ArrayList<Track> maker_track = new ArrayList<Track>(); //trackの複数形tracksのクラスをつくる
//  ArrayList<Track> super_track = new ArrayList<Track>(); 
  Track() {
  }

  Track(int num) {
    for (int i=0; i<num; i++) {
      this.add(new Milkstock());
    }
  }


  void maker_addtrack(Milk milk) {
    milk.movingday_maker_super = day;

    //this.get(14 - milk.expiration).add(milk);
    switch(milk.expiration) {

    case 14:

      this.get(0).add(milk);

      break;

    case 13:

      this.get(1).add(milk);

      break;

    case 12:

      this.get(2).add(milk);

      break;

    case 11:

      this.get(3).add(milk);

      break;

    case 10:

      this.get(4).add(milk);

      break;
    }
  }

  void super_addtrack(Milk milk) {
    milk.movingday_stock_shelf = day;

    //this.get(14 - milk.expiration).add(milk);
    switch(milk.expiration) {

    case 14:

      this.get(0).add(milk);

      break;

    case 13:

      this.get(1).add(milk);

      break;

    case 12:

      this.get(2).add(milk);

      break;

    case 11:

      this.get(3).add(milk);

      break;

    case 10:

      this.get(4).add(milk);

      break;

    case 9:

      this.get(5).add(milk);

      break;

    case 8:

      this.get(6).add(milk);

      break;

    case 7:

      this.get(7).add(milk);

      break;

    case 6:

      this.get(8).add(milk);

      break;

    case 5:

      this.get(9).add(milk);

      break;
    }
  }

}
