// arrayDemo:Java类，创建数组、设置数组、返回值，可通过IDL调用。
//
public class arrayDemo 
{
 //定义数组	
 short[][]  intarr;

 //根据传入的数值创建数组
 public arrayDemo(int SIZE1,int SIZE2) {
   intarr = new short[SIZE1][SIZE2];
  //循环赋值，数据值是索引和*2
   for (int i=0; i<SIZE1; i++) {
     for (int j=0; j<SIZE2; j++) {
    	 intarr[i][j] = (short)(i*2+j*2);
     }
   }
 }
 //setArrayValue方法,整个数组赋值
 public void setArrayValue(short[][] _inArr) {
	 intarr = _inArr;
 }
 //获取数组值
 public short[][] getArrayValues() {return intarr;}
 //根据索引获取数组值
 public short getValueByIndex(int i, int j) {
	return intarr[i][j];
 }
}



