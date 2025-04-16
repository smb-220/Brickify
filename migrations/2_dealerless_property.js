
const DealerlessMarket = artifacts.require("BrickifyMarket");
module.exports = function(deployer) {
  deployer.deploy(DealerlessMarket)
  .then(async (contract) => {
    await contract.registerLand('{"name":"Taj Mahal, Agra","image":"https://www.google.com/search?q=Taj+Mahal+Agra&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi_mJ-Knp7gAhVRfisKHU4pB7IQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Gateway of India, Mumbai","image":"https://www.google.com/search?q=Gateway+of+India+Mumbai&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjW8dHknp7gAhUDoFkKHb2IAfQQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Qutub Minar, Delhi","image":"https://www.google.com/search?q=Qutub+Minar+Delhi&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi12evCn57gAhXfi8MKHcPoD9IQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Sundarbans Mangrove Forest, West Bengal","image":"https://www.google.com/search?q=Sundarbans+Mangrove+Forest+West+Bengal&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi5-PTqnp7gAhWVfisKHTtnBdgQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Jaisalmer Fort, Rajasthan","image":"https://www.google.com/search?q=Jaisalmer+Fort+Rajasthan&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi94J7Ln57gAhUBfisKHf84CKYQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Kumarakom Backwaters, Kerala","image":"https://www.google.com/search?q=Kumarakom+Backwaters+Kerala&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwj5sJ71np7gAhXmi9MKHcZUD2QQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Hampi Ruins, Karnataka","image":"https://www.google.com/search?q=Hampi+Ruins+Karnataka&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjV4bW5np7gAhWFi9MKHTntC_0Q_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Meghalaya Hills, Meghalaya","image":"https://www.google.com/search?q=Meghalaya+Hills&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi36ZySnp7gAhXsfisKHSg7BnkQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Golden Temple, Amritsar","image":"https://www.google.com/search?q=Golden+Temple+Amritsar&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjc9Zybnp7gAhWDoFkKHXsfCkQQ_AUIDigB&biw=1366&bih=657"}');
    await contract.registerLand('{"name":"Ranthambore National Park, Rajasthan","image":"https://www.google.com/search?q=Ranthambore+National+Park+Rajasthan&rlz=1C1GCEU_enIN832IN832&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjHl5z6np7gAhV3fisKHdTqDX0Q_AUIDigB&biw=1366&bih=657"}');
  });
};