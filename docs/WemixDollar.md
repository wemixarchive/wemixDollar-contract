## `WemixDollar`





### `nonZeroAddress(address dollarInAndOutStaking)`





### `checkPoolExists(uint256 poolId)`





### `isWhitelistAddress()`





### `checkWhitelistAddress(uint256 poolId, address whitelist)`





### `checkNotWhitelistAddress(address whitelist)`






### `mint(address _to, uint256 _amount)` (external)

Issue Wemix Dollars to _to address.




### `burn(address _from, uint256 _amount)` (external)

Burn Wemix Dollars to _from address.




### `addPool(string _poolName, address[] _whitelists, address _owner, address _ownerSetter, address _breaker, address _breakerSetter, bool _stop)` (external)

Add Pool.




### `addPoolWhitelist(uint256 _poolId, address _whitelist)` (external)

Manages whitelist.
Whitelisted addresses can access Wemix Dollar Contract.




### `removePoolWhitelist(uint256 _poolId, address _whitelist)` (external)

Remove Pool Whitelist.
Whitelisted addresses can access Wemix Dollar Contract.




### `replacePoolWhitelist(uint256 _poolId, address _whitelist, address _newWhitelist)` (external)

Replace Pool Whitelist.
Whitelisted addresses can access Wemix Dollar Contract.




### `setPoolOwner(uint256 _poolId, address _owner)` (external)

Set Pool Owner.




### `setPoolOwnerSetter(uint256 _poolId, address _ownerSetter)` (external)

Set Pool Owner Setter.




### `setPoolBreaker(uint256 _poolId, address _breaker)` (external)

Set Pool Breaker.




### `setPoolBreakerSetter(uint256 _poolId, address _breakerSetter)` (external)

Set Pool Breaker Setter.




### `stopContract(uint256 _poolId)` (external)

Stop DIOS contract.




### `resumeContract(uint256 _poolId)` (external)

Resume DIOS contract.




### `getWemixDollarInfo(uint256 _poolId) → uint256, string, uint256, address[], address, address, address, address, bool` (public)

Get Wemix Dollar Infomation.




### `getWemixDollarInfoCount() → uint256` (public)

Get Wemix Dollar Infomation Count.



### `getWhitelistAddress(uint256 _poolId) → address[]` (public)

Get Whitelist Address.




### `getWhitelistAddressCount(uint256 _poolId) → uint256` (public)

Get Whitelist Address Count.





