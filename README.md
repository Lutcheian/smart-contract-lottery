# Decentralized Raffle Lottery

A decentralized lottery smart contract built with **Solidity, Foundry, and Chainlink VRF V2.5**. The project allows participants to enter a raffle by paying an entrance fee, uses verifiable randomness to select a winner, and automatically transfers the prize to the winner when the raffle is fulfilled.

## Features

- **Decentralized lottery:** Participants enter the raffle by sending ETH.
- **Chainlink VRF V2.5:** Uses verifiable randomness to select a winner fairly and transparently.
- **Automated raffle logic:** Includes `checkUpkeep()` and `performUpkeep()` to determine when a raffle should execute.
- **Automatic prize distribution:** Sends the raffle balance to the selected winner.
- **Raffle state management:** Prevents participants from entering while a winner is being selected.
- **Unit and integration testing:** Uses Foundry to test contract functionality.
- **Sepolia support:** Includes configuration for deployment and testing on Ethereum Sepolia.

## Technology Stack

| Technology | Purpose |
|---|---|
| Solidity 0.8.19 | Smart contract development |
| Foundry | Development, testing and deployment |
| Chainlink VRF V2.5 | Verifiable random number generation |
| Chainlink Automation interface | Raffle upkeep conditions |
| Ethereum Sepolia | Testnet deployment |
| Git | Version control |

## How It Works

1. A participant enters the raffle by calling `enterRaffle()` and paying the required entrance fee.
2. The contract records the participant and emits an event.
3. The `checkUpkeep()` function checks whether the raffle has enough participants, sufficient ETH balance, is open, and has passed the required time interval.
4. When upkeep is triggered, `performUpkeep()` requests random words from Chainlink VRF V2.5.
5. The raffle changes its state to `CALCULATING`, preventing additional entries.
6. Chainlink VRF returns a verifiable random number through `fulfillRandomWords()`.
7. The contract selects a winner, transfers the entire raffle balance, resets the players array, and opens the raffle for the next round.

## Project Structure

```text
smart-conract-lottery-f23/
│
├── src/
│   └── Raffle.sol
│
├── script/
│   ├── DeployRaffle.s.sol
│   ├── HelperConfig.s.sol
│   └── Interactions.s.sol
│
├── test/
│   ├── mocks/
│   │   └── LinkToken.sol
│   │
│   ├── uint/
│   │   └── RaffleTest.t.sol
│   │
│   └── intergration/
│       └── Interactions.t.sol
│
├── lib/
├── broadcast/
├── foundry.toml
├── .env
├── .gitignore
└── README.md
```

## Requirements

Before getting started, install:

- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/)
- [MetaMask](https://metamask.io/)
- An Ethereum Sepolia wallet with test ETH.
- A Chainlink VRF V2.5 subscription funded with LINK.

## Installation

Clone the repository:

```bash
git clone <YOUR_REPOSITORY_URL>
```

Navigate into the project:

```bash
cd smart-conract-lottery-f23
```

Install dependencies:

```bash
forge install
```

Build the project:

```bash
forge build
```

## Environment Configuration

Create a `.env` file in the project root:

```env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=YOUR_WALLET_PRIVATE_KEY
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
```

Load the environment variables:

```bash
set -a
source .env
set +a
```

**Security:** Never commit your `.env` file or expose your private key. Ensure `.env` is included in `.gitignore`.

## Chainlink VRF Configuration

The project uses Chainlink VRF V2.5 to generate verifiable random numbers.

The Sepolia configuration includes:

| Parameter | Value |
|---|---|
| Network | Ethereum Sepolia |
| Chain ID | 11155111 |
| VRF Coordinator | `0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B` |
| Gas Lane / Key Hash | `0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae` |
| Subscription ID | Configured in `HelperConfig.s.sol` |
| Callback Gas Limit | 500000 |
| Entrance Fee | 0.01 ETH |
| Raffle Interval | 30 seconds |

Before using the Sepolia network:

1. Create a Chainlink VRF V2.5 subscription.
2. Fund the subscription with LINK.
3. Deploy the raffle contract.
4. Register the deployed raffle contract as a VRF consumer.
5. Confirm that the subscription has sufficient funds.

Official resource: [Chainlink VRF Documentation](https://docs.chain.link/vrf)

## Running Tests

Run all tests:

```bash
forge test
```

Run only raffle unit tests:

```bash
forge test --match-path test/uint/RaffleTest.t.sol
```

Run integration tests:

```bash
forge test --match-path test/intergration/Interactions.t.sol
```

Run tests with detailed execution traces:

```bash
forge test -vvvv
```

Generate a coverage report:

```bash
forge coverage
```

### Test Coverage

The project includes tests for:

- Initial raffle state.
- Participant entry and entrance fee validation.
- Player recording and event emission.
- Upkeep conditions.
- Raffle state transitions.
- Prevention of entries during winner selection.
- Random winner selection.
- Prize transfer and raffle reset.
- LINK token transfer-and-call integration.

## Deployment

### Local Anvil Network

Start a local blockchain:

```bash
anvil
```

In another terminal, deploy the raffle:

```bash
forge script script/DeployRaffle.s.sol:DeployRaffle \
--rpc-url http://127.0.0.1:8545 \
--broadcast
```

### Ethereum Sepolia Testnet

Load your environment variables:

```bash
set -a
source .env
set +a
```

Verify your network connection:

```bash
cast chain-id --rpc-url "$SEPOLIA_RPC_URL"
```

Expected chain ID:

```text
11155111
```

Deploy the raffle:

```bash
forge script script/DeployRaffle.s.sol:DeployRaffle \
--rpc-url "$SEPOLIA_RPC_URL" \
--broadcast
```

Make sure your VRF subscription is funded and that the deployed raffle contract is registered as a consumer.

## Automation

The raffle implements the upkeep interface functions:

- `checkUpkeep()` determines whether the raffle is ready to execute.
- `performUpkeep()` initiates the random number request.

These functions provide the on-chain logic needed for automated execution. An external automation service or compatible workflow must trigger `performUpkeep()`; implementing these functions alone does not register an active upkeep.

## Important Security Considerations

- Never expose private keys or API credentials.
- Use test networks before deploying to mainnet.
- Ensure the VRF subscription has sufficient funding.
- Register the correct raffle contract as a VRF consumer.
- Test prize transfers and failure conditions.
- Do not rely on predictable randomness for winner selection.

## Future Improvements

- Integrate a supported automation workflow for automatic raffle execution.
- Develop a frontend interface for participants.
- Add an event-based raffle history.
- Support multiple raffle configurations.
- Deploy and verify the contract on additional networks.

## Author

**Kren Muts**

Solidity | Smart Contract Development | Blockchain Technology

## License

This project is licensed under the MIT License.