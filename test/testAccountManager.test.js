const AccountManager = artifacts.require("AccountManager");

contract("AccountManager", (accounts) => {
    let accMan;
    let accountWithDeposit;
    const depositedAmount = 10;
    const withdrawAmount = 5;
    const initialBalance = 0;
    const allowedOverdraft = 10;
    const accName = "test user";

    before(async () => {
        accMan = await AccountManager.deployed();
        accountWithDeposit = accounts[0];
    });

    before("Create account with addr[0]", async() => {
        await accMan.CreateAccount(accountWithDeposit, accName, 
                                   initialBalance, allowedOverdraft);
    });

    before("Deposit into account accounts[0]", async () => {
            await accMan.deposit(accountWithDeposit, depositedAmount);
    });

    it("can create with correct overdraft val", async () => {
        const instantiatedOverdraft = await accMan.getAllowedOverdraft(accountWithDeposit);

        assert.equal(instantiatedOverdraft, allowedOverdraft);
    });

    it("can change overdraft val correctly", async () => {
        const newOverdraftVal = 11;

        await accMan.setAllowedOverdraft(accountWithDeposit, newOverdraftVal)

        const instantiatedOverdraft = await accMan.getAllowedOverdraft(accountWithDeposit);

        assert.equal(instantiatedOverdraft, newOverdraftVal);
    });

    it("can deposit specified amount to owner of address account and retrieve balance from said address", async () => {
        const depositedToAddress = await accMan.currentBalance(accountWithDeposit);

        assert.equal(depositedAmount, depositedToAddress, "Owner of address should have balance of deposited amount.");
    });

    it("can withdraw specified amount from owner of address account and retrieve balance from said address", async () => {
        await accMan.withdraw(accountWithDeposit, withdrawAmount);
        
        const finalAmount = depositedAmount - withdrawAmount;
        const balanceAfter = await accMan.currentBalance(accountWithDeposit);

        assert.equal(finalAmount, balanceAfter);
    });
});