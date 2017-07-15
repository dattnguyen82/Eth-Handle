pragma solidity ^0.4.0;


contract Handle {

  address creator;
  address holder;
  string data;
  uint limit;
  bool dataSet;
  uint created;
  uint passTime;

  event HandlePassed(address newHolder, uint limit, uint passTime);

  function Handle(){
    creator = msg.sender;
    dataSet = false;
    limit = 5;
  }

  function setData(string newData)
  {
    require(msg.sender == creator);
    require(!dataSet);
    data = newData;
    dataSet = true;
    created = now;
  }

  function readData() constant returns (string)
  {
    require(msg.sender == holder);
    return data;
  }

  function pass(address newHolder)
  {
    require(msg.sender == holder);
    _pass(newHolder);
  }

  //Creator overrides
  function auditData() constant returns (string)
  {
    require(msg.sender == creator);
    return data;
  }

  function overridePass(address newHolder) constant returns (string)
  {
    require(msg.sender == creator);
    _pass(newHolder);
  }

  //internal functions
  function _pass(address newHolder) internal
  {
    if (limit <= 0)
    {
      selfdestruct(creator);
    }
    limit--;
    holder = newHolder;
    HandlePassed(holder, limit, now);
  }

}
