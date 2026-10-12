_Author_:  Dimuthu Madushan \
_Created_: 2026/10/12 \
_Updated_: 2026/10/12 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from eBay Finances.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/ebay/finances/v1/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Removed the second global server (`https://api.ebay.com` with base path `/sell/finances/v1/billing_activity`) and the path-level `servers` override on `/billing_activity`. Both appended `/billing_activity` to a path that already ends in it. Every operation now uses the single server `https://apiz.ebay.com/sell/finances/v1`, written as a plain URL instead of a `{basePath}` variable.

2. Removed the duplicate paths `/payout/{payout_id}` and `/transfer/{transfer_id}`. They repeated `/payout/{payout_Id}` and `/transfer/{transfer_Id}` with the same `getPayout` and `getTransfer` operationIds, so the spec documented two operations on one method and path. The `{payout_Id}` and `{transfer_Id}` variants are kept.

3. Reduced the security definitions to the one scheme the operations use. Removed the unused `bearerAuth`, `oauth2_api_scope_sell_finances` and `oauth2_api_scope_sell_finances_earnings` schemes and the references to them in each operation's `security`, added the `https://api.ebay.com/oauth/api_scope/sell.finances.earnings.read` scope to `api_auth`, and replaced the empty top-level `security: [{}]` with `api_auth` and the `sell.finances` scope.

4. Changed `openapi` from `3.1.0` to `3.0.1`. Under 3.1.0, `bal openapi flatten` drops `type: string` from the path parameters, and the generator then skips the three operations that take one (`getOrderEarning`, `getPayout`, `getTransfer`). The spec uses no 3.1-only features.

5. Added a summary to each of the 11 operations, which had none (for example `List payouts`, `Get a transfer`).

6. Renamed operations, kept stable through `ai-mappings.json`: `getOrderEarnings` to `listOrderEarnings`, `getOrderEarningsById` to `getOrderEarning`, `getPayouts` to `listPayouts`, `getTransactions` to `listTransactions` and `getBillingActivities` to `listBillingActivities`. The other six operationIds are unchanged.

7. Edit to the aligned spec (`aligned_ballerina_openapi.json`) that must be re-applied after a re-align: `tooling/sanitize_spec.py` rewrote the generic `Success` response descriptions from the operationIds. It is idempotent and runs again in `postfix.py`.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```
Note: The license year is hardcoded to 2024, change if necessary.
