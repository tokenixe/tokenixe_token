// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Tokenixe is ERC20, AccessControl, Pausable {
  using SafeMath for uint256;

  uint256 internal _maxAmountMintable = 500_000_000e18;

  constructor() ERC20("Tokenixe", "NXE") {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }

  modifier onlyAdminRole() {
    require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "!admin");
    _;
  }

  function transferOwnership(address newOwner) public onlyAdminRole {
    revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
    grantRole(DEFAULT_ADMIN_ROLE, newOwner);
  }

  function mint(
    address _to,
    uint256 _amount
  ) public onlyAdminRole whenNotPaused {
    require(
      ERC20.totalSupply().add(_amount) <= _maxAmountMintable,
      "Max mintable exceeded"
    );
    super._mint(_to, _amount);
  }

  function transfer(
    address recipient,
    uint256 amount
  ) public virtual override returns (bool) {
    super.transfer(recipient, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public virtual override returns (bool) {
    super.transferFrom(sender, recipient, amount);
    return true;
  }

  function pause() external onlyAdminRole {
    super._pause();
  }

  function unpause() external onlyAdminRole {
    super._unpause();
  }
}
