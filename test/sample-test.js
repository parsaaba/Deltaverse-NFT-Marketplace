describe("NFTMarket", function() {
  it("Should create and execute collection functionality", async function() {
    const Collection = await ethers.getContractFactory("Collection")
    const collection = await Collection.deploy()
    await collection.deployed()

    await collection.createCollection("image1", 1)
    await collection.createCollection("image2", 2)

    const collections = await collection.fetchAllCollection(2, 1)
    console.log(collections);
    const myCollections = await collection.fetchAllCollection(2, 1)
    console.log(myCollections);
    const categoryCollection = await collection.fetchCategoryCollection(1, 2, 1)
    console.log(categoryCollection);
  })
})
