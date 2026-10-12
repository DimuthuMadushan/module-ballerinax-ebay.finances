## Overview

The eBay Finances connector lets Ballerina applications retrieve a seller's payouts, funds, billing activity and monetary transaction details from the [eBay Finances API](https://developer.ebay.com/api-docs/sell/finances/overview.html). It supports version v1.19.1 of the API, which is used by sellers to reconcile what eBay has paid out against the individual sales, refunds, fees and transfers behind each payout.

### Key features

- Retrieve seller payouts, and look up a single payout by its ID
- Search monetary transactions by date, type or payout, and summarise them for a period
- Review the funds available, processing and on hold in the seller's account
- Inspect order-level earnings, including gross amounts, expenses and refunds
- Access billing activity such as the fees eBay charged, and the details of a transfer

## Setup guide

To use the connector, you need an eBay developer account and a user access token that grants the `sell.finances` scope.

1. Sign up for the [eBay Developers Program](https://developer.ebay.com/) and sign in.

2. Open the [Application Keys](https://developer.ebay.com/my/keys) page and create a keyset for the Production environment. Note the **App ID (Client ID)** and the **Cert ID (Client Secret)**.

3. Under **User Tokens** for the keyset, add an OAuth redirect URL (RuName) for your application.

4. Direct the seller to eBay's consent page using the RuName and the scopes `https://api.ebay.com/oauth/api_scope/sell.finances` and, for order earnings, `https://api.ebay.com/oauth/api_scope/sell.finances.earnings.read`.

5. Exchange the authorization code returned to your redirect URL for a user token at `https://api.ebay.com/identity/v1/oauth2/token`, and keep the **refresh token** from the response.

> **Note:** Finances API calls made on behalf of EU and UK sellers also require a digital signature. See eBay's [Digital Signatures for APIs](https://developer.ebay.com/develop/guides/digital-signatures-for-apis) guide.

## Quickstart

To use the eBay Finances connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/ebay.finances;
```

### Step 2: Create a `Config.toml` file

```toml
clientId = "<Client ID>"
clientSecret = "<Client Secret>"
refreshToken = "<Refresh Token>"
```

### Step 3: Create a client

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final finances:Client ebay = check new ({
    auth: {clientId, clientSecret, refreshToken}
});
```

### Step 4: Invoke an operation

```ballerina
public function main() returns error? {
    finances:PayoutSummaryResponse _ = check ebay->getPayoutSummary({xEBAYCMARKETPLACEID: "EBAY_US"});
}
```

## Examples

The eBay Finances connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/tree/main/examples/), covering the following use cases:

1. [Payout reconciliation report](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/tree/main/examples/payout_reconciliation_report) - Lists recent payouts and totals the credits and debits of the transactions behind each one.
2. [Seller fee audit](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/tree/main/examples/seller_fee_audit) - Combines the funds summary, a transaction summary and the billing activity for a date range to show where fees went.
