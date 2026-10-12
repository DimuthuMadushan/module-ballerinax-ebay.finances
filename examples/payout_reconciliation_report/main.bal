// Reconciles the most recent seller payouts with the transactions that make them up.

import ballerina/io;
import ballerinax/ebay.finances;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

final finances:MarketplaceIdEnum marketplaceId = "EBAY_US";
configurable int payoutCount = 3;

public function main() returns error? {
    finances:Client ebay = check new ({
        auth: {clientId, clientSecret, refreshToken, refreshUrl}
    });

    finances:Payouts|error? payoutsResult = ebay->listPayouts({xEBAYCMARKETPLACEID: marketplaceId}, {'limit: payoutCount});
    if payoutsResult is error {
        return payoutsResult;
    }
    if payoutsResult !is finances:Payouts {
        return error("No payouts were returned for marketplace " + marketplaceId);
    }

    foreach finances:Payout summary in payoutsResult.payouts {
        finances:Payout payout = check ebay->getPayout(summary.payoutId, {xEBAYCMARKETPLACEID: marketplaceId});
        io:println(string `Payout ${payout.payoutId} (${payout.payoutStatus}) on ${payout.payoutDate}: ${payout.amount.value} ${payout.amount.currency}`);

        int offset = 0;
        int pageSize = 200;
        int count = 0;
        decimal credits = 0d;
        decimal debits = 0d;
        while true {
            finances:Transactions|error? txResult = ebay->listTransactions({xEBAYCMARKETPLACEID: marketplaceId},
                {filter: [string `payoutId:{${payout.payoutId}}`], 'limit: pageSize, offset});
            if txResult is error {
                return txResult;
            }
            if txResult !is finances:Transactions {
                break;
            }
            foreach finances:Transaction tx in txResult.transactions {
                decimal value = check decimal:fromString(tx.amount.value);
                if tx.bookingEntry == "CREDIT" {
                    credits += value;
                } else {
                    debits += value;
                }
            }
            count += txResult.transactions.length();
            if txResult.transactions.length() < pageSize {
                break;
            }
            offset += pageSize;
        }
        if count == 0 {
            io:println("  No transactions found for this payout");
            continue;
        }
        io:println(string `  ${count} transactions: credits ${credits}, debits ${debits}`);
    }
}
