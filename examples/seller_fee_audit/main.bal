// Audits seller funds and the fees billed over a date range.

import ballerina/io;
import ballerinax/ebay.finances;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

final finances:MarketplaceIdEnum marketplaceId = "EBAY_US";
configurable string fromDate = ?;
configurable string toDate = ?;

public function main() returns error? {
    finances:Client ebay = check new ({
        auth: {clientId, clientSecret, refreshToken, refreshUrl}
    });

    finances:SellerFundsSummaryResponse|error? funds = ebay->getSellerFundsSummary({xEBAYCMARKETPLACEID: marketplaceId});
    if funds is error {
        return funds;
    }
    if funds !is finances:SellerFundsSummaryResponse {
        return error("The seller funds summary is not available for this account");
    }
    io:println(string `Available: ${funds.availableFunds.value} ${funds.availableFunds.currency}, processing: ${funds.processingFunds.value}, on hold: ${funds.fundsOnHold.value}`);

    string dateRange = string `[${fromDate}..${toDate}]`;
    finances:TransactionSummaryResponse summary = check ebay->getTransactionSummary({xEBAYCMARKETPLACEID: marketplaceId},
        {filter: [string `transactionDate:${dateRange}`]});
    io:println(string `Sales: ${summary?.creditCount ?: 0}, refunds: ${summary?.refundCount ?: 0}, non-sale charges: ${summary?.nonSaleChargeCount ?: 0}`);

    int offset = 0;
    int pageSize = 100;
    decimal totalBilled = 0d;
    map<decimal> byFeeType = {};
    while true {
        finances:BillingActivityResponse page = check ebay->listBillingActivities({}, {
            filter: string `transactionDate:${dateRange}`,
            'limit: pageSize.toString(),
            offset: offset.toString()
        });
        foreach finances:BillingActivityLineItem item in page.billingActivities {
            decimal amount = check decimal:fromString(item.amount.value);
            totalBilled += amount;
            byFeeType[item.feeType] = (byFeeType[item.feeType] ?: 0d) + amount;
        }
        if page.billingActivities.length() < pageSize {
            break;
        }
        offset += pageSize;
    }

    io:println(string `Total billed between ${fromDate} and ${toDate}: ${totalBilled}`);
    foreach [string, decimal] [feeType, amount] in byFeeType.entries() {
        io:println(string `  ${feeType}: ${amount}`);
    }
}
