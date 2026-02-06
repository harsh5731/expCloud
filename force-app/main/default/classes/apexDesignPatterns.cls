public class apexDesignPatterns {

//Singleton Design Pattern

    // 1. static instance holder
    private static apexDesignPatterns instance;

    // 2. private constructor
    private apexDesignPatterns() {
        // initialization logic goes here
        // e.g., load custom metadata / set defaults
    }

    // 3. public access method
    public static apexDesignPatterns getInstance() {
        if (instance == null) {
            instance = new apexDesignPatterns();
        }
        return instance;
    }
}