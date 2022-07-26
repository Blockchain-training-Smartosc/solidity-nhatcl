// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "./IERC20.sol";

contract SampleToken is IERC20 {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    address public admin;

    constructor() {
        _balances[msg.sender] = 1000000;
        _totalSupply = 1000000;
        admin = msg.sender;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        address owner = msg.sender;
        _transfer(owner, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        address spender = msg.sender;
        require(
            _allowances[sender][spender] >= amount,
            "ERC20: transfer amount exceeds approval"
        );
        _transfer(sender, recipient, amount);
        _allowances[sender][spender] -= amount;
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "ERC20: amount should greater than zero");
        require(
            _balances[from] >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    modifier onlyOwner() {
        require(admin == msg.sender, "ERC20: sender must be owner");
        _;
    }

    function mint(address receiver, uint256 amount) external onlyOwner {
        require(receiver != address(0), "ERC20: mint to the zero address");
        require(amount > 0, "ERC20: amount should greater than zero");
        _totalSupply += amount;
        _balances[receiver] += amount;
        emit Transfer(address(0), receiver, amount);
    }

    function burn(uint256 amount) external {
        require(
            _balances[msg.sender] >= amount,
            "ERC20: burn amount exceeds balance"
        );
        require(amount > 0, "ERC20: amount should greater than zero");
        _balances[msg.sender] = _balances[msg.sender] - amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
