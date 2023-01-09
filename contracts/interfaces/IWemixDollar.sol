// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IWemixDollar is IERC20 {
    /* =========== STATE VARIABLES ===========*/

    function isWhitelist(address _whitelist) external view returns (uint256);

    /* =========== FUNCTIONS ===========*/

    function mint(address _to, uint256 _amount) external;

    function burn(address _from, uint256 _amount) external;

    function addPool(
        string calldata _poolName,
        address[] calldata _whitelists,
        address _owner,
        address _ownerSetter,
        address _breaker,
        address _breakerSetter,
        bool _stop
    ) external;

    function addPoolWhitelist(uint256 _poolId, address _whitelist) external;

    function removePoolWhitelist(uint256 _poolId, address _whitelist) external;

    function replacePoolWhitelist(
        uint256 _poolId,
        address _whitelist,
        address _newWhitelist
    ) external;

    function setPoolOwner(uint256 _poolId, address _owner) external;

    function setPoolOwnerSetter(uint256 _poolId, address _ownerSetter) external;

    function setPoolBreaker(uint256 _poolId, address _breaker) external;

    function setPoolBreakerSetter(
        uint256 _poolId,
        address _breakerSetter
    ) external;

    function stopContract(uint256 _poolId) external;

    function resumeContract(uint256 _poolId) external;

    /* =========== VEIW FUNCTIONS ===========*/

    function getWemixDollarInfo(
        uint256 _poolId
    )
        external
        view
        returns (
            uint256,
            string memory,
            uint256,
            address[] memory,
            address,
            address,
            address,
            address,
            bool
        );

    function getWemixDollarInfoCount() external view returns (uint256);

    function getWhitelistAddress(
        uint256 _poolId
    ) external view returns (address[] memory);

    function getWhitelistAddressCount(
        uint256 _poolId
    ) external view returns (uint256);

    /* =========== EVENT ===========*/

    event WemixDollarMinted(address to, uint256 amount, uint256 poolId);
    event WemixDollarBurned(address from, uint256 amount, uint256 poolId);

    event AddPool(
        uint256 poolId,
        string poolName,
        address[] whitelists,
        address owner,
        address ownerSetter,
        address breaker,
        address breakerSetter,
        bool stop
    );

    event AddPoolWhitelist(uint256 poolId, address whitelist);
    event RemovePoolWhitelist(uint256 poolId, address whitelist);

    event SetPoolOwner(uint256 poolId, address owner);
    event SetPoolOwnerSetter(uint256 poolId, address ownerSetter);

    event SetPoolBreaker(uint256 poolId, address breaker);
    event SetPoolBreakerSetter(uint256 poolId, address breakerSetter);

    event StopContract(uint256 poolId);
    event ResumeContract(uint256 poolId);
}
