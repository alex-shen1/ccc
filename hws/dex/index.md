Decentralized Exchange (DEX)
============================

[Go up to the CCC HW page](../index.html) ([md](../index.md))


### Overview

In this assignment you are going to create a Decntralized Cryptocurrency Exchange (hereafter: DEX) for the token cryptocurrency you created in the [Ethereum Tokens](../tokens/index.html) ([md](../tokens/index.md)) assignment.  Once deployed, anybody will be able to exchange (fake) ETH for your token cryptocurrency.  The DEX will use the 
[Constant Product Automated Market Maker (CPAMM)](../../slides/applications.html#/cpamm) method for determining the exchange rates.


### Pre-requisites

Writing this homework will require completion of the following assignments:

- [Connecting to the private Ethereum blockchain](../ethprivate/index.html) ([md](../ethprivate/index.md))
- [dApp introduction](../dappintro/index.html) ([md](../dappintro/index.md))
- [Ethereum Tokens](../tokens/index.html) ([md](../tokens/index.md))

Note that this assignment requires that your [Ethereum Tokens](../tokens/index.html) ([md](../tokens/index.md)) assignment is working properly.  If you did not get it working properly, then contact us.  You are expected to use your TokenCC code from the [Ethereum Tokens](../tokens/index.html) ([md](../tokens/index.md)) assignment. While you are welcome to use that deployment or re-deploy it, we suspect that you will likely have to re-deploy it many times as you are testing your DEX.  Be sure to save the contract address of the final deployment that you will use when you submit the assignment.

You will also need to be familiar with the [Ethereum slide set](../../slides/ethereum.html#/), the [Solidity slide set](../../slides/solidity.html#/), the [Tokens slide set](../../slides/tokens.html#/), and the [Blockchain Applications](../../slides/applications.html) slide set.  The last one is most relevant, as it discusses how DEXes work.


### The price of our (fake) ETH

To simulate changing market conditions, we have deployed two smart contracts to help one determine the price of our (fake) ETH.  Both of these contracts fulfill the [EtherPricer.sol](EtherPricer.sol.html) ([src](EtherPricer.sol)) interface:

```
interface EtherPricer is IERC165 {
        function getEtherPriceInCents() external view returns (uint);
}
```

Thus, it provides only two functions: the `getEtherPriceInCents()` and `supportsInterface()` from the [IERC165.sol](IERC165.sol.html) ([src](IERC165.sol)) contract.  The `getEtherPriceInCents()` will return the current price in cents.  Thus, if the price is $99.23 per (fake) ETH, it would return `9923`.

As mentioned, there are two deployed, the contract addresses of which are on the Collab landing page.  The first is a constant implementation, which always returns $100.00 (formally: `10000`) as the price.  The implementation for this is in [EtherPricerConstant.sol](EtherPricerConstant.sol.html) ([src](EtherPricerConstant.sol)).  This is meant to be used for debugging, as it always returns the same value.

The second one is a variable version, whose price ranges greatly, but generally averages (over time) around $100 in price.  As there is no true randomness on a fully deterministic blockchain, the value is based on the current block number.  So while this will change at each block, it will not change until a new block is mined.  The implementation for the variable version is not being provided, but it follows the interface above.

You should use the first (constant) one while you are debugging your code.  You will need to use the second (variable) one when you make your final deployment.  The current (variable) price of our (fake) ETH is shown on the DEX web page, which is described below.



### Details

Your DEX must follow the [CPAMM (Constant Product Automated Market Maker)](../../slides/applications.html#/cpamm) method as discussed in the lecture slides.  Once deployed, there will be some liquidity that must be added to the DEX before trading can start.  Anybody can then exchange some of our (fake) ETH for your token cryptocurrency.  This, combined with the varying price of our (fake) ETH, will cause the price of your token cryptocurrency to fluctuate significantly.  At the end of the assignment you will register your DEX with a course-wide exchange so that the entire class can see all of the exchangeable token cryptocurrencies.

As far as this assignment is concerned, there will only be *one* DEX for each token cryptocurrency.  You may have deployed multiple ones to test your code, but for our class trading we will only be having one DEX that you deploy at the end.  Thus, arbitrage trading is not possible, since that requires trading between two or more exchanges.

### Interface

Formally, you must implement a `TokenDEX` contract that implements the [DEX.sol](DEX.sol.html) ([src](DEX.sol)) interface.  Your contract opening line MUST be: `contract TokenDEX is DEX`.  Note that the `DEX` interface extends the `IERC165` interface, so you will also have to implmenet the `supportsInterface()` function.  The functions in this interface are shown below, and much more detail is provided in the [DEX.sol](DEX.sol.html) ([src](DEX.sol)) file.

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC165.sol";
import "./EtherPricer.sol";

interface DEX is IERC165 {

	//------------------------------------------------------------
	// Events

	event liquidityChangeEvent();

	//------------------------------------------------------------
	// Getting the exchange rates and prices

	function tokenDecimals() external view returns (uint);

	function getEtherPrice() external view returns (uint);

	function getTokenPrice() external view returns (uint);

	//------------------------------------------------------------
	// Getting the liquidity of the pool or part thereof

	function k() external view returns (uint);

	function etherLiquidity() external view returns (uint);

	function tokenLiquidity() external view returns (uint);

	function getPoolLiquidityInUSDCents() external view returns (uint);

	function etherLiquidityForAddress(address who) external returns (uint);

	function tokenLiquidityForAddress(address who) external returns (uint);

	//------------------------------------------------------------
	// Pool creation

	function createPool(uint tokenAmount, uint feeNumerator, uint feeDenominator, 
						address erc20token, address etherpricer) external payable;

	//------------------------------------------------------------
	// Fees

	function feeNumerator() external view returns (uint);

	function feeDenominator() external view returns (uint);

	function feesEther() external view returns (uint);

	function feesToken() external view returns (uint);

	//------------------------------------------------------------
	// Managing pool liquidity

	function addLiquidity() external payable;

	function removeLiquidity(uint amountEther) external;

	//------------------------------------------------------------
	// Exchanging currencies

	function exchangeEtherForToken() external payable;

	function exchangeTokenForEther(uint amountToken) external;

	//------------------------------------------------------------
	// Functions for debugging and grading

	function setEtherPricer(address p) external;

	function etherPricerAddress() external returns (address);

	function erc20TokenAddress() external returns (address);

	function getTokenCCAbbreviation() external returns (string memory);

	//------------------------------------------------------------
	// Functions for efficiency

	function getDEXinfo() external returns (address, string memory, string memory, 
							address, uint, uint, uint, uint, uint, uint, uint, uint);

	//------------------------------------------------------------
	// Inherited functions

	// function supportsInterface(bytes4 interfaceId) external view returns (bool);

}
```

Here are all the files you will need:

- [DEX.sol](DEX.sol.html) ([src](DEX.sol)): the interface, above, that your contract will need to implement
- [EtherPricer.sol](EtherPricer.sol.html) ([src](EtherPricer.sol)): the interface that the two pricing smart contracts implement; the contract addresses for these are on the Collab landing page
- [EtherPricerConstant.sol](EtherPricerConstant.sol.html) ([src](EtherPricerConstant.sol)) is the contract implementation of EtherPricer.sol that always returns 100 in cents (formally: `10000`); note that the source code for the variable version is not being made available
- [IERC165.sol](IERC165.sol.html) ([src](IERC165.sol)): the ERC-165 interface, which the DEX interface extends
- [IERC20Metadata.sol](IERC20Metadata.sol.html) ([src](IERC20Metadata.sol)): the same file from the [Ethereum Tokens](../tokens/index.html) ([md](../tokens/index.md)) assignment, which your token cryptocurrency implements
- [IERC20.sol](IERC20.sol.html) ([src](IERC20.sol)): The full ERC-20 interface, which the IERC20Metadata contract extends


When you want to test your program, this is the expected flow to get it started, whether to the Javascript blockchain in Remix or to our private Ethereum blockchain:

- Deploy your TokenDEX contract and (if necessary) your TokenCC contract
- Approve your TokenDEX contract for some amount of your TokenCC supply via `approve()` on your TokenCC contract
- Call `createPool()` on your TokenDEX.  Choose how much TokenCC supply to use (you don't have to use it all!), and put in the appropriate EtherPricer contract address

### Fees

Each transaction will have fees deducted.  Fees are always deducted from the amount the DEX pays out -- it just pays that much less.  Reasonable fees are a fraction of a percent -- perhaps 0.2%, for example.

When fees are withheld, the amount that is withheld is added to the `feesEhter` and `feesToken` variables (and getter functions).  These accumulate the *total* amount of fees that the DEX has accumulated over time.  

Managing fees is quite complicated -- one has to take into account how much liquidity each provider has in the DEX, and over what time frame.  There could be thousands of liquidity providers in the pool, each of which gets a cut, proportional to their liquidity, of each transaction's fee.  Furthermore, fees are added to the liquidity pool, but only when they can be added in appropriate proportions.

For this assignment, we are not going to handle distributing fees back to the liquidity providers -- we are just going to accumulate them into the `feesEhter` and `feesToken` variables.  We realize that this inability to retrieve the fees would result in lost ETH or TC.  That's fine for this assignment, even if it would not be fine in a real world situation.

### Example

To help you debug your program, here is a worked-out example of how the values in the DEX change as various transactions occur.  This is assuming a constant (fake) ETH price of $100.  In the example below, we will call the token cryptocurrency "TC" for "Token Cryptocurrency".  For reasons we will see below, we are only putting in 10 (fake) ETH in this example, whereas you will have put in 100 when you deploy it at the end of the assignment.

- We are starting off with a few assumptions; if these vary from yours, then change as necessary
  - $x$ will always represent the amount of ETH in the pool.  As ETH is represented in wei, this will be the ETH amount with 18 decimal places
  - $y$ will always represent the amount of TC in the pool.  We assume that there are 10 decimal places for TC.
  - The assumption is that you have more TC that you own beyond what you have just deposited
  - For the examples herein, we are ignoring fees -- you can set the `feeNumerator` to 0 to get this when testing your contract
- `createPool()`: initially, we will deposit 10 (fake) ETH and 100 TC
  - $k$ should be $10 \ast 100 = 1,000$, since we deposited 10 ETH and 100 TC.  But the value reported by the DEX will be with 10 more decimal places for TC and 18 more decimal places for the ETH.  So $k$ will report as $1,000 \ast 10^{10} \ast 10^{18} = 10^{31} = 10,000,000,000,000,000,000,000,000,000,000$
  - The 10 ETH are worth $100 each (we are assuming the constant EtherPricer for this example), so the ETH is worth $1,000.  Since the TC is assumed to have the same value, the overall DEX liquidity is $2,000.  Each TC is worth $0.10.
  - At this point:
  	- $k=10^{31}$
  	- $x$, the amount of ETH, is 10 or $x=10*10^{18}=10^{19}$
  	- $y$, the amount of TC, is 100 or $y=100*10^{10}=10^{12}$
  	- The exchange ration is 1 ETH for 10 TC (we just divide 1,000 by 100)
- Transaction 1: we exchange 2.5 ETH for some amount of TC
  - The pool will then have 12.5 ETH (or $x=12.5 \ast 10^{18}$ wei)
  - Determine $y$ by dividing $k$ by $x$: $y = k/x = 10^{31} / 12.5 \ast 10^{18} = 8 \ast 10^{11}$ or (after removing the decimals) 80 TC
  - As the pool had 100 TC before this transaction, we get $100-80=20$ TC (formally: $20 \ast 10^{10}$)
  - At this point:
  	- $k=10^{31}$
  	- $x$, the amount of ETH, is 12.5 or $x=12.5*10^{18}=1.25 \ast 10^{19}$
  	- $y$, the amount of TC, is 80 or $y=80*10^{10}=8^{11}$
  	- The exchange rate is 1 ETH for 6.4 TC (we just divide 80 by 12.5)
- Transaction 2: we exchange 120 TC for some ETH
  - The pool will then have 200 TC (or $y=200 \ast 10^{10} = 2 \ast 10^{12}$)
  - Determine $x$ by dividing $k$ by $y$: $x = k/y = 10^{31} / 2 \ast 10^{12} = 5 \ast 10^{18}$ or 5 ETH
  - As the pool had 12.5 ETH, we get $12.5-5=7.5$ ETH
  - At this point:
  	- $k=10^{31}$
  	- $x$, the amount of ETH, is 5 or $x=5 \ast 10^{18}$
  	- $y$, the amount of TC, is 200 or $y=200*10^{10}=2 \ast 10^{12}$
  	- The exchange rate is 1 ETH for 40 TC (we just divide 200 by 5)
- We add liquidity to the pool
	- The DEX has 5 ETH and 200 TC; the exchange rate is 1 ETH for 40 TC (from above)
  - We have to add in equal amounts; as far as this DEX is concerned, 1 ETH is equal to 40 TC; thus, we have to put in 40 times as many TC as we put in ETH
  - We opt to put in 1 ETH and 40 TC
  - The new amounts in the DEX will be 6 ETH and 240 ETH; this keeps the same exchange ratio of 1 ETH = 40 TC (we just divide 240 by 6)
  - $x$, the amount of ETH, increases by 1 or $1 \ast 10^{18}$ to become $x=5 \ast 10^{18} + 1 \ast 10^{18} = 6 \ast 10^{18} = 6 \ast 10^{18}$
  - $y$, the amount of TC, increases by 40 or $40 \ast 10^{10}$ to become: $y=200 \ast 10^{10} + 40 \ast 10^{10} = 240 \ast 10^{10} = 2.4 \ast 10^{12}$
  - We recompute $k$ via $k = x \ast y = 6 \ast 10^{18} \ast 2.4 \ast 10^{12} = 1.44 \ast 10^{31}$
  - At this point:
  	- $k=1.44 \ast 10^{31}$
  	- $x$, the amount of ETH, is 6 or $x=6*10^{18}=6 \ast 10^{18}$
  	- $y$, the amount of TC, is 240 or $y=240*10^{10}=2.4 \ast 10^{12}$
  	- The exchange rate is 1 ETH for 40 TC (we just divide 240 by 6)


### Deployment

This part has three different steps.  This may require a few runs to get it right -- that's fine, just be sure to submit the various values (contract addresses and transaction hashes) from the last deployment.

Step 1: You will need to have deployed your TokenCC smart contract, from the previous assignment, to the blockchain, and you will need to know its contract address.  You are welcome to use the deployed one from the previous assignment, or re-deploy it for this one.

Step 2: Deploy your DEX to the private Ethereum blockchain.  So that it will work properly with all of your other classmates' DEX implementations, we have some strict requirements for the deployment:

- It must be initialized with the *variable* EtherPricer contract for the price of our (fake) ether.  While you are welcome to use the constant one for testing, you MUST use the variable one for the final deployment.
- You need to call `createPool()`
	- You must fund it with 100 (fake) ether.  *Do not put a different amount in!*
	    - This implies initializing the TokenCC and allowing the DEX to transfer it
	- You can put as many or as little of your token in as you like (but no less than 10.0 coins).  Putting in fewer will give them a higher monetary value, but allow for less growth.  But you should keep some for yourself, as you will need it below -- so don't put them all in.  We recommend putting in about half of what you own, and you can certainly put in less.
- Do not call either `addLiquidity()` or `removeLiquidity()` yet

Step 3: You need to register your DEX with the course-wide exchange board website; the URL for this is on the Collab landing page.  To register your DEX, fill out the contract address form at the bottom of that page -- all the other information (your userid and token abbreviation) has already been submitted for you.  You will see your DEX values populate one of the table rows -- make sure they are correct.  Note that the current ETH price is listed at the top of the page.

### Send me some of your token cryptocurrency

I will need some of your token cryptocurrency to test your DEX for grading purposes.  While you sent me some in a previous homework, that was likely with a differently deployed TokenCC smart contract.  Please send me 1.0 coins.  This means that if your TokenCC has 10 decimal places, then the value you need to send me is 10,000,000,000.  The address to send this to is on the Collab landing page.


### Make some exchanges

Now that your exchange is registered, you can view all the exchanges.  You should see your exchange in there, along with your cryptocurrency's logo.  The stats of each exchange are listed in that table.

You need to make 4 total exchanges with DEXes other than you own.  As you likely have more of your own Token cryptocurrency, you can now exchange that with your DEX to get some ether.  Or you can mine ether and use that to exchange for the others.

Depending on when you submit your assignment, there may not be other DEXes to interact with.  That’s fine – you don’t have to have those bids completed by the time the assignment is due; you have an extra few days to place your bids. We are going to judge lateness on this assignment by the Gradescope submission time, and the Google form does not ask for the transaction hashes of the exchanges. We are going to check whether you exchange for the other token cryptocurrencies by looking if your eth.coinbase account, the address of which you will submit below, initiated exchanges on any one of your classmate’s submitted DEX addresses by a few days after the due date. Note that you have to place the bid via Remix or geth; the course website just displays the auctions.


### Submission

There are *four* forms of submission for this assignment; you must do all four.

Submission 1: Submit the TokenDEX.sol file to Gradescope.  Also submit the TokenCC.sol file, from the previous assignment.

Submission 2: Deploy the TokenDEX smart contract to the private Ethereum blockchain.  Your TokenCC will need to have been deployed as well, either from the previous assignment or again for this one.  These were likely done in the deployment section, above.

Submission 3: Register your DEX smart contract with the course-wide exchange.  This, also, was likely done in the deployment section, above.

Submission 4: Google form!  The URL is on the Collab landing page.