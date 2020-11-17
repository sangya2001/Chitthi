import React, { createContext, useEffect, useReducer } from 'react';
import loadChitthi from "../Utils/LoadContract"
import loadWeb3 from "../Utils/LoadWeb3"
import { chainDataReducer } from '../Reducers/ChainDataReducer'

export const chainContext = createContext();

// component starts from here
const ChainContext = (props) => {
    const [chainData, dispatchChainData] = useReducer(chainDataReducer, {
        account: '',
        contract: null
    })
    
    useEffect(() => {
        if (chainData.account === '') {
            loadWeb3().then(res => {
                dispatchChainData({
                    type: 'ACCOUNT',
                    payload: {
                        account: res
                    }
                })
            });
        }

        if (chainData.contract === null) {
            loadChitthi().then(res => {
                dispatchChainData({
                    type: 'CONTRACT',
                    payload: {
                        contract: res
                    }
                })
            })
        }
    }, [])

    return (
        <chainContext.Provider value={chainData}>
            {props.children}
        </chainContext.Provider>
    );
}

export default ChainContext;
