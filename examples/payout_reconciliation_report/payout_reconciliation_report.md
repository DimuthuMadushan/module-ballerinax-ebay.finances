# Payout reconciliation report

This example lists the most recent seller payouts, retrieves the details of each one, and totals the credit and debit transactions that make up the payout. It helps a seller confirm that what eBay paid out matches the underlying sales, refunds and fees.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An eBay developer keyset and a user refresh token with the `sell.finances` scope
- Create a `Config.toml` in this directory:

  ```toml
  clientId = "<Client ID>"
  clientSecret = "<Client Secret>"
  refreshToken = "<Refresh Token>"
  refreshUrl = "https://api.ebay.com/identity/v1/oauth2/token"
  payoutCount = 3
  ```

## Run the example

```bash
bal run
```
