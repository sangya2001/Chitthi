pragma solidity ^0.5.0 <0.7.0;

contract Chitthi{
    // Cache - This cache is used since updateRequest needs byte value to operate
    bytes trueValue = "true";
    bytes falseValue = "false";
    
    function getTrueByte() public view returns(bytes memory){
        return trueValue;
    }
    
    function getFalseByte() public view returns(bytes memory){
        return falseValue;
    }
    
    // ---------------------------Structs-------------------------------------//
    
    struct User{
        string userName;
        address userAddress;
    }
    
    struct Message{
        address messageFrom;
        string message;
    }

    struct Friend{
        address friendAddress;
        bool isBlocked;
    }
 
    struct FriendRequest{
        address requestFrom;
        bytes status;
    }
    
    // ---------------------------Mappings--------------------------------------//

    mapping (address => User) public users;

    // Below the mapping are nested mapping so it functions like 3d array
    uint256 private messageCount = 0;
    mapping (address => mapping(uint256 => Message)) public messages;

    uint256 private friendCount = 0;
    mapping (address => mapping(uint256 => Friend)) public friends;

    uint256 private requestCount = 0;
    mapping (address => mapping(uint256 => FriendRequest)) public friendRequests;
    
    //------------------------------Events---------------------------------------//
    
    //Events to describe what happened
    event userAdded(
        string userName,
        address userAddress
    );
    
    event messageTransfered(
        address messageFrom,
        string message
    );
    
    event friendAdded(
        address friendAddress,
        bool isBlocked
    );
    
    event friendRequestSent(
        address requestFrom,
        bytes status
    );
    
    event friendRequestUpdated(
        address requestFrom,
        bytes status
    );
    
    // -------------------------Function Modifiers-------------------------------//
    
    // 1. Check if user or not
    modifier isUser{
        require(users[msg.sender].userAddress != address(0x0), "Current wallet owner is not an user!");
        _;
    }
    
    // 2. Middleware for new user
    modifier newUserMiddleware(address _userAddress, string memory _userName) {
        require(bytes(_userName).length > 0, 'Username can\'t be null!');
        require(_userAddress != address(0x0), 'User Address can\'t be null!');
        require(msg.sender != address(0x0), 'Wallet not detected!');
        _;
    }
    
    // 3. Middleware for sending Message
    modifier newMessageMiddleware(address _toAddress, string memory _message){
        require(users[_toAddress].userAddress != address(0x0), "Receiver is not an user!");
        require(_toAddress != address(0x0), 'Receiver\'s Address can\'t be null!');
        require(bytes(_message).length > 0, 'Message can\'t be null!');
        require(msg.sender != address(0x0), 'Wallet not detected!');
        
        // check if _toAddress is friend or not
        bool isFriend = false;
        for(uint256 i = 1; i <= friendCount; i++){
            if(friends[msg.sender][i].friendAddress == _toAddress){
                isFriend = true;
            }
        }
        
        require(isFriend, "User is not a friend!");
        _;
    }
    
    // 4. Middleware for sending friend request
    modifier newFriendRequestMiddleware(address _requestReceiver){
        require(users[_requestReceiver].userAddress != address(0x0), "Request receiver is not an user!");
        _;
    }
    
    // 5. Middleware for adding friend
    modifier addFriendMiddleware(address _requestFrom){
        require(_requestFrom != address(0x0), "Address must not be null!");
        _;
    }
    
    // 6. Middleware for updating friend request
    modifier updateFriendRequestMiddleware(uint256 _requestCount, bytes memory _status){
        require(keccak256(_status) == keccak256("true") || keccak256(_status) == keccak256("false"), "Status must be either true or false!");
        _;
    }
    
    //--------------------------Functions----------------------------------------//
    // 1. Create User
    function addUser(address _userAddress, string memory _userName) newUserMiddleware(_userAddress, _userName) public{
        users[_userAddress] = User(_userName, _userAddress);
        emit userAdded(
             _userName, _userAddress
        );
    }
    
    // 2. Send Message
    function sendMessage(address _toAddress, string memory _message) isUser newMessageMiddleware(_toAddress, _message) public {
        ++messageCount;
        messages[_toAddress][messageCount] = Message(msg.sender, _message);
        emit messageTransfered(
            _toAddress,
            _message
        );
    }
    
    // 3. Send Friend Request
    function sendFriendRequest(address _requestReceiver) isUser newFriendRequestMiddleware(_requestReceiver) public{
        ++requestCount;
        friendRequests[_requestReceiver][requestCount] = FriendRequest(msg.sender, "null");
        emit friendRequestSent(
            msg.sender,
            "null"
        );
    }
    
    // 4. Add friend
    function addFriend(address _requestFrom) isUser addFriendMiddleware(_requestFrom) private{
        ++friendCount;
        friends[msg.sender][friendCount] = Friend(_requestFrom, false);
        
        ++friendCount;
        friends[_requestFrom][friendCount] = Friend(msg.sender, false);
        emit friendAdded(
            _requestFrom,
            false
        );
    }
    
    // 5. update friend request
    function updateFriendRequestStatus(uint256 _requestCount, bytes memory _status) isUser updateFriendRequestMiddleware(_requestCount, _status) public{
        if(keccak256(_status) == keccak256("true")){
            friendRequests[msg.sender][_requestCount].status = "true";    
            emit friendRequestUpdated(
                friendRequests[msg.sender][_requestCount].requestFrom,
                _status
            );
            addFriend(friendRequests[msg.sender][_requestCount].requestFrom);
        }
        if(keccak256(_status) == keccak256("false")){
            friendRequests[msg.sender][_requestCount].status = "false";    
        }
    }
}