export const chainDataReducer = (state, action) => {
    if (action.type === 'ACCOUNT') {
        return {
            account: action.payload.account,
            contract: state.contract
        }
    }
    else if (action.type === 'CONTRACT') {
        return {
            account: state.account,
            contract: action.payload.contract,
        }
    }
}