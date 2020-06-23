import java.util.*;

public class Test{
	public static void main(String[] args) {
		System.out.println("code");
		Scanner scan = new Scanner(System.in);
		while(true) {
			String line = scan.nextLine();
			System.out.println("line:" + line);
			if("1".equals(line)) {
				break;
			}
		}
	}
}