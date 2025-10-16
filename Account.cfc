component implements="ITransaction" hint="Bank account component" {

    // Private property (encapsulation)
    private property name="balance" type="numeric" default=0;

    // Public property with accessors
    property name="accountNumber" type="string" accessors="true";

    // Constructor (init method)
    function init(required string accountNumber, numeric startingBalance=0) {
        variables.accountNumber = arguments.accountNumber;
        variables.balance = arguments.startingBalance;
        return this;
    }

    // Method to deposit money
    function deposit(required numeric amount) {
        if (amount <= 0) return "Deposit must be positive!";
        variables.balance += amount;
        return "Deposited $" & amount & ". Current balance: $" & variables.balance;
    }

    // Method to withdraw money
    function withdraw(required numeric amount) {
        if (amount <= 0) return "Withdrawal must be positive!";
        if (amount > variables.balance) return "Insufficient funds!";
        variables.balance -= amount;
        return "Withdrew $" & amount & ". Current balance: $" & variables.balance;
    }

    // Method to check balance
    function getBalance() {
        return variables.balance;
    }
}

// Interface for demonstration
interface ITransaction {
    function deposit(required numeric amount);
    function withdraw(required numeric amount);
    function getBalance();
}
