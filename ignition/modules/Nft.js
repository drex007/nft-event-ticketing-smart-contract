const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const dotenv = require('dotenv')
dotenv.config()

const EVENT_FEE = process.env.EVENT_FEE || ""
console.log(EVENT_FEE);

module.exports = buildModule("NftTicketingModule", (m) => {
    const eventFee = m.getParameter("eventFee", EVENT_FEE); // Set constructor params

    const nftTicketContract = m.contract("NftTicketing", [eventFee]); // attach params to module contract instance
    console.log('Building module ......');

    return { nftTicketContract };
});
