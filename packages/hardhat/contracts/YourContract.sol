//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";
// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A ERC721 smart contract that allows changing a state variable of the contract and tracking the changes
 * It is also able to call the functions of the turnstile contract
 * It also allows the owner to withdraw the Ether in the contract
 * @author CantoStarterTeam
 */
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Turnstile.sol";

contract YourContract is ERC721, Ownable {
  // State Variables
  string public greeting = "Building Unstoppable CANTO Apps!!!";
  bool public premium = false;
  uint256 public totalCounter = 0;
  mapping(address => uint) public userGreetingCounter;

  string private constant TOKEN_URI = "ipfs://QmUF4sMY4MHMU8anx7CQCUG2Ddv3dTUCYzfcHT5qLNxVFm";
  uint256 private tokenCounter;

  // Testnet Turnstile Contract: 0xEcf044C5B4b867CFda001101c617eCd347095B44
  // Mainnet Turnstile Contract:0xEcf044C5B4b867CFda001101c617eCd347095B44
  Turnstile turnstile = Turnstile(0xEcf044C5B4b867CFda001101c617eCd347095B44);

  // Events: a way to emit log statements from smart contract that can be listened to by external parties
  event GreetingChange(address greetingSetter, string newGreeting, bool premium, uint256 value);
  event NftMinted(uint256 tokenId);

  constructor() ERC721("CantoStarter", "CST") {
    tokenCounter = 0;
  }

  function setGreeting(string memory _newGreeting) public payable {
    // Print data to the hardhat chain console. Remove when deploying to a live network.
    console.log("Setting new greeting '%s' from %s", _newGreeting, msg.sender);

    // Change state variables
    greeting = _newGreeting;
    totalCounter += 1;
    userGreetingCounter[msg.sender] += 1;

    // msg.value: built-in global variable that represents the amount of ether sent with the transaction
    if (msg.value > 0) {
      premium = true;
    } else {
      premium = false;
    }

    // emit: keyword used to trigger an event
    emit GreetingChange(msg.sender, _newGreeting, msg.value > 0, 0);
  }

  function mintNft() public returns (uint256) {
    _safeMint(msg.sender, tokenCounter);
    emit NftMinted(tokenCounter);
    tokenCounter = tokenCounter + 1;
    return tokenCounter;
  }

  // NFT Functions
  function tokenURI(uint256 /*tokenId*/) public view override returns (/*tokenId*/ string memory) {
    // require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    return TOKEN_URI;
  }

  function getTokenCounter() public view returns (uint256) {
    return tokenCounter;
  }

  // Turnstile Functions
  function getTokenIdTurnstile() public view returns (uint256) {
    if (isRegisteredToTurnstile()) return turnstile.getTokenId(address(this));
  }

  function isRegisteredToTurnstile() public view returns (bool) {
    return turnstile.isRegistered(address(this));
  }

  function registerToTurnstile(address _recipient) public onlyOwner returns (uint256 tokenId) {
    return turnstile.register(_recipient);
  }

  function assignTurnstile(uint256 _tokenId) public returns (uint256) {
    return turnstile.assign(_tokenId);
  }

  function withdrawFromTurnstile(address payable _recipient, uint256 _amount) public onlyOwner returns (uint256) {
    uint256 _tokenId;
    if (isRegisteredToTurnstile()) {
      _tokenId = getTokenIdTurnstile();
    }
    return turnstile.withdraw(_tokenId, _recipient, _amount);
  }

  function turnstileBalance() public view returns (uint256) {
    if (isRegisteredToTurnstile()) return turnstile.balances(getTokenIdTurnstile());
  }

  function withdraw() public onlyOwner {
    (bool success, ) = address(msg.sender).call{value: address(this).balance}("");
    require(success, "Failed to send canto");
  }

  receive() external payable {}
}
