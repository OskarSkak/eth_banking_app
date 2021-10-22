pragma solidity ^0.5.0;

contract AccountManager {
    mapping(address => int) public balance; //Virtually store all possible combis
    mapping(address => Account) public accounts;

    //uint uint_default_val = 0;

    struct Account {
        string name;
        address id;
        bool instantiated;
        int balance; //uint can't be negative
        int allowedOverdraft;
    }

    function CreateAccount(address addr, string memory name, int initialBalance,
                             int allowedOverdraft) public returns (bool createdAcc){
        Account memory newAcc = Account(name, addr, true, initialBalance, allowedOverdraft);

        accounts[addr] = newAcc;

        Account memory newlyCreated = accounts[addr];

        if(newlyCreated.allowedOverdraft == allowedOverdraft
            && newlyCreated.instantiated 
            && newlyCreated.balance == initialBalance
            && newlyCreated.allowedOverdraft == allowedOverdraft){
            return true;
        }

        return false;
    }

    function getAllowedOverdraft(address addr) public view returns (int allowedOverdraft){
        return accounts[addr].allowedOverdraft;
    }

    function setAllowedOverdraft(address addr, int newAllowed) public returns (bool success){
        if(!accounts[addr].instantiated){
            return false;
        }

        accounts[addr].allowedOverdraft = newAllowed;

        return true;
    }

    function getName(address addr) public view returns (string memory name){
        return accounts[addr].name;
    }

    function setName(address addr, string memory newName) public returns (bool success){
        if(!accounts[addr].instantiated){
            return false;
        }
        
        accounts[addr].name = newName;

        return true;
    }

    function currentBalance(address addr) public view returns (int){ //no modification
        return accounts[addr].balance;
    }

    function withdraw(address addr, int amount) public returns (bool success){
        int minBalance = 0 - getAllowedOverdraft(addr);
        int newBalance = currentBalance(addr) - amount;
        if(newBalance > minBalance){
            accounts[addr].balance -= amount;
            return true;
        }

        return false;
    }

    function deposit(address addr, int amount) public returns (int newBalance){
        accounts[addr].balance += amount;

        return currentBalance(addr);
    }
}