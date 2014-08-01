
float scrollline = 0;

void setup(){
  size(100,100);
}

void draw(){
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  
  if(e == 1){
    scrollline = scrollline + 1;
  }
  else if(e == -1 && scrollline>0){
    scrollline = scrollline -1 ;
  }
  
  println(scrollline);
}
