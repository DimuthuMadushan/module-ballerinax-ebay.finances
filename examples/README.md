# Examples

The `ballerinax/ebay.finances` connector provides practical examples illustrating usage in various scenarios.

1. [Payout reconciliation report](./payout_reconciliation_report/payout_reconciliation_report.md) - Lists recent payouts and totals the credits and debits of the transactions behind each one.
2. [Seller fee audit](./seller_fee_audit/seller_fee_audit.md) - Combines the funds summary, a transaction summary and the billing activity for a date range to show where fees went.

## Prerequisites

1. Generate eBay application keys and a user refresh token with the `https://api.ebay.com/oauth/api_scope/sell.finances` scope, as described in the [setup guide](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/blob/main/ballerina/README.md#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    clientId = "<Client ID>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Refresh Token>"
    refreshUrl = "https://api.ebay.com/identity/v1/oauth2/token"
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
