public class Customer
{
    public String name;
    public int state;
    public int age;

    public Customer(String nname, int nstate, int nage)
    {
        name = nname;
        state = nstate;
        age = nage;
    }

    @Override
    public boolean equals(Object e)
    {
        Customer c = (Customer) e;
        return (c.name == name);
    }

    @Override
    public int hashCode()
    {
        return name.hashCode();
    }
}
