// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TodoList
/// @notice A personal to-do list stored on-chain. Every wallet has its own list.
///         Note: blockchain data is public, so never store secrets here.
contract TodoList {
    struct Task {
        uint256 id;
        string content;
        bool completed;
        bool deleted;
        uint256 createdAt;
    }

    uint256 public constant MAX_LENGTH = 280;

    // user => taskId => Task
    mapping(address => mapping(uint256 => Task)) private _tasks;
    // user => number of tasks ever created (also the next id)
    mapping(address => uint256) private _taskCount;

    event TaskAdded(address indexed user, uint256 indexed id, string content);
    event TaskToggled(address indexed user, uint256 indexed id, bool completed);
    event TaskEdited(address indexed user, uint256 indexed id, string content);
    event TaskDeleted(address indexed user, uint256 indexed id);

    error EmptyContent();
    error ContentTooLong();
    error TaskNotFound();

    modifier validContent(string calldata content) {
        uint256 len = bytes(content).length;
        if (len == 0) revert EmptyContent();
        if (len > MAX_LENGTH) revert ContentTooLong();
        _;
    }

    modifier taskExists(uint256 id) {
        if (id >= _taskCount[msg.sender] || _tasks[msg.sender][id].deleted) revert TaskNotFound();
        _;
    }

    /// @notice Add a new task to your list.
    function addTask(string calldata content) external validContent(content) returns (uint256 id) {
        id = _taskCount[msg.sender]++;
        _tasks[msg.sender][id] = Task(id, content, false, false, block.timestamp);
        emit TaskAdded(msg.sender, id, content);
    }

    /// @notice Mark a task done, or undo it.
    function toggleTask(uint256 id) external taskExists(id) {
        Task storage t = _tasks[msg.sender][id];
        t.completed = !t.completed;
        emit TaskToggled(msg.sender, id, t.completed);
    }

    /// @notice Change the text of a task.
    function editTask(uint256 id, string calldata content) external taskExists(id) validContent(content) {
        _tasks[msg.sender][id].content = content;
        emit TaskEdited(msg.sender, id, content);
    }

    /// @notice Delete a task (hidden from your list; history stays in past transactions).
    function deleteTask(uint256 id) external taskExists(id) {
        _tasks[msg.sender][id].deleted = true;
        emit TaskDeleted(msg.sender, id);
    }

    /// @notice All non-deleted tasks of `user`.
    function getTasks(address user) external view returns (Task[] memory) {
        uint256 total = _taskCount[user];
        uint256 active;
        for (uint256 i = 0; i < total; i++) {
            if (!_tasks[user][i].deleted) active++;
        }
        Task[] memory result = new Task[](active);
        uint256 j;
        for (uint256 i = 0; i < total; i++) {
            if (!_tasks[user][i].deleted) result[j++] = _tasks[user][i];
        }
        return result;
    }
}
