// SPDX-License-Identifier: GPLv3
pragma solidity >=0.8.0 <0.9.0;

interface Turnstile {
  function currentCounterId() external view returns (uint256);

  function getTokenId(address) external view returns (uint256);

  function isRegistered(address) external view returns (bool);

  function register(address) external returns (uint256);

  function assign(uint256) external returns (uint256);

  function withdraw(uint256, address, uint256) external returns (uint256);

  function distributeFees(uint256 _tokenId) external payable;
}
