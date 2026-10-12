# Ballerina eBay Finances connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-ebay.finances.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.finances/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/ebay.finances.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Febay.finances)

## Overview

The eBay Finances connector lets Ballerina applications retrieve a seller's payouts, funds, billing activity and monetary transaction details from the [eBay Finances API](https://developer.ebay.com/api-docs/sell/finances/overview.html). It supports version v1.19.1 of the API, which is used by sellers to reconcile what eBay has paid out against the individual sales, refunds, fees and transfers behind each payout.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`ebay.finances` package](https://central.ballerina.io/ballerinax/ebay.finances/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
