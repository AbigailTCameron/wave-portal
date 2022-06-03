async function main() {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    console.log("Contract address:", waveContract.address);

    /*
    * Get Contract balance
    */
    let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
    );
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    /**
     * Let's send a few waves!
     */
    let waveTxn = await waveContract.wave("A message!");
    await waveTxn.wait(); // Wait for the transaction to be mined

    /*
    * Get Contract balance to see what happened!
    */
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));


    const [_, randomPerson] = await hre.ethers.getSigners();
    waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
    await waveTxn.wait(); // Wait for the transaction to be mined

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    let pokeCount;
    pokeCount = await waveContract.getTotalPokes();
    console.log(pokeCount.toNumber());

    await waveContract.addFriends(randomPerson.address);
    let pokeTxn = await waveContract.connect(randomPerson).poke("Another message!");
    await pokeTxn.wait(); // Wait for the transaction to be mined

    /*
    * Get Contract balance to see what happened!
    */
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

    let allPokes = await waveContract.getAllPokes();
    console.log(allPokes);

    pokeCount = await waveContract.getTotalPokes();
    console.log(pokeCount.toNumber());

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
});