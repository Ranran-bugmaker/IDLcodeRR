//引用包
package helloworldex;
import com.idl.javaidl.*;
public class Main {
	//
	private static helloworldex test;
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		// 对象创建
		test=new helloworldex();
		//初始化
		test.createObject();
		//调用对象方法
		JIDLString result =
			test.HELLOFROM(new JIDLString("IDL test"));
		//输出返回字符串
		System.out.println(result);			
	}
}
