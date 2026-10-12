# Seller fee audit

This example reports the seller's available, processing and on-hold funds, summarises transactions for a date range, and pages through the billing activity to total the fees eBay charged by fee type. Use it to see where selling costs went in a period.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An eBay developer keyset and a user refresh token with the `sell.finances` scope
- Create a `Config.toml` in this directory:

  ```toml
  clientId = "<Client ID>"
  clientSecret = "<Client Secret>"
  refreshToken = "<Refresh Token>"
  refreshUrl = "https://api.ebay.com/identity/v1/oauth2/token"
  fromDate = "2026-03-01T00:00:00.000Z"
  toDate = "2026-03-31T23:59:59.999Z"
  ```

## Run the example

```bash
bal run
```
