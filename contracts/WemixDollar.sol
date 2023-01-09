// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

import "./interfaces/IWemixDollar.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WemixDollar is IWemixDollar, ERC20, Ownable {
    /* =========== STATE VARIABLES ===========*/

    struct WemixDollarInfo {
        uint256 poolId;
        string poolName;
        uint256 poolTotalSupply;
        address[] whitelists;
        address owner;
        address ownerSetter;
        address breaker;
        address breakerSetter;
        bool stop;
    }

    WemixDollarInfo[] public wemixDollarInfos;
    mapping(address => uint256) public isWhitelist;

    /* =========== CONSTRUCTOR =========== */

    constructor() ERC20("WEMIX$", "WEMIX$") Ownable() {
        address[] memory zeroArray = new address[](0);

        wemixDollarInfos.push(
            WemixDollarInfo({
                poolId: 0,
                poolName: "WEMIX$-POOL",
                poolTotalSupply: 0,
                whitelists: zeroArray,
                owner: address(0),
                ownerSetter: address(0),
                breaker: address(0),
                breakerSetter: address(0),
                stop: true
            })
        );
    }

    /* =========== MINT BURN FUNCTIONS =========== */

    /**
     * @notice Issue Wemix Dollars to _to address.
     * @param _to Address to issue wemix dollar.
     * @param _amount Amount of Wemix Dollars to be issued.
     */
    function mint(address _to, uint256 _amount) external isWhitelistAddress {
        uint256 poolId = isWhitelist[msg.sender];
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[poolId];

        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");
        _mint(_to, _amount);

        wemixDollarInfo.poolTotalSupply += _amount;

        emit WemixDollarMinted(_to, _amount, poolId);
    }

    /**
     * @notice Burn Wemix Dollars to _from address.
     * @param _from Address to burn wemix dollar.
     * @param _amount Amount of Wemix Dollars to be burned.
     */
    function burn(address _from, uint256 _amount) external isWhitelistAddress {
        uint256 poolId = isWhitelist[msg.sender];
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[poolId];

        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");
        _burn(_from, _amount);

        wemixDollarInfo.poolTotalSupply -= _amount;

        emit WemixDollarBurned(_from, _amount, poolId);
    }

    /* =========== POOL FUNCTIONS =========== */

    /**
     * @notice Add Pool.
     * @param _poolName Write Pool Name.
     * @param _whitelists Array of Whitelist address.
     * @param _owner Address of Owner.
     * @param _ownerSetter Address of Owner Setter.
     * @param _breaker Address of Breaker.
     * @param _breakerSetter Address of Breaker Setter.
     * @param _stop Emergency or Not.
     */
    function addPool(
        string calldata _poolName,
        address[] calldata _whitelists,
        address _owner,
        address _ownerSetter,
        address _breaker,
        address _breakerSetter,
        bool _stop
    ) external onlyOwner {
        uint256 poolId = wemixDollarInfos.length;

        for (uint256 i = 0; i < _whitelists.length; ) {
            require(
                isWhitelist[_whitelists[i]] == 0,
                "WEMIX$: Address already exists."
            );
            isWhitelist[_whitelists[i]] = poolId;

            unchecked {
                i++;
            }
        }

        wemixDollarInfos.push(
            WemixDollarInfo({
                poolId: poolId,
                poolName: _poolName,
                poolTotalSupply: 0,
                whitelists: _whitelists,
                owner: _owner,
                ownerSetter: _ownerSetter,
                breaker: _breaker,
                breakerSetter: _breakerSetter,
                stop: _stop
            })
        );

        emit AddPool(
            poolId,
            _poolName,
            _whitelists,
            _owner,
            _ownerSetter,
            _breaker,
            _breakerSetter,
            _stop
        );
    }

    /* =========== WHITELIST FUNCTIONS =========== */

    /**
     * @notice Manages whitelist.
     * Whitelisted addresses can access Wemix Dollar Contract.
     * @param _poolId Pool id to add
     * @param _whitelist Whitelist address to add
     */
    function addPoolWhitelist(
        uint256 _poolId,
        address _whitelist
    )
        external
        nonZeroAddress(_whitelist)
        checkPoolExists(_poolId)
        checkNotWhitelistAddress(_whitelist)
    {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.ownerSetter,
            "WEMIX$: Caller is not OwnerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        wemixDollarInfo.whitelists.push(_whitelist);

        isWhitelist[_whitelist] = _poolId;

        emit AddPoolWhitelist(_poolId, _whitelist);
    }

    /**
     * @notice Remove Pool Whitelist.
     * Whitelisted addresses can access Wemix Dollar Contract.
     * @param _poolId Pool Id.
     * @param _whitelist Whitelist address to remove.
     */
    function removePoolWhitelist(
        uint256 _poolId,
        address _whitelist
    )
        external
        nonZeroAddress(_whitelist)
        checkPoolExists(_poolId)
        checkWhitelistAddress(_poolId, _whitelist)
    {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.ownerSetter,
            "WEMIX$: Caller is not OwnerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        for (uint256 i = 0; i < wemixDollarInfo.whitelists.length; ) {
            if (wemixDollarInfo.whitelists[i] == _whitelist) {
                wemixDollarInfo.whitelists[i] = wemixDollarInfo.whitelists[
                    wemixDollarInfo.whitelists.length - 1
                ];
                wemixDollarInfo.whitelists.pop();
                break;
            }
            unchecked {
                i++;
            }
        }

        isWhitelist[_whitelist] = 0;

        emit RemovePoolWhitelist(_poolId, _whitelist);
    }

    /**
     * @notice Replace Pool Whitelist.
     * Whitelisted addresses can access Wemix Dollar Contract.
     * @param _poolId Pool Id.
     * @param _whitelist Whitelist address to remove.
     * @param _newWhitelist Whitelist address to add.
     */
    function replacePoolWhitelist(
        uint256 _poolId,
        address _whitelist,
        address _newWhitelist
    )
        external
        nonZeroAddress(_whitelist)
        nonZeroAddress(_newWhitelist)
        checkWhitelistAddress(_poolId, _whitelist)
        checkNotWhitelistAddress(_newWhitelist)
    {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.ownerSetter,
            "WEMIX$: Caller is not OwnerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        for (uint i = 0; i < wemixDollarInfo.whitelists.length; ) {
            if (wemixDollarInfo.whitelists[i] == _whitelist) {
                wemixDollarInfo.whitelists[i] = _newWhitelist;
                break;
            }
            unchecked {
                i++;
            }
        }

        isWhitelist[_whitelist] = 0;
        isWhitelist[_newWhitelist] = _poolId;

        emit AddPoolWhitelist(_poolId, _newWhitelist);
        emit RemovePoolWhitelist(_poolId, _whitelist);
    }

    /* =========== SET FUNCTIONS =========== */

    /**
     * @notice Set Pool Owner.
     * @param _poolId Pool Id.
     * @param _owner Address of Owner.
     */
    function setPoolOwner(
        uint256 _poolId,
        address _owner
    ) external nonZeroAddress(_owner) checkPoolExists(_poolId) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.ownerSetter,
            "WEMIX$: Caller is not OwnerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        wemixDollarInfo.owner = _owner;

        emit SetPoolOwner(_poolId, _owner);
    }

    /**
     * @notice Set Pool Owner Setter.
     * @param _poolId Pool Id.
     * @param _ownerSetter Address of Owner Setter.
     */
    function setPoolOwnerSetter(
        uint256 _poolId,
        address _ownerSetter
    ) external nonZeroAddress(_ownerSetter) checkPoolExists(_poolId) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.ownerSetter,
            "WEMIX$: Caller is not OwnerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        wemixDollarInfo.ownerSetter = _ownerSetter;

        emit SetPoolOwnerSetter(_poolId, _ownerSetter);
    }

    /**
     * @notice Set Pool Breaker.
     * @param _poolId Pool Id.
     * @param _breaker Address of Breaker.
     */
    function setPoolBreaker(
        uint256 _poolId,
        address _breaker
    ) external nonZeroAddress(_breaker) checkPoolExists(_poolId) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.breakerSetter,
            "WEMIX$: Caller is not BreakerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        wemixDollarInfo.breaker = _breaker;

        emit SetPoolBreaker(_poolId, _breaker);
    }

    /**
     * @notice Set Pool Breaker Setter.
     * @param _poolId Pool Id.
     * @param _breakerSetter Address of Breaker Setter.
     */
    function setPoolBreakerSetter(
        uint256 _poolId,
        address _breakerSetter
    ) external nonZeroAddress(_breakerSetter) checkPoolExists(_poolId) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.breakerSetter,
            "WEMIX$: Caller is not BreakerSetter."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        wemixDollarInfo.breakerSetter = _breakerSetter;

        emit SetPoolBreakerSetter(_poolId, _breakerSetter);
    }

    /* =========== BREAKE FUNCTIONS =========== */

    /**
     * @notice Stop DIOS contract.
     * @param _poolId Pool Id.
     */
    function stopContract(uint256 _poolId) external checkPoolExists(_poolId) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.breaker,
            "WEMIX$: Caller is not Breaker."
        );
        require(wemixDollarInfo.stop == false, "WEMIX$: EMERGENCY!");

        wemixDollarInfo.stop = true;

        emit StopContract(_poolId);
    }

    /**
     * @notice Resume DIOS contract.
     * @param _poolId Pool Id.
     */
    function resumeContract(uint256 _poolId) external checkPoolExists(_poolId) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        require(
            msg.sender == wemixDollarInfo.breaker,
            "WEMIX$: Caller is not Breaker."
        );
        require(wemixDollarInfo.stop == true, "WEMIX$: NOT EMERGENCY!");

        wemixDollarInfo.stop = false;

        emit ResumeContract(_poolId);
    }

    /* ========== VIEW FUNCTION ========== */

    /**
     * @notice Get Wemix Dollar Infomation.
     * @param _poolId Pool Id.
     */
    function getWemixDollarInfo(
        uint256 _poolId
    )
        public
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
        )
    {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        return (
            wemixDollarInfo.poolId,
            wemixDollarInfo.poolName,
            wemixDollarInfo.poolTotalSupply,
            wemixDollarInfo.whitelists,
            wemixDollarInfo.owner,
            wemixDollarInfo.ownerSetter,
            wemixDollarInfo.breaker,
            wemixDollarInfo.breakerSetter,
            wemixDollarInfo.stop
        );
    }

    /**
     * @notice Get Wemix Dollar Infomation Count.
     */
    function getWemixDollarInfoCount() public view returns (uint256) {
        return wemixDollarInfos.length;
    }

    /**
     * @notice Get Whitelist Address.
     * @param _poolId Pool Id.
     */
    function getWhitelistAddress(
        uint256 _poolId
    ) public view returns (address[] memory) {
        WemixDollarInfo storage wemixDollarInfo = wemixDollarInfos[_poolId];

        return wemixDollarInfo.whitelists;
    }

    /**
     * @notice Get Whitelist Address Count.
     * @param _poolId Pool Id.
     */
    function getWhitelistAddressCount(
        uint256 _poolId
    ) public view returns (uint256) {
        WemixDollarInfo memory wemixDollarInfo = wemixDollarInfos[_poolId];

        return wemixDollarInfo.whitelists.length;
    }

    /* =========== MODIFIERS =========== */

    modifier nonZeroAddress(address dollarInAndOutStaking) {
        require(
            dollarInAndOutStaking != address(0),
            "WEMIX$: DIOS Address cannot be 0."
        );
        _;
    }

    modifier checkPoolExists(uint256 poolId) {
        require(poolId != uint256(0), "WEMIX$: poolId cannot be 0.");
        require(
            wemixDollarInfos.length >= poolId,
            "WEMIX$: WemixDollarInfos length must be greater than or equal to poolId"
        );
        _;
    }

    modifier isWhitelistAddress() {
        require(
            isWhitelist[msg.sender] != 0,
            "WEMIX$: Address does not exist."
        );
        _;
    }

    modifier checkWhitelistAddress(uint256 poolId, address whitelist) {
        require(
            isWhitelist[whitelist] == poolId,
            "WEMIX$: Address does not exist."
        );
        _;
    }

    modifier checkNotWhitelistAddress(address whitelist) {
        require(isWhitelist[whitelist] == 0, "WEMIX$: Address already exists.");
        _;
    }
}
