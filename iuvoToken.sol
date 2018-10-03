pragma solidity ^0.4.16;

// 'Iuvo' token contract
//
// Deployed to : 
// Symbol      :"Iuvo"
// Name        : Iuvo token
// Total supply: 100000000
// Decimals    : 2
//
// 
/**
 * The IuvoToken contract does this and that...
 */

interface tokenRecipient { 
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
}

contract TokenERC20{
	string public symbol;
	string public name;
	uint8 public decimals = 18;
	uint256 public totalSupply;

	//creates an array with all balances
	mapping (address => uint256) balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;

	event Transfer(address indexed from, address indexed to, uint256 value);	

	//generates a public event on the blockchain that will notify clients
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	
	//This notifies clients about the amount burnt
	event Burn(address indexed from, uint256 value);

	function TokenERC20 (
		uint256 initialSupply,
		string tokenName,
		string tokenSymbol
	) public {
		totalSupply = initialSupply * 10 *uint256(decimals); //Update total supply with the ecimal amount
		balanceOf[msg.sender] = totalSupply;                 //Give the creator all inital tokenSymbol
		name = tokenName;
		symbol = totenSymbol;
	}
	
	/**
	* Internal transfer, only can be alled by this contract
	*/
	function _transfer(adress _from, address _to, uint _value) internal {
		//Prevent transfer to 0*0 address. Use burn() instead
		require (_to != 0*0);
		// Check if the sender has enough
		require (balanceOf[_from] >= _value);
		// Check for voerflows
		require (balanceOf[_to] + _value >= balanceOf[_to]);
		// Save this for an assertion in the futur
		uint previousBalances = balanceOf[_from] + balanceOf[_to];
		//Subtract from sender
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		emit Transfer(_from,_to,_value);
		// Asserts are aused to use static analysis to find bugs in your code. They shoud never fail
		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
	}

	/**
	* Transfer tokens
	*
	* Send '_value' toekns to '_to' from your account
	*/
	function transfer(address _to, uint256 _value) public returns (bool success) {
		_transfer(msg.sender, _to, _value);
		return true;
	}


	function transferFrom(address _from, address _to, uint256 _value) public return (bool success) {
		require (_value <= allowance[_from][msg.sender]);
		allowance[_from][msg.sender] -= _value;
		_transfer(_from, _to,_value);
		return true;
	}
	
	/**
	* Set allowance for other address
	*
	* Allows '_spender' to spend no more than '_value' tokens on your behalf
	*/
	function approve(address _spender, uint256 _value) public
		returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	/**
	* Set allowance for other adddress and notify
	*
	* Allows '_spender' to spend no more than '_value' tokens on your behalf, and then ping the contract about it
	*
	*/

	function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
		public 
		returns(bool success) {
		tokenRecipient spender = tokenRecipient(_spender);
		if 	(approve(_spender, _value)) {
			spender.receiveApproval(msg.sender,_value,this, _extraData);
			return true;
		}	
	}

	function burn(uint256, _value) public return (bool success){

		require (balanceOf[msg.sender] >= _value);
		balanceOf[msg.sender] -= _value;
		totalSupply -= _value;
		emit Burn(msg.sender, _value);
		return true;
	}
	
}




