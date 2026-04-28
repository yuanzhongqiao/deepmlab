import java.io.IOException;
import java.lang.InterruptedException;

public class Test_Exec_Scilab {
    public static void main(String[] args) throws IOException, InterruptedException {
        String cmd = args[0] + " -e a=string(1:10);mputl(a,'" + args[1] + "');quit";
        Process p = Runtime.getRuntime().exec(cmd);
        p.waitFor();
    }
}