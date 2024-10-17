// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./TaikoData.sol";

/// @title LibBonds
/// @notice A library that offers helper functions to handle bonds.
/// @custom:security-contact security@taiko.xyz
library LibBonds {
    /// @dev Emitted when token is credited back to a user's bond balance.
    event BondCredited(address indexed user, uint256 amount);

    /// @dev Emitted when token is debited from a user's bond balance.
    event BondDebited(address indexed user, uint256 amount);

    error InsufficientBondBalance();

    /// @dev Deposits Ether to be used as bonds.
    /// @param _state Current TaikoData.State.
    /// @param _amount The amount of token to deposit.
    function depositBond(TaikoData.State storage _state, uint256 _amount) internal {
        _state.bondBalance[msg.sender] += _amount;
    }

    /// @dev Withdraws Ether deposited as bonds.
    /// @param _state Current TaikoData.State.
    /// @param _amount The amount of token to withdraw.
    function withdrawBond(TaikoData.State storage _state, uint256 _amount) internal {
        _state.bondBalance[msg.sender] -= _amount;
    }

    /// @dev Debits Ether as bonds.
    /// @param _state Current TaikoData.State.
    /// @param _user The user address to debit.
    /// @param _amount The amount of token to debit.
    function debitBond(TaikoData.State storage _state, address _user, uint256 _amount) internal {
        uint256 balance = _state.bondBalance[_user];

        if (balance < _amount) {
            revert InsufficientBondBalance();
        }

        unchecked {
            _state.bondBalance[_user] = balance - _amount;
        }
        emit BondDebited(_user, _amount);
    }

    /// @dev Credits Ether to user's bond balance.
    /// @param _state Current TaikoData.State.
    /// @param _user The user address to credit.
    /// @param _amount The amount of token to credit.
    function creditBond(TaikoData.State storage _state, address _user, uint256 _amount) internal {
        _state.bondBalance[_user] += _amount;
        emit BondCredited(_user, _amount);
    }

    /// @dev Gets a user's current Ether bond balance.
    /// @param _state Current TaikoData.State.
    /// @param _user The user address to credit.
    /// @return  The current token balance.
    function bondBalanceOf(
        TaikoData.State storage _state,
        address _user
    )
        internal
        view
        returns (uint256)
    {
        return _state.bondBalance[_user];
    }
}
