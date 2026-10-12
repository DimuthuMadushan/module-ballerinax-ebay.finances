// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://apiz.ebay.com/sell/finances/v1" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("EBAY_ACCESS_TOKEN") : "test_token";

final Client ebay = check new ({
    auth: {token},
    httpVersion: isLiveServer ? http:HTTP_2_0 : http:HTTP_1_1
}, serviceUrl);

const MarketplaceIdEnum MARKETPLACE = "EBAY_US";

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListTransactions() returns error? {
    Transactions|error? response = ebay->listTransactions({xEBAYCMARKETPLACEID: MARKETPLACE}, {'limit: 20});
    if response is Transactions {
        test:assertTrue(response.transactions.length() > 0);
    } else {
        test:assertFail("Expected transactions");
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetTransactionSummary() returns error? {
    TransactionSummaryResponse response = check ebay->getTransactionSummary({xEBAYCMARKETPLACEID: MARKETPLACE},
        {filter: ["transactionDate:[2026-01-01T00:00:00.000Z..2026-03-31T00:00:00.000Z]"]});
    test:assertTrue(response?.creditCount !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListBillingActivities() returns error? {
    BillingActivityResponse response = check ebay->listBillingActivities({}, {filter: "billingTransactionDate:[2026-03-01T00:00:00.000Z..2026-03-31T00:00:00.000Z]"});
    test:assertTrue(response.billingActivities.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListOrderEarnings() returns error? {
    OrderEarnings response = check ebay->listOrderEarnings({xEBAYCMARKETPLACEID: MARKETPLACE});
    test:assertTrue((response.orders ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetOrderEarning() returns error? {
    OrderEarning response = check ebay->getOrderEarning("27-12345-67890", {xEBAYCMARKETPLACEID: MARKETPLACE});
    test:assertTrue(response?.orderId !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetOrderEarningsSummary() returns error? {
    OrderEarningsSummary response = check ebay->getOrderEarningsSummary({xEBAYCMARKETPLACEID: MARKETPLACE});
    test:assertTrue(response?.grossAmount !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListPayouts() returns error? {
    Payouts|error? response = ebay->listPayouts({xEBAYCMARKETPLACEID: MARKETPLACE});
    if response is Payouts {
        test:assertTrue(response.payouts.length() > 0);
    } else {
        test:assertFail("Expected payouts");
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPayout() returns error? {
    Payout response = check ebay->getPayout("5000012345", {xEBAYCMARKETPLACEID: "EBAY_US"});
    test:assertEquals(response.payoutId, "5000012345");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPayoutSummary() returns error? {
    PayoutSummaryResponse response = check ebay->getPayoutSummary({xEBAYCMARKETPLACEID: MARKETPLACE});
    test:assertTrue(response.payoutCount > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSellerFundsSummary() returns error? {
    SellerFundsSummaryResponse|error? response = ebay->getSellerFundsSummary({xEBAYCMARKETPLACEID: MARKETPLACE});
    if response is SellerFundsSummaryResponse {
        test:assertTrue(response.availableFunds.value.length() > 0);
    } else {
        test:assertFail("Expected seller funds summary");
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetTransfer() returns error? {
    Transfer response = check ebay->getTransfer("TR-1001", {xEBAYCMARKETPLACEID: "EBAY_US"});
    test:assertEquals(response.transferId, "TR-1001");
}
