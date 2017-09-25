pragma solidity ^0.4.17;


contract SellOrderBook {

    struct Order {
        address owner;      // Who made the order.
        uint128 amount;     // How much is being sold.
        uint128 price;      // Price per unit in the other currency.
    }

    mapping (bytes32 => Order) orders;
    mapping (address => uint) accountNextNonce;
    
    bytes32[] orderIds;

    event OrderPlaced(bytes32 indexed orderId, address indexed owner, uint amount, uint price);
    event OrderRemoved(bytes32 indexed orderId);

    modifier isOwner(bytes32 orderId) {
        require (orders[orderId].owner == msg.sender);
        _;
    }

    function placeOrder(uint price) external payable returns (bytes32 orderId) {
        // Generate the orderId.
        orderId = keccak256(msg.sender, accountNextNonce[msg.sender]++);
        // Create the order.
        orders[orderId] = Order({
            owner: msg.sender,
            amount: uint128(msg.value),
            price: uint128(price)
        });
        // Put the order in the order book.
        orderIds.push(orderId);
        // Log the order.
        OrderPlaced(orderId, msg.sender, msg.value, price);
    }

    function removeOrder(bytes32 orderId) external isOwner(orderId) {
        // Get the order amount.
        uint amount = orders[orderId].amount;
        // Delete the order;
        delete orders[orderId];
        // Find the orderId slot.
        for (uint i = 0; orderIds[i] != orderId; i++) {}
        // Replace it with the orderId from the last slot.
        orderIds[i] = orderIds[orderIds.length - 1];
        orderIds.length--; // does it free up the last slot automatically?
        // Return the funds.
        msg.sender.transfer(amount);
        // Log the removal.
        OrderRemoved(orderId);
    }

    function getOrderBookLength() external view returns (uint) {
        return orderIds.length;
    }

    function getOrderBook() external view returns (bytes32[]) {
        return orderIds;
    }
    
    function getOrder(bytes32 orderId) external view returns (address owner, uint amount, uint price) {
        Order storage order = orders[orderId];
        owner = order.owner;
        amount = order.amount;
        price = order.price;
    }

}
