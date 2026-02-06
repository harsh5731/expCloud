// -------------------------------------
// ABSTRACTION + INHERITANCE
// Parent class defines common structure
// -------------------------------------
public abstract class Animal {

    // Encapsulation: private variable + getter/setter
    private String name;
    
    public void setName(String n){
        this.name = n;
    }
    public String getName(){
        return this.name;
    }

    // Abstraction: child MUST implement this method
    public abstract void speak();
}


// -------------------------------------
// INHERITANCE + POLYMORPHISM
// Dog extends Animal and overrides speak()
// -------------------------------------
/*public class Dog extends Animal {

    // Polymorphism: different behavior than Cat
    public override void speak() {
        System.debug('Woof! My name is ' + this.getName());
    }
}


// -------------------------------------
// Another subclass for polymorphism demo
// -------------------------------------
public class Cat extends Animal {

    public override void speak() {
        System.debug('Meow! I am ' + this.getName());
    }
}


// -------------------------------------
// CLASS WITH CONSTRUCTORS + SETTERS
// -------------------------------------
public class TestOOP {
    
    public static void demoRun() {
        
        // Using parameterized constructor via setter call
        Dog d = new Dog();
        d.setName('Harsh Dog');
        
        Cat c = new Cat();
        c.setName('Snowball');
        
        // Polymorphism: same method name, different output
        d.speak(); // Woof! My name is Harsh Dog
        c.speak(); // Meow! I am Snowball
        
        // Upcasting: parent reference → child object
        Animal a = new Dog();
        a.setName('Ghost');
        a.speak(); // Still Woof!  (runtime polymorphism)
    }

}*/