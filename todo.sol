// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


contract Todo{
    address public owner;
    uint public taskNo ;
    mapping(uint => string) public Tasks ;
    mapping(uint => bool) public completedTask;
    event taskAdded(string task) ;
    event taskCompleted(string task);

    constructor() {
        owner = msg.sender ; 
    }

    modifier onlyOwner() {
        require(msg.sender==owner, "caller is not owner") ;
        _; 
    } 

    function addTask(string calldata _task, uint _taskNo) public onlyOwner {
        taskNo = _taskNo ;
        Tasks[taskNo] = _task ;
        completedTask[taskNo] = false ;
        emit taskAdded(_task);
    }

    function completeTask(uint _taskNo ) public onlyOwner {
        taskNo = _taskNo ;
        completedTask[taskNo] = true ;
        string memory task_ = Tasks[taskNo] ;
        emit taskCompleted(task_);
    }

    function getTask(uint _taskNo) public view returns(string memory task){
        return Tasks[_taskNo] ;
    }
}
