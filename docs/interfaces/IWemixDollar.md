## `IWemixDollar`






### `isWhitelist(address _whitelist) → uint256` (external)





### `mint(address _to, uint256 _amount)` (external)





### `burn(address _from, uint256 _amount)` (external)





### `addPool(string _poolName, address[] _whitelists, address _owner, address _ownerSetter, address _breaker, address _breakerSetter, bool _stop)` (external)





### `addPoolWhitelist(uint256 _poolId, address _whitelist)` (external)





### `removePoolWhitelist(uint256 _poolId, address _whitelist)` (external)





### `replacePoolWhitelist(uint256 _poolId, address _whitelist, address _newWhitelist)` (external)





### `setPoolOwner(uint256 _poolId, address _owner)` (external)





### `setPoolOwnerSetter(uint256 _poolId, address _ownerSetter)` (external)





### `setPoolBreaker(uint256 _poolId, address _breaker)` (external)





### `setPoolBreakerSetter(uint256 _poolId, address _breakerSetter)` (external)





### `stopContract(uint256 _poolId)` (external)





### `resumeContract(uint256 _poolId)` (external)





### `getWemixDollarInfo(uint256 _poolId) → uint256, string, uint256, address[], address, address, address, address, bool` (external)





### `getWemixDollarInfoCount() → uint256` (external)





### `getWhitelistAddress(uint256 _poolId) → address[]` (external)





### `getWhitelistAddressCount(uint256 _poolId) → uint256` (external)






### `WemixDollarMinted(address to, uint256 amount, uint256 poolId)`





### `WemixDollarBurned(address from, uint256 amount, uint256 poolId)`





### `AddPool(uint256 poolId, string poolName, address[] whitelists, address owner, address ownerSetter, address breaker, address breakerSetter, bool stop)`





### `AddPoolWhitelist(uint256 poolId, address whitelist)`





### `RemovePoolWhitelist(uint256 poolId, address whitelist)`





### `SetPoolOwner(uint256 poolId, address owner)`





### `SetPoolOwnerSetter(uint256 poolId, address ownerSetter)`





### `SetPoolBreaker(uint256 poolId, address breaker)`





### `SetPoolBreakerSetter(uint256 poolId, address breakerSetter)`





### `StopContract(uint256 poolId)`





### `ResumeContract(uint256 poolId)`





