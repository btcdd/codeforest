import java.util.*;

public class Test{
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		System.out.println("Hello CodeForest!");
		
		while(true) {
			System.out.print("line:");
			String line = scan.nextLine();
			System.out.println("real line:" + line);
			if("1".equals(line)) {
				break;	
			}
		}
	}
}