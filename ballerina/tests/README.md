# Tests

The test suite covers every operation exposed by the connector: listing and retrieving payouts, listing transactions and summarising them, the seller funds summary, order earnings (list, by order and summary), billing activities and transfers.

Each test calls the connector against a mock service (`tests/mock_service.bal`) that serves schema-shaped sample data on `http://localhost:9090`, so no credentials are needed to run them.

## Running tests

```bash
bal test
```

To run the tests against the live eBay Finances API instead of the mock, set the following environment variables:

| Variable | Description |
|---|---|
| `IS_LIVE_SERVER` | Set to `true` to target `https://apiz.ebay.com/sell/finances/v1` |
| `EBAY_ACCESS_TOKEN` | A user access token with the `sell.finances` and `sell.finances.earnings.read` scopes |

```bash
IS_LIVE_SERVER=true EBAY_ACCESS_TOKEN=<token> bal test --groups live_tests
```

The live tests read data only, but several of them use fixed identifiers (for example a payout or transfer ID), so a live run needs those to exist in the account.
