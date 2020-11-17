import Web3 from "web3";

export default async function loadWeb3(){
    var { ethereum, web3 } = window;

    if (ethereum) {
        await ethereum.request({ method: "eth_requestAccounts" });
        ethereum.autoRefreshOnNetworkChange = false;
    } else if (web3) {
        web3 = new Web3(web3.currentProvider);
    } else {
        window.alert("Hey, Seems you're using non supporting browser, consider using Metamask wallet or Mist Browser.🦊");
    }

    const accounts = await ethereum.request({ method: "eth_accounts" });
    return accounts[0];
}