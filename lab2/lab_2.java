public class lab_2 {
    public static void main(String[] args) {
        final int ONEKILOCOST = 280, TABLESTEP = 50, ENDOFTABLE = 1000, GRAMINKILO = 1000;
        int Cost = 0;
        for (int i = TABLESTEP; i < ENDOFTABLE + 1; i += TABLESTEP) {
            Cost = (i * ONEKILOCOST) / GRAMINKILO;
            if (i < 99)
            {
                System.out.println(i + "   gram of cheese - cost: " + Cost + "  rubles.");
            } else if (i < 999 && Cost < 100) {
                System.out.println(i + "  gram of cheese - cost: " + Cost + "  rubles.");
            }
            else if (i < 999)
            {
                System.out.println(i + "  gram of cheese - cost: " + Cost + " rubles.");
            }
            else
            {
                System.out.println(i + " gram of cheese - cost: " + Cost + " rubles.");
            }
        }
    }
}