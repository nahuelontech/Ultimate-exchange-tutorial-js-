pragma solidity ^0.5.0;

import "./Token.sol"; //5.2.when we import this SC, it´s just the code, it doesn´t tell us where it´s located on the BC.

contract EthSwap {
  string public name = "EthSwap Instant Exchange";
//5.This creates a variable that represents the token SC
//Cuando ponemos ``Token´´ 
  Token public token;
  uint public rate = 100;

  event TokensPurchased(
    address account,
    address token,
    uint amount,
    uint rate
  );

  event TokensSold(
    address account,
    address token,
    uint amount,
    uint rate
  );
//5.1. We have to know where the SC is located. We need the code and the address
//5.3.What we can do is pass the address in(Token _token)whenever we deploy the token to the network
  constructor(Token _token) public {
    token = _token; //_token is just a local variable, this doesn´t get store to the BC unless we write ``token =´´
  } //After this go to migration and write in DeploEthSwap -> token.address
  //y tmb nos vamos a tests y en before->ethswap=await ethsawp.new ponemos token.address
//6. REDEMPTIONR ATE = Nº of tokens they receive for 1 ether. In thsi case is 100 DAPPS
  function buyTokens() public payable {
    // Calculate the number of tokens to buy
    uint tokenAmount = msg.value * rate;

    // Require that EthSwap has enough tokens
    require(token.balanceOf(address(this)) >= tokenAmount);

    // Transfer tokens to the user
    token.transfer(msg.sender, tokenAmount);

    // Emit an event
    emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
  }

  function sellTokens(uint _amount) public {
    // User can't sell more tokens than they have
    require(token.balanceOf(msg.sender) >= _amount);

    // Calculate the amount of Ether to redeem
    uint etherAmount = _amount / rate;

    // Require that EthSwap has enough Ether
    require(address(this).balance >= etherAmount);

    // Perform sale
    token.transferFrom(msg.sender, address(this), _amount);
    msg.sender.transfer(etherAmount);

    // Emit an event
    emit TokensSold(msg.sender, address(token), _amount, rate);
  }

}
