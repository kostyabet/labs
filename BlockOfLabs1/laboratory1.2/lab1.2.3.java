public class lab_2 {
    public static void main(String[] args) {
        final int ONEKILOCOST = 280; // weight one kilogram
        final int TABLESTEP = 50; // table step
        final int ENDOFTABLE = 1000; // top table border
        final int GRAMINKILO = 1000; // number of grams in a kilogram
        int Cost = 0;
        for (int i = TABLESTEP; i < ENDOFTABLE + 1; i += TABLESTEP) {
            // current price calculation
            Cost = (i * ONEKILOCOST) / GRAMINKILO;
            // conclusion
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