import { createAlchemyWeb3 } from "@alch/alchemy-web3";
import contract from "../Build/Chitthi.json";

export default async function loadMoviefy() {
    const { REACT_APP_API_KEY, REACT_APP_CONTRACT_ADDRESS } = process.env;
    console.log(REACT_APP_API_KEY)
    // setup contract
    const alchWeb3 = createAlchemyWeb3(REACT_APP_API_KEY);

    const chitthiContract = new alchWeb3.eth.Contract(
        contract.abi,
        REACT_APP_CONTRACT_ADDRESS
    );

    return chitthiContract;
}