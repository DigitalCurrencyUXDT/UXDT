// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ABDKMath64x64.sol";

contract DigitalCurrency is ERC20 {
    event e_buy(address msgsender, uint256 amount);
    event e_sell(address msgsender, uint256 amount);

    address public immutable USD;
    uint256 public constant ONE_USD = 1 ether;
    uint256 public immutable launchTime;
    
    constructor(uint256 launchtime, address usd) ERC20 ('Digital Currency', 'UXDT') {
        launchTime = launchtime;
        USD = usd;
    }

    function getPrice() public view returns (uint256) {
        uint256 Timegose = block.timestamp - launchTime;
        
        /**
         * Prevent overflow after 90 years
         */
        if(Timegose >= 2838240000) return 6427862156224973310188848242757820198;
        
        /**
         * The price of UXDT at every moment is 1.618x times that of a year ago
         *   y = 1.618^(Timegose / 365 days)
         */
        int128 Base = ABDKMath64x64.div(ABDKMath64x64.fromUInt(1618), ABDKMath64x64.fromUInt(1000));
        int128 Exponential = ABDKMath64x64.div(ABDKMath64x64.fromUInt(Timegose), ABDKMath64x64.fromUInt(365 days));
      
        /**
         * Basic logarithm rule:
         *   x = a^(log_a(x))
         * And deduce it:
         *   x^y = a^(y*log_a(x))
         * When a equals 2
         *   x^y = 2^(y*log_2(x))
         */
        return ABDKMath64x64.mulu(ABDKMath64x64.exp_2(ABDKMath64x64.mul(Exponential, ABDKMath64x64.log_2(Base))), 1 ether);
    }

    function Buy(uint256 usd) external returns (bool) {
        IERC20(USD).transferFrom(msg.sender, address(this), usd);

        uint256 UXDT = 1 ether * usd / getPrice();
        _mint(msg.sender, UXDT);

        emit e_buy(msg.sender, usd);

        return true;
    }

    function Sell(uint256 uxdt) external returns (bool) {
        _burn(msg.sender, uxdt);

        uint256 _USD = uxdt * getPrice() / 1 ether;

        IERC20(USD).transfer(msg.sender, _USD);

        emit e_sell(msg.sender, uxdt);

        return true;
    }
}