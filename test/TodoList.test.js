const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TodoList", function () {
  let todo, alice, bob;

  beforeEach(async () => {
    [alice, bob] = await ethers.getSigners();
    todo = await (await ethers.getContractFactory("TodoList")).deploy();
  });

  it("adds a task", async () => {
    await expect(todo.addTask("Learn Solidity"))
      .to.emit(todo, "TaskAdded")
      .withArgs(alice.address, 0, "Learn Solidity");
    const tasks = await todo.getTasks(alice.address);
    expect(tasks.length).to.equal(1);
    expect(tasks[0].content).to.equal("Learn Solidity");
    expect(tasks[0].completed).to.equal(false);
  });

  it("toggles a task", async () => {
    await todo.addTask("Task");
    await todo.toggleTask(0);
    expect((await todo.getTasks(alice.address))[0].completed).to.equal(true);
    await todo.toggleTask(0);
    expect((await todo.getTasks(alice.address))[0].completed).to.equal(false);
  });

  it("edits a task", async () => {
    await todo.addTask("Old");
    await todo.editTask(0, "New");
    expect((await todo.getTasks(alice.address))[0].content).to.equal("New");
  });

  it("deletes a task and keeps other ids stable", async () => {
    await todo.addTask("A");
    await todo.addTask("B");
    await todo.deleteTask(0);
    const tasks = await todo.getTasks(alice.address);
    expect(tasks.length).to.equal(1);
    expect(tasks[0].id).to.equal(1);
    await expect(todo.toggleTask(0)).to.be.revertedWithCustomError(todo, "TaskNotFound");
  });

  it("keeps each user's list separate", async () => {
    await todo.addTask("Alice task");
    expect((await todo.getTasks(bob.address)).length).to.equal(0);
    await expect(todo.connect(bob).toggleTask(0)).to.be.revertedWithCustomError(todo, "TaskNotFound");
  });

  it("rejects empty and too-long content", async () => {
    await expect(todo.addTask("")).to.be.revertedWithCustomError(todo, "EmptyContent");
    await expect(todo.addTask("x".repeat(281))).to.be.revertedWithCustomError(todo, "ContentTooLong");
  });
});
